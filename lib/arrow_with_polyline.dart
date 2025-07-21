import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_playground/gen/assets.gen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/v7.dart';

part 'arrow_with_polyline.freezed.dart';
part 'arrow_with_polyline.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EagerInitialization(
      child: MaterialApp(home: ArrowWithPolyline()),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mapControllerProvider);
    return child;
  }
}

class ArrowWithPolyline extends StatelessWidget {
  const ArrowWithPolyline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            ArrowMapView(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: PolylineActionControls(),
            ),
            CenterMarker(),
          ],
        ),
      ),
    );
  }
}

class ArrowMapView extends ConsumerWidget {
  const ArrowMapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polylines = ref.watch(arrowPolylinesNotifierProvider);
    final currentPolyline = ref.watch(polylinePreviewNotifierProvider);
    final arrowMarkers = ref.watch(arrowMarkersNotifierProvider);

    return GoogleMap(
      mapType: MapType.normal,
      buildingsEnabled: false,
      rotateGesturesEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      polylines:
          currentPolyline == null ? polylines : {...polylines, currentPolyline},
      markers: arrowMarkers,
      initialCameraPosition: const CameraPosition(
        target: LatLng(35.705373301512175, 139.75211534052752),
        zoom: 16,
      ),
      onMapCreated: (controller) {
        final completer = ref.read(mapControllerProvider);
        if (completer.isCompleted) {
          ref.invalidate(mapControllerProvider);
        }

        ref.read(mapControllerProvider.notifier).setMapController(controller);
      },
      onCameraMove: (position) {
        ref
            .read(polylinePreviewNotifierProvider.notifier)
            .onCameraMove(position.target);
      },
      onTap: (argument) {
        ref.read(highlightedPolylineIdNotifierProvider.notifier).clear();
      },
    );
  }
}

class PolylineActionControls extends ConsumerWidget {
  const PolylineActionControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPolylineId = ref.watch(activePolylineIdNotifierProvider);
    final selectedPolylineId = ref.watch(highlightedPolylineIdNotifierProvider);
    final polylines = ref.watch(arrowPolylinesNotifierProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (currentPolylineId == null)
            ElevatedButton(
              onPressed: () async {
                ref
                    .read(arrowPolylinesNotifierProvider.notifier)
                    .clearIncompletePolylines();
                final centerLatLng =
                    await ref
                        .read(mapControllerProvider.notifier)
                        .getCenterLatLng();
                if (!context.mounted || centerLatLng == null) return;

                ref
                    .read(centerMarkerNotifierProvider.notifier)
                    .select(CenterMarkerData(image: Assets.images.pin));

                final polylineId = const UuidV7().generate();
                ref
                    .read(arrowPolylinesNotifierProvider.notifier)
                    .addPolyline(
                      Polyline(
                        width: 5,
                        zIndex: 10,
                        color: const Color(0xFFFF0000),
                        consumeTapEvents: true,
                        polylineId: PolylineId(polylineId),
                        points: [centerLatLng],
                        onTap: () {
                          ref
                              .read(
                                highlightedPolylineIdNotifierProvider.notifier,
                              )
                              .select(polylineId);
                        },
                      ),
                    );

                ref
                    .read(activePolylineIdNotifierProvider.notifier)
                    .select(polylineId);
              },
              child: const Text('Add Arrow'),
            ),
          if (currentPolylineId != null) ...[
            ElevatedButton(
              onPressed: () async {
                ref
                    .read(highlightedPolylineIdNotifierProvider.notifier)
                    .clear();
                final centerLatLng =
                    await ref
                        .read(mapControllerProvider.notifier)
                        .getCenterLatLng();
                if (!context.mounted) return;

                if (centerLatLng != null) {
                  ref
                      .read(arrowPolylinesNotifierProvider.notifier)
                      .addPoints(currentPolylineId, centerLatLng);
                }
              },
              child: const Text('Add Waypoint'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(highlightedPolylineIdNotifierProvider.notifier)
                    .clear();
                ref.read(activePolylineIdNotifierProvider.notifier).clear();
                ref.read(polylinePreviewNotifierProvider.notifier).clear();
                ref.read(centerMarkerNotifierProvider.notifier).clear();
                ref
                    .read(arrowPolylinesNotifierProvider.notifier)
                    .clearIncompletePolylines();
              },
              child: const Text('Complete'),
            ),
          ],

          if (selectedPolylineId != null && polylines.isNotEmpty) ...[
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(arrowPolylinesNotifierProvider.notifier)
                    .remove(selectedPolylineId);
                ref
                    .read(highlightedPolylineIdNotifierProvider.notifier)
                    .clear();
              },
              child: const Text('Remove'),
            ),
          ],
        ],
      ),
    );
  }
}

