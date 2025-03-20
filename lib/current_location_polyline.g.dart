// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_location_polyline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapControllerHash() => r'2ebd2b02a2436405dc5220c4d7e1edbdd9c55c7c';

/// See also [MapController].
@ProviderFor(MapController)
final mapControllerProvider = AutoDisposeNotifierProvider<
  MapController,
  Completer<GoogleMapController>
>.internal(
  MapController.new,
  name: r'mapControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MapController = AutoDisposeNotifier<Completer<GoogleMapController>>;
String _$polylineNotifierHash() => r'efabe8c9f0581268fe60580b5776fbb6dc01e507';

/// See also [PolylineNotifier].
@ProviderFor(PolylineNotifier)
final polylineNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PolylineNotifier, Polyline?>.internal(
      PolylineNotifier.new,
      name: r'polylineNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$polylineNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PolylineNotifier = AutoDisposeAsyncNotifier<Polyline?>;
String _$positionNotifierHash() => r'30c188408a1f36afa0fb20cceb21cda2122782ed';

/// See also [PositionNotifier].
@ProviderFor(PositionNotifier)
final positionNotifierProvider =
    AutoDisposeStreamNotifierProvider<PositionNotifier, Position>.internal(
      PositionNotifier.new,
      name: r'positionNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$positionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PositionNotifier = AutoDisposeStreamNotifier<Position>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
