import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_playground/gen/assets.gen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MapGroundOverlay());
  }
}

class MapGroundOverlay extends ConsumerWidget {
  const MapGroundOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: AssetMapBitmap.create(
            createLocalImageConfiguration(context),
            Assets.images.tokyoDome.path,
            bitmapScaling: MapBitmapScaling.none,
          ),
          builder: (context, snapshot) {
            final image = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError ||
                image == null) {
              return const CircularProgressIndicator();
            }

            return GoogleMap(
              mapType: MapType.none,
              initialCameraPosition: const CameraPosition(
                target: LatLng(35.705373301512175, 139.75211534052752),
                zoom: 16,
              ),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              groundOverlays: {
                GroundOverlay.fromPosition(
                  groundOverlayId: const GroundOverlayId('tokyo_dome'),
                  image: image,
                  position: const LatLng(35.7053501448787, 139.75296746540212),
                  zoomLevel: 16,
                ),
              },
            );
          },
        ),
      ),
    );
  }
}