class CenterMarker extends ConsumerWidget {
  const CenterMarker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final centerMarker = ref.watch(centerMarkerNotifierProvider).image;
    if (centerMarker == null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder(
      future: ref.read(mapControllerProvider.notifier).getCenterScreenPoint(),
      builder: (_, snapshot) {
        final centerPoint = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            centerPoint == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: centerPoint.x - 48 / 2,
          top: centerPoint.y - 48,
          child: centerMarker.image(width: 48, height: 48),
        );
      },
    );
  }
}

@riverpod
class CenterMarkerNotifier extends _$CenterMarkerNotifier {
  @override
  CenterMarkerData build() {
    return const CenterMarkerData();
  }

  void select(CenterMarkerData data) => state = data;

  void clear() => state = const CenterMarkerData();
}

@freezed
abstract class CenterMarkerData with _$CenterMarkerData {
  const factory CenterMarkerData({AssetGenImage? image}) = _CenterMarkerData;
}

@riverpod
Future<({BitmapDescriptor chevronUpRed, BitmapDescriptor chevronUpBlue})>
arrowIcon(Ref ref) async {
  final dpr = PlatformDispatcher.instance.views.first.devicePixelRatio;
  return (
    chevronUpRed: await BitmapDescriptor.asset(
      ImageConfiguration(devicePixelRatio: dpr),
      Assets.images.chevronUpRed.path,
      width: 48,
      height: 48,
    ),
    chevronUpBlue: await BitmapDescriptor.asset(
      ImageConfiguration(devicePixelRatio: dpr),
      Assets.images.chevronUpBlue.path,
      width: 48,
      height: 48,
    ),
  );
}

@riverpod
class MapController extends _$MapController {
  final _devicePixelRatio =
      PlatformDispatcher.instance.views.first.devicePixelRatio;
  late Completer<GoogleMapController> _mapController;
  Point<int>? _centerScreenPoint;

  @override
  Completer<GoogleMapController> build() {
    _mapController = Completer<GoogleMapController>();
    return _mapController;
  }

  Future<void> setMapController(GoogleMapController controller) async {
    assert(
      !_mapController.isCompleted,
      'GoogleMapController is already set. setMapController must be called only once.',
    );
    _mapController.complete(controller);
  }

  Future<LatLngBounds> getVisibleRegion() async {
    final controller = await _mapController.future;
    return await controller.getVisibleRegion();
  }

  Future<LatLng?> getCenterLatLng() async {
    final visibleRegion = await getVisibleRegion();
    final northeast = visibleRegion.northeast;
    final southwest = visibleRegion.southwest;
    if (northeast == southwest) {
      return null;
    }

    return LatLng(
      (northeast.latitude + southwest.latitude) / 2,
      (northeast.longitude + southwest.longitude) / 2,
    );
  }

  Future<Point<int>?> getCenterScreenPoint() async {
    if (_centerScreenPoint != null) {
      return _centerScreenPoint;
    }
    _centerScreenPoint = await _calculateCenterScreenPoint();
    return _centerScreenPoint;
  }

  Future<Point<int>?> _calculateCenterScreenPoint() async {
    final centerLatLng = await getCenterLatLng();
    if (centerLatLng == null) {
      return null;
    }

    final controller = await _mapController.future;
    final screenPoint = await controller.getScreenCoordinate(centerLatLng);
    if (defaultTargetPlatform == TargetPlatform.android) {
      // see... https://github.com/flutter/flutter/issues/41653
      return Point<int>(
        (screenPoint.x / _devicePixelRatio).round(),
        (screenPoint.y / _devicePixelRatio).round(),
      );
    }

    return Point<int>(screenPoint.x, screenPoint.y);
  }
}

