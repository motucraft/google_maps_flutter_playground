// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'painted_map.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ItemData {

 Offset get position; Uint8List get item;
/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemDataCopyWith<ItemData> get copyWith => _$ItemDataCopyWithImpl<ItemData>(this as ItemData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemData&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.item, item));
}


@override
int get hashCode => Object.hash(runtimeType,position,const DeepCollectionEquality().hash(item));

@override
String toString() {
  return 'ItemData(position: $position, item: $item)';
}


}

/// @nodoc
abstract mixin class $ItemDataCopyWith<$Res>  {
  factory $ItemDataCopyWith(ItemData value, $Res Function(ItemData) _then) = _$ItemDataCopyWithImpl;
@useResult
$Res call({
 Offset position, Uint8List item
});




}
/// @nodoc
class _$ItemDataCopyWithImpl<$Res>
    implements $ItemDataCopyWith<$Res> {
  _$ItemDataCopyWithImpl(this._self, this._then);

  final ItemData _self;
  final $Res Function(ItemData) _then;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? item = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}

}


/// @nodoc


class _ItemData implements ItemData {
  const _ItemData({required this.position, required this.item});
  

@override final  Offset position;
@override final  Uint8List item;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDataCopyWith<_ItemData> get copyWith => __$ItemDataCopyWithImpl<_ItemData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemData&&(identical(other.position, position) || other.position == position)&&const DeepCollectionEquality().equals(other.item, item));
}


@override
int get hashCode => Object.hash(runtimeType,position,const DeepCollectionEquality().hash(item));

@override
String toString() {
  return 'ItemData(position: $position, item: $item)';
}


}

/// @nodoc
abstract mixin class _$ItemDataCopyWith<$Res> implements $ItemDataCopyWith<$Res> {
  factory _$ItemDataCopyWith(_ItemData value, $Res Function(_ItemData) _then) = __$ItemDataCopyWithImpl;
@override @useResult
$Res call({
 Offset position, Uint8List item
});




}
/// @nodoc
class __$ItemDataCopyWithImpl<$Res>
    implements _$ItemDataCopyWith<$Res> {
  __$ItemDataCopyWithImpl(this._self, this._then);

  final _ItemData _self;
  final $Res Function(_ItemData) _then;

/// Create a copy of ItemData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? item = null,}) {
  return _then(_ItemData(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

// dart format on
