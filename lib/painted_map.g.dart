// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'painted_map.dart';

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
String _$markersNotifierHash() => r'dc42ee422b42b100ea764d246d740e32b3c31511';

/// See also [MarkersNotifier].
@ProviderFor(MarkersNotifier)
final markersNotifierProvider =
    AutoDisposeNotifierProvider<MarkersNotifier, Set<Marker>>.internal(
      MarkersNotifier.new,
      name: r'markersNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$markersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarkersNotifier = AutoDisposeNotifier<Set<Marker>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