@riverpod
class ArrowPolylinesNotifier extends _$ArrowPolylinesNotifier {
  @override
  Set<Polyline> build() {
    ref.listen(highlightedPolylineIdNotifierProvider, (_, next) {
      if (next != null) {
        state =
            state.map((p) {
              if (p.polylineId.value == next) {
                return p.copyWith(colorParam: const Color(0xFF0400FF));
              }
              return p.copyWith(colorParam: const Color(0xFFFF0000));
            }).toSet();
      }
    });

    return {};
  }

  void addPolyline(Polyline polyline) {
    state = {...state, polyline};
  }

  void addPoints(String polylineId, LatLng point) {
    state =
        state.map((p) {
          if (p.polylineId.value == polylineId) {
            final newPoints = [...p.points, point];
            return p.copyWith(pointsParam: newPoints);
          }
          return p;
        }).toSet();
  }

  void remove(String polylineId) {
    state = state.where((p) => p.polylineId.value != polylineId).toSet();
  }

  void clearIncompletePolylines() {
    state = state.where((p) => p.points.length >= 2).toSet();
  }
}

@riverpod
class ActivePolylineIdNotifier extends _$ActivePolylineIdNotifier {
  @override
  String? build() => null;

  void select(String polylineId) => state = polylineId;

  void clear() => state = null;
}

@riverpod
class HighlightedPolylineIdNotifier extends _$HighlightedPolylineIdNotifier {
  @override
  String? build() => null;

  void select(String polylineId) => state = polylineId;

  void clear() => state = null;
}

@riverpod
class ArrowMarkersNotifier extends _$ArrowMarkersNotifier {
  @override
  Set<Marker> build() {
    final Set<Polyline> polylines = ref.watch(arrowPolylinesNotifierProvider);
    final icons = ref.watch(arrowIconProvider).valueOrNull;
    if (icons == null) {
      return {};
    }

    final (:chevronUpRed, :chevronUpBlue) = icons;

    ref.listen(highlightedPolylineIdNotifierProvider, (_, next) {
      if (next != null) {
        state =
            state.map((marker) {
              if (marker.markerId.value == next) {
                return marker.copyWith(iconParam: chevronUpBlue);
              }
              return marker.copyWith(iconParam: chevronUpRed);
            }).toSet();
      }
    });

    return polylines.where((p) => p.points.length >= 2).map((polyline) {
      final pts = polyline.points;
      final prev = pts[pts.length - 2];
      final last = pts.last;
      final rawBearing = Geolocator.bearingBetween(
        prev.latitude,
        prev.longitude,
        last.latitude,
        last.longitude,
      );
      final rotation = (rawBearing + 360) % 360;

      return Marker(
        markerId: MarkerId(polyline.polylineId.value),
        position: last,
        icon: chevronUpRed,
        rotation: rotation,
        anchor: const Offset(0.5, 0.5),
        consumeTapEvents: true,
        onTap: () {
          ref
              .read(highlightedPolylineIdNotifierProvider.notifier)
              .select(polyline.polylineId.value);
        },
      );
    }).toSet();
  }
}

@riverpod
class PolylinePreviewNotifier extends _$PolylinePreviewNotifier {
  @override
  Polyline? build() => null;

  void onCameraMove(LatLng target) {
    final currentPolylineId = ref.read(activePolylineIdNotifierProvider);
    if (currentPolylineId == null) {
      state = null;
      return;
    }

    final targetPolyline = ref
        .read(arrowPolylinesNotifierProvider)
        .firstWhereOrNull(
          (p) => p.polylineId.value == currentPolylineId && p.points.isNotEmpty,
        );

    if (targetPolyline == null) {
      state = null;
      return;
    }

    state = Polyline(
      width: 6,
      color: Colors.black45,
      polylineId: const PolylineId('current-polyline'),
      points: [targetPolyline.points.last, target],
    );
  }

  void clear() => state = null;
}
