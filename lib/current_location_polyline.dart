import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_location_polyline.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _determinePosition();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CurrentLocationPolyline());
  }
}

class CurrentLocationPolyline extends ConsumerWidget {
  const CurrentLocationPolyline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final polyline = ref.watch(polylineNotifierProvider).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(35.68098868213622, 139.76707800637),
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: polyline != null ? {polyline} : {},
              onMapCreated: (controller) {
                ref
                    .read(mapControllerProvider.notifier)
                    .setMapController(controller);
              },
              onCameraMove: (position) {
                ref
                    .read(polylineNotifierProvider.notifier)
                    .onCameraMove(position);
              },
            ),
            const CenterWidget(),
          ],
        ),
      ),
    );
  }
}

class CenterWidget extends ConsumerWidget {
  const CenterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: getCenterScreenPoint(ref),
      builder: (context, snapshot) {
        final centerPoint = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            centerPoint == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: centerPoint.x - 28,
          top: centerPoint.y - 56,
          child: const Icon(Icons.add_location, color: Colors.red, size: 56),
        );
      },
    );
  }

  Future<Point<int>?> getCenterScreenPoint(WidgetRef ref) async {
    await ref.watch(mapControllerProvider).future;
    return ref.read(mapControllerProvider.notifier).getCenterScreenPoint();
  }
}

@riverpod
class MapController extends _$MapController {
  final _devicePixelRatio =
      PlatformDispatcher.instance.views.first.devicePixelRatio;
  final _mapController = Completer<GoogleMapController>();
  Point<int>? _centerScreenPoint;

  @override
  Completer<GoogleMapController> build() => _mapController;

  Future<void> setMapController(GoogleMapController controller) async {
    assert(
      !_mapController.isCompleted,
      'GoogleMapController is already set. setMapController must be called only once.',
    );
    _mapController.complete(controller);
  }

  Future<double> getZoomLevel() async {
    final controller = await _mapController.future;
    return await controller.getZoomLevel();
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
class PolylineNotifier extends _$PolylineNotifier {
  final _devicePixelRatio =
      PlatformDispatcher.instance.views.first.devicePixelRatio;
  Position? _currentPosition;

  @override
  Future<Polyline?> build() async {
    _currentPosition = await Geolocator.getLastKnownPosition();

    ref.listen(positionNotifierProvider, (_, next) {
      final nextPosition = next.valueOrNull;
      if (!next.isLoading && !next.hasError && nextPosition != null) {
        if (_currentPosition?.latitude != nextPosition.latitude &&
            _currentPosition?.longitude != nextPosition.longitude) {
          _currentPosition = nextPosition;
        }
      }
    });

    final centerLatLng =
        await ref.read(mapControllerProvider.notifier).getCenterLatLng();
    if (centerLatLng == null) {
      return null;
    }

    return await _createPolyline(centerLatLng);
  }

  Future<void> onCameraMove(CameraPosition position) async {
    final polyline = await _createPolyline(position.target);
    state = AsyncData(polyline);
  }

  Future<Polyline?> _createPolyline(LatLng centerLatLng) async {
    if (_currentPosition == null) {
      return null;
    }

    final zoomLevel =
        await ref.read(mapControllerProvider.notifier).getZoomLevel();

    List<PatternItem> patterns = [];
    if (zoomLevel > 14) {
      final adjustedPatternSize =
          (2 * pow(2, 18 - zoomLevel)) * _devicePixelRatio;

      patterns = [
        PatternItem.gap(adjustedPatternSize),
        PatternItem.dash(adjustedPatternSize),
      ];
    }

    return Polyline(
      width: 5,
      zIndex: 0,
      polylineId: const PolylineId('SamplePolyline'),
      color: Colors.black,
      patterns: patterns,
      points: [
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        centerLatLng,
      ],
    );
  }
}

@riverpod
class PositionNotifier extends _$PositionNotifier {
  @override
  Stream<Position> build() => Geolocator.getPositionStream();
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
