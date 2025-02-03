// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repl_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReplMessage {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code) evaluate,
    required TResult Function(String result) response,
    required TResult Function(String log) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code)? evaluate,
    TResult? Function(String result)? response,
    TResult? Function(String log)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code)? evaluate,
    TResult Function(String result)? response,
    TResult Function(String log)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ReplMessageCode value) evaluate,
    required TResult Function(ReplMessageResponse value) response,
    required TResult Function(ReplMessageError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReplMessageCode value)? evaluate,
    TResult? Function(ReplMessageResponse value)? response,
    TResult? Function(ReplMessageError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReplMessageCode value)? evaluate,
    TResult Function(ReplMessageResponse value)? response,
    TResult Function(ReplMessageError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplMessageCopyWith<$Res> {
  factory $ReplMessageCopyWith(
          ReplMessage value, $Res Function(ReplMessage) then) =
      _$ReplMessageCopyWithImpl<$Res, ReplMessage>;
}

/// @nodoc
class _$ReplMessageCopyWithImpl<$Res, $Val extends ReplMessage>
    implements $ReplMessageCopyWith<$Res> {
  _$ReplMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ReplMessageCodeImplCopyWith<$Res> {
  factory _$$ReplMessageCodeImplCopyWith(_$ReplMessageCodeImpl value,
          $Res Function(_$ReplMessageCodeImpl) then) =
      __$$ReplMessageCodeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code});
}

/// @nodoc
class __$$ReplMessageCodeImplCopyWithImpl<$Res>
    extends _$ReplMessageCopyWithImpl<$Res, _$ReplMessageCodeImpl>
    implements _$$ReplMessageCodeImplCopyWith<$Res> {
  __$$ReplMessageCodeImplCopyWithImpl(
      _$ReplMessageCodeImpl _value, $Res Function(_$ReplMessageCodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
  }) {
    return _then(_$ReplMessageCodeImpl(
      null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ReplMessageCodeImpl implements ReplMessageCode {
  _$ReplMessageCodeImpl(this.code);

  @override
  final String code;

  @override
  String toString() {
    return 'ReplMessage.evaluate(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplMessageCodeImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplMessageCodeImplCopyWith<_$ReplMessageCodeImpl> get copyWith =>
      __$$ReplMessageCodeImplCopyWithImpl<_$ReplMessageCodeImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code) evaluate,
    required TResult Function(String result) response,
    required TResult Function(String log) error,
  }) {
    return evaluate(code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code)? evaluate,
    TResult? Function(String result)? response,
    TResult? Function(String log)? error,
  }) {
    return evaluate?.call(code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code)? evaluate,
    TResult Function(String result)? response,
    TResult Function(String log)? error,
    required TResult orElse(),
  }) {
    if (evaluate != null) {
      return evaluate(code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ReplMessageCode value) evaluate,
    required TResult Function(ReplMessageResponse value) response,
    required TResult Function(ReplMessageError value) error,
  }) {
    return evaluate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReplMessageCode value)? evaluate,
    TResult? Function(ReplMessageResponse value)? response,
    TResult? Function(ReplMessageError value)? error,
  }) {
    return evaluate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReplMessageCode value)? evaluate,
    TResult Function(ReplMessageResponse value)? response,
    TResult Function(ReplMessageError value)? error,
    required TResult orElse(),
  }) {
    if (evaluate != null) {
      return evaluate(this);
    }
    return orElse();
  }
}

abstract class ReplMessageCode implements ReplMessage {
  factory ReplMessageCode(final String code) = _$ReplMessageCodeImpl;

  String get code;
  @JsonKey(ignore: true)
  _$$ReplMessageCodeImplCopyWith<_$ReplMessageCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReplMessageResponseImplCopyWith<$Res> {
  factory _$$ReplMessageResponseImplCopyWith(_$ReplMessageResponseImpl value,
          $Res Function(_$ReplMessageResponseImpl) then) =
      __$$ReplMessageResponseImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String result});
}

