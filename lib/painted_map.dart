import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_playground/gen/assets.gen.dart';
import 'package:google_maps_flutter_playground/pages/add_edit_text_page.dart';
import 'package:google_maps_flutter_playground/utils/determin_position.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_painter/simple_painter.dart';
import 'package:uuid/uuid.dart';

part 'painted_map.freezed.dart';
part 'painted_map.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await determinePosition();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PaintedMap());
  }
}

class PaintedMap extends HookConsumerWidget {
  const PaintedMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mapControllerProvider);
    final showPainter = useState(false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('GroundOverlayPainter'),
        actions: [
          IconButton(
            icon: Icon(showPainter.value ? Icons.edit_off : Icons.edit),
            onPressed: () => showPainter.value = !showPainter.value,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _PaintedMapView(),
          if (showPainter.value)
            _MapAnnotationPainter(
              onFinish: () {
                showPainter.value = false;
              },
            ),
        ],
      ),
    );
  }
}

class _PaintedMapView extends HookConsumerWidget {
  const _PaintedMapView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markers = ref.watch(markersNotifierProvider);

    final lastKnownPosition = useMemoized(
      () => Geolocator.getLastKnownPosition(),
    );

    return FutureBuilder(
      future: lastKnownPosition,
      builder: (context, snapshot) {
        final position = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting ||
            position == null) {
          return const SizedBox.shrink();
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            zoom: 18,
            target: LatLng(position.latitude, position.longitude),
          ),
          onMapCreated: (controller) {
            final completer = ref.read(mapControllerProvider);
            if (!completer.isCompleted) {
              completer.complete(controller);
            }
          },
          markers: markers,
        );
      },
    );
  }
}

class _MapAnnotationPainter extends HookConsumerWidget {
  const _MapAnnotationPainter({required this.onFinish});

  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        return HookBuilder(
          builder: (context) {
            final controllerFuture = useMemoized(() async {
              final bytes = await rootBundle.load(
                Assets.images.transparent.path,
              );
              return PainterController(
                backgroundImage: bytes.buffer.asUint8List(),
                settings: PainterSettings(size: canvasSize),
              );
            });

            return FutureBuilder(
              future: controllerFuture,
              builder: (context, snapshot) {
                final controller = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting ||
                    controller == null) {
                  return const SizedBox.shrink();
                }

                return Stack(
                  children: [
                    PainterWidget(controller: controller, boundaryMargin: 0),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.paddingOf(context).bottom,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                controller.addShape(ShapeType.arrow);
                                final selectedItem =
                                    controller.value.selectedItem;
                                if (selectedItem is ShapeItem) {
                                  controller.changeShapeValues(
                                    selectedItem.copyWith(
                                      lineColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 24),
                            IconButton(
                              icon: const Icon(Icons.text_fields),
                              onPressed: () async {
                                await Navigator.of(context).push<String>(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return AddEditTextPage(
                                        defaultText: null,
                                        onDone: (textFunction) {
                                          controller.addText(textFunction);
                                        },
                                      );
                                    },
                                  ),
                                );

                                final selectedItem =
                                    controller.value.selectedItem;
                                if (selectedItem is TextItem) {
                                  controller.changeItemProperties(
                                    selectedItem.copyWith(
                                      size: const SizeModel(
                                        width: 200,
                                        height: 80,
                                      ),
                                    ),
                                  );

                                  controller.changeTextValues(
                                    selectedItem.copyWith(
                                      textStyle: const TextStyle(
                                        fontSize: 48,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              onPressed: () async {
                                final items = controller.value.items;

                                final renderItemFutures =
                                    items.map((item) async {
                                      final bytes = await controller.renderItem(
                                        item,
                                        enableRotation: true,
                                      );
                                      if (bytes == null) return null;

                                      final absX =
                                          item.position.x +
                                          canvasSize.width / 2;
                                      final absY =
                                          item.position.y +
                                          canvasSize.height / 2;

                                      return ItemData(
                                        position: Offset(absX, absY),
                                        item: bytes,
                                      );
                                    }).toList();

                                final results = await Future.wait(
                                  renderItemFutures,
                                );
                                final itemDataList =
                                    results.whereType<ItemData>().toList();

                                await ref
                                    .read(markersNotifierProvider.notifier)
                                    .update(itemDataList);

                                onFinish();
                              },
                              icon: const Icon(Icons.arrow_downward),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

@freezed
abstract class ItemData with _$ItemData {
  const factory ItemData({required Offset position, required Uint8List item}) =
      _ItemData;
}

@riverpod
class MarkersNotifier extends _$MarkersNotifier {
  late final Completer<GoogleMapController> _controller;

  @override
  Set<Marker> build() {
    _controller = ref.watch(mapControllerProvider);
    return {};
  }

  Future<void> update(List<ItemData> items) async {
    final controller = await _controller.future;

    final List<Marker> markers = [];

    for (final data in items) {
      final screen = ScreenCoordinate(
        x: data.position.dx.round(),
        y: data.position.dy.round(),
      );
      final latLng = await controller.getLatLng(screen);

      final icon = BitmapDescriptor.bytes(data.item);
      final id = const Uuid().v4();

      markers.add(
        Marker(
          markerId: MarkerId(id),
          position: latLng,
          icon: icon,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    final newState = {...state, ...markers.toSet()};
    state = newState;
  }
}

@riverpod
Completer<GoogleMapController> mapController(Ref ref) {
  return Completer<GoogleMapController>();
}
