// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arrow_with_polyline.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapControllerHash() => r'4c287d966286a3b10eee5d1bb5bb9376cc6cab08';

/// See also [mapController].
@ProviderFor(mapController)
final mapControllerProvider =
    AutoDisposeProvider<Completer<GoogleMapController>>.internal(
      mapController,
      name: r'mapControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$mapControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MapControllerRef =
    AutoDisposeProviderRef<Completer<GoogleMapController>>;
String _$centerMarkerNotifierHash() =>
    r'6569811e2158df9705ed616c03a9c752c1f306c5';

/// See also [CenterMarkerNotifier].
@ProviderFor(CenterMarkerNotifier)
final centerMarkerNotifierProvider = AutoDisposeNotifierProvider<
  CenterMarkerNotifier,
  CenterMarkerData
>.internal(
  CenterMarkerNotifier.new,
  name: r'centerMarkerNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$centerMarkerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CenterMarkerNotifier = AutoDisposeNotifier<CenterMarkerData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
