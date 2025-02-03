// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: LGPL-2.1-or-later

import 'package:freezed_annotation/freezed_annotation.dart';

part 'repl_message.freezed.dart';

@freezed
class ReplMessage with _$ReplMessage {
  factory ReplMessage.evaluate(String code) = ReplMessageCode;
  factory ReplMessage.response(String result) = ReplMessageResponse;
  factory ReplMessage.error(String log) = ReplMessageError;
}
