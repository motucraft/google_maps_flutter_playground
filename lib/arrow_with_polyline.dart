import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_playground/gen/assets.gen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'arrow_with_polyline.freezed.dart';
part 'arrow_with_polyline.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _determinePosition();

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

class ArrowWithPolyline extends HookConsumerWidget {
  const ArrowWithPolyline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final controllerRef = useRef<GoogleMapController?>(null);

    final start = const LatLng(35.706958863210886, 139.7536280629907);
    final end = const LatLng(35.70470243612385, 139.74951891889842);
    final middle = const LatLng(35.70672364021929, 139.75103704898194);
    final bearing = Geolocator.bearingBetween(
      middle.latitude,
      middle.longitude,
      end.latitude,
      end.longitude,
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            FutureBuilder(
              future: _loadArrowIcon(devicePixelRatio),
              builder: (context, snapshot) {
                final arrowCap = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting ||
                    arrowCap == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GoogleMap(
                  mapType: MapType.normal,
                  buildingsEnabled: false,
                  rotateGesturesEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(35.705373301512175, 139.75211534052752),
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {
                    // controllerRef.value = controller;
                    final completer = ref.read(mapControllerProvider);
                    if (!completer.isCompleted) {
                      completer.complete(controller);
                    }
                  },
                  // onCameraIdle: () {
                  //   final controller = controllerRef.value;
                  //   if (controller != null) {
                  //     final completer = ref.read(mapControllerProvider);
                  //     if (!completer.isCompleted) {
                  //       completer.complete(controller);
                  //     }
                  //   }
                  // },
                  polylines: {
                    Polyline(
                      width: 5,
                      zIndex: 10,
                      color: Colors.red,
                      consumeTapEvents: true,
                      polylineId: const PolylineId('1'),
                      points: [start, middle, end],
                      onTap: () {
                        debugPrint('onTap');
                      },
                    ),
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('arrow_end'),
                      position: end,
                      icon: arrowCap,
                      rotation: (bearing + 360) % 360,
                      anchor: const Offset(0.5, 0.5),
                    ),
                  },
                );
              },
            ),

            const CenterMarker(),
          ],
        ),
      ),
    );
  }

  Future<BitmapDescriptor> _loadArrowIcon(double devicePixelRatio) {
    return BitmapDescriptor.asset(
      ImageConfiguration(devicePixelRatio: devicePixelRatio),
      Assets.images.chevronUp.path,
      width: 48,
      height: 48,
    );
  }
}

class CenterMarker extends ConsumerWidget {
  const CenterMarker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    // final centerMarker = ref.watch(centerMarkerNotifierProvider).image;
    // if (centerMarker == null) {
    //   return const SizedBox.shrink();
    // }

    final controller = ref.watch(mapControllerProvider);

    return FutureBuilder(
      future: _calculateMapCenterScreenPoint(controller, devicePixelRatio),
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
          child: Assets.images.pin.image(width: 48, height: 48),
        );
      },
    );
  }

  Future<Point<int>?> _calculateMapCenterScreenPoint(
    Completer<GoogleMapController> controllerCompleter,
    double devicePixelRatio,
  ) async {
    final controller = await controllerCompleter.future;
    final visibleRegion = await controller.getVisibleRegion();

    final northeast = visibleRegion.northeast;
    final southwest = visibleRegion.southwest;
    if (northeast == southwest) {
      // Google Mapの初回ロードが安定するまでは異常値が返却されるため
      return null;
    }

    final mapCenter = LatLng(
      (northeast.latitude + southwest.latitude) / 2,
      (northeast.longitude + southwest.longitude) / 2,
    );

    // ref: https://github.com/flutter/flutter/issues/41653
    final screenPoint = await controller.getScreenCoordinate(mapCenter);
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Point<int>(
        (screenPoint.x / devicePixelRatio).round(),
        (screenPoint.y / devicePixelRatio).round(),
      );
    }

    return Point<int>(screenPoint.x, screenPoint.y);
  }
}

@riverpod
class CenterMarkerNotifier extends _$CenterMarkerNotifier {
  @override
  CenterMarkerData build() {
    return const CenterMarkerData();
  }

  void reset() => state = const CenterMarkerData();
}

@freezed
abstract class CenterMarkerData with _$CenterMarkerData {
  const factory CenterMarkerData({AssetGenImage? image}) = _CenterMarkerData;
}

@riverpod
Completer<GoogleMapController> mapController(Ref ref) {
  return Completer<GoogleMapController>();
}

// ref: https://pub.dev/packages/geolocator#example
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