/// @nodoc
class __$$ReplMessageResponseImplCopyWithImpl<$Res>
    extends _$ReplMessageCopyWithImpl<$Res, _$ReplMessageResponseImpl>
    implements _$$ReplMessageResponseImplCopyWith<$Res> {
  __$$ReplMessageResponseImplCopyWithImpl(_$ReplMessageResponseImpl _value,
      $Res Function(_$ReplMessageResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
  }) {
    return _then(_$ReplMessageResponseImpl(
      null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ReplMessageResponseImpl implements ReplMessageResponse {
  _$ReplMessageResponseImpl(this.result);

  @override
  final String result;

  @override
  String toString() {
    return 'ReplMessage.response(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplMessageResponseImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplMessageResponseImplCopyWith<_$ReplMessageResponseImpl> get copyWith =>
      __$$ReplMessageResponseImplCopyWithImpl<_$ReplMessageResponseImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code) evaluate,
    required TResult Function(String result) response,
    required TResult Function(String log) error,
  }) {
    return response(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code)? evaluate,
    TResult? Function(String result)? response,
    TResult? Function(String log)? error,
  }) {
    return response?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code)? evaluate,
    TResult Function(String result)? response,
    TResult Function(String log)? error,
    required TResult orElse(),
  }) {
    if (response != null) {
      return response(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ReplMessageCode value) evaluate,
    required TResult Function(ReplMessageResponse value) response,
    required TResult Function(ReplMessageError value) error,
  }) {
    return response(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReplMessageCode value)? evaluate,
    TResult? Function(ReplMessageResponse value)? response,
    TResult? Function(ReplMessageError value)? error,
  }) {
    return response?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReplMessageCode value)? evaluate,
    TResult Function(ReplMessageResponse value)? response,
    TResult Function(ReplMessageError value)? error,
    required TResult orElse(),
  }) {
    if (response != null) {
      return response(this);
    }
    return orElse();
  }
}

abstract class ReplMessageResponse implements ReplMessage {
  factory ReplMessageResponse(final String result) = _$ReplMessageResponseImpl;

  String get result;
  @JsonKey(ignore: true)
  _$$ReplMessageResponseImplCopyWith<_$ReplMessageResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReplMessageErrorImplCopyWith<$Res> {
  factory _$$ReplMessageErrorImplCopyWith(_$ReplMessageErrorImpl value,
          $Res Function(_$ReplMessageErrorImpl) then) =
      __$$ReplMessageErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String log});
}

/// @nodoc
class __$$ReplMessageErrorImplCopyWithImpl<$Res>
    extends _$ReplMessageCopyWithImpl<$Res, _$ReplMessageErrorImpl>
    implements _$$ReplMessageErrorImplCopyWith<$Res> {
  __$$ReplMessageErrorImplCopyWithImpl(_$ReplMessageErrorImpl _value,
      $Res Function(_$ReplMessageErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? log = null,
  }) {
    return _then(_$ReplMessageErrorImpl(
      null == log
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ReplMessageErrorImpl implements ReplMessageError {
  _$ReplMessageErrorImpl(this.log);

  @override
  final String log;

  @override
  String toString() {
    return 'ReplMessage.error(log: $log)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplMessageErrorImpl &&
            (identical(other.log, log) || other.log == log));
  }

  @override
  int get hashCode => Object.hash(runtimeType, log);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplMessageErrorImplCopyWith<_$ReplMessageErrorImpl> get copyWith =>
      __$$ReplMessageErrorImplCopyWithImpl<_$ReplMessageErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code) evaluate,
    required TResult Function(String result) response,
    required TResult Function(String log) error,
  }) {
    return error(log);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code)? evaluate,
    TResult? Function(String result)? response,
    TResult? Function(String log)? error,
  }) {
    return error?.call(log);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code)? evaluate,
    TResult Function(String result)? response,
    TResult Function(String log)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(log);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ReplMessageCode value) evaluate,
    required TResult Function(ReplMessageResponse value) response,
    required TResult Function(ReplMessageError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ReplMessageCode value)? evaluate,
    TResult? Function(ReplMessageResponse value)? response,
    TResult? Function(ReplMessageError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ReplMessageCode value)? evaluate,
    TResult Function(ReplMessageResponse value)? response,
    TResult Function(ReplMessageError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ReplMessageError implements ReplMessage {
  factory ReplMessageError(final String log) = _$ReplMessageErrorImpl;

  String get log;
  @JsonKey(ignore: true)
  _$$ReplMessageErrorImplCopyWith<_$ReplMessageErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
