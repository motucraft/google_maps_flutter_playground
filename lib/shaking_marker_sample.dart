import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ShakingMarkerSample());
  }
}

class ShakingMarkerSample extends HookWidget {
  const ShakingMarkerSample({super.key});

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    )..repeat(reverse: true);

    final animation = useMemoized(
      () => Tween(begin: -10.0, end: 10.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
      ),
      [],
    );

    final devicePixelRatio = useMemoized(
      () => MediaQuery.devicePixelRatioOf(context),
    );
    final icon = useFuture(
      useMemoized(() async {
        debugPrint('toBitmapDescriptor called');
        return await const Icon(
          Icons.cell_tower,
          color: Colors.red,
          size: 56,
        ).toBitmapDescriptor(
          logicalSize: const Size(56, 56),
          imageSize: Size(56 * devicePixelRatio, 56 * devicePixelRatio),
        );
      }),
    );

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            debugPrint('builder');
            final data = icon.data;
            final markers =
                data == null
                    ? <Marker>{}
                    : {
                      Marker(
                        markerId: const MarkerId('shakingMarker'),
                        position: const LatLng(
                          35.65859614560881,
                          139.74542643554068,
                        ),
                        icon: data,
                        rotation: animation.value,
                      ),
                    };

            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(35.68098868213622, 139.76707800637),
                zoom: 14,
              ),
              markers: markers,
            );
          },
        ),
      ),
    );
  }
}
