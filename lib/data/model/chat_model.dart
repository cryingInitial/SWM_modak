import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@unfreezed
class ChatModel with _$ChatModel {
  factory ChatModel({
    required int userId,
    required String content,
    required double sendAt,
    required Map? metaData,
    required int readCount,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}