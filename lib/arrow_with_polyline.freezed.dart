// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arrow_with_polyline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CenterMarkerData implements DiagnosticableTreeMixin {

 AssetGenImage? get image;
/// Create a copy of CenterMarkerData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CenterMarkerDataCopyWith<CenterMarkerData> get copyWith => _$CenterMarkerDataCopyWithImpl<CenterMarkerData>(this as CenterMarkerData, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CenterMarkerData'))
    ..add(DiagnosticsProperty('image', image));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CenterMarkerData&&const DeepCollectionEquality().equals(other.image, image));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(image));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CenterMarkerData(image: $image)';
}


}

/// @nodoc
abstract mixin class $CenterMarkerDataCopyWith<$Res>  {
  factory $CenterMarkerDataCopyWith(CenterMarkerData value, $Res Function(CenterMarkerData) _then) = _$CenterMarkerDataCopyWithImpl;
@useResult
$Res call({
 AssetGenImage? image
});




}
/// @nodoc
class _$CenterMarkerDataCopyWithImpl<$Res>
    implements $CenterMarkerDataCopyWith<$Res> {
  _$CenterMarkerDataCopyWithImpl(this._self, this._then);

  final CenterMarkerData _self;
  final $Res Function(CenterMarkerData) _then;

/// Create a copy of CenterMarkerData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? image = freezed,}) {
  return _then(_self.copyWith(
image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as AssetGenImage?,
  ));
}

}


/// Adds pattern-matching-related methods to [CenterMarkerData].
extension CenterMarkerDataPatterns on CenterMarkerData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CenterMarkerData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CenterMarkerData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CenterMarkerData value)  $default,){
final _that = this;
switch (_that) {
case _CenterMarkerData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CenterMarkerData value)?  $default,){
final _that = this;
switch (_that) {
case _CenterMarkerData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AssetGenImage? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CenterMarkerData() when $default != null:
return $default(_that.image);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AssetGenImage? image)  $default,) {final _that = this;
switch (_that) {
case _CenterMarkerData():
return $default(_that.image);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AssetGenImage? image)?  $default,) {final _that = this;
switch (_that) {
case _CenterMarkerData() when $default != null:
return $default(_that.image);case _:
  return null;

}
}

}

/// @nodoc


class _CenterMarkerData with DiagnosticableTreeMixin implements CenterMarkerData {
  const _CenterMarkerData({this.image});
  

@override final  AssetGenImage? image;

/// Create a copy of CenterMarkerData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CenterMarkerDataCopyWith<_CenterMarkerData> get copyWith => __$CenterMarkerDataCopyWithImpl<_CenterMarkerData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CenterMarkerData'))
    ..add(DiagnosticsProperty('image', image));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CenterMarkerData&&const DeepCollectionEquality().equals(other.image, image));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(image));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CenterMarkerData(image: $image)';
}


}

/// @nodoc
abstract mixin class _$CenterMarkerDataCopyWith<$Res> implements $CenterMarkerDataCopyWith<$Res> {
  factory _$CenterMarkerDataCopyWith(_CenterMarkerData value, $Res Function(_CenterMarkerData) _then) = __$CenterMarkerDataCopyWithImpl;
@override @useResult
$Res call({
 AssetGenImage? image
});




}
/// @nodoc
class __$CenterMarkerDataCopyWithImpl<$Res>
    implements _$CenterMarkerDataCopyWith<$Res> {
  __$CenterMarkerDataCopyWithImpl(this._self, this._then);

  final _CenterMarkerData _self;
  final $Res Function(_CenterMarkerData) _then;

/// Create a copy of CenterMarkerData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? image = freezed,}) {
  return _then(_CenterMarkerData(
image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as AssetGenImage?,
  ));
}


}

// dart format on
