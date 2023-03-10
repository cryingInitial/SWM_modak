import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modak_flutter_app/constant/coloring.dart';
import 'package:modak_flutter_app/constant/font.dart';
import 'package:modak_flutter_app/constant/shadowing.dart';
import 'package:modak_flutter_app/data/dto/chat.dart';
import 'package:modak_flutter_app/provider/chat_provider.dart';
import 'package:modak_flutter_app/provider/user_provider.dart';
import 'package:modak_flutter_app/utils/easy_style.dart';
import 'package:modak_flutter_app/widgets/button/button_main_widget.dart';
import 'package:modak_flutter_app/widgets/chat/components/component_info_widget.dart';
import 'package:provider/provider.dart';

class DialogOnwayWidget extends StatefulWidget {
  const DialogOnwayWidget({Key? key, required this.chat, required this.isMine, required this.isTail}) : super(key: key);

  final Chat chat;
  final bool isMine;
  final bool isTail;

  @override
  State<DialogOnwayWidget> createState() => _DialogOnwayWidgetState();
}

class _DialogOnwayWidgetState extends State<DialogOnwayWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: widget.isMine ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Coloring.todo_purple)),
          child: DialogOnwayFirstWidget(
            chat: widget.chat,
            isMine: widget.isMine,
          ),
        ),
        ChatComponentInfoWidget(
          chat: widget.chat,
          crossAxisAlignment: widget.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          showTime: widget.isTail,
        ),
      ],
    );
  }
}

class DialogOnwayFirstWidget extends StatefulWidget {
  const DialogOnwayFirstWidget({Key? key, required this.chat, required this.isMine}) : super(key: key);

  final Chat chat;
  final bool isMine;

  @override
  State<DialogOnwayFirstWidget> createState() => _DialogOnwayFirstWidgetState();
}

class _DialogOnwayFirstWidgetState extends State<DialogOnwayFirstWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 7),
          child: Text(
            "??????",
            style: EasyStyle.text(Colors.black, Font.size_largeText, Font.weight_regular),
          ),
        ),
        Text(
          widget.chat.content,
          style: EasyStyle.text(Colors.black, Font.size_h4, Font.weight_bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 7),
          child: Text(
            "??????????",
            style: EasyStyle.text(Colors.black, Font.size_largeText, Font.weight_regular),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ButtonMainWidget(
          height: 40,
          title: "??????",
          isValid: widget.isMine ? false : true,
          onPressed: () {
            if (widget.isMine) {
              Fluttertoast.showToast(msg: "????????? ?????? ???????????????.");
              return;
            }
            context.read<ChatProvider>().postChat(
              context,
              "${context.read<UserProvider>().me!.name}?????? ${widget.chat.content}???(???) ?????????????????????!",
              metaData: {
                "type_code": "info",
              },
            );
          },
          color: Coloring.notice,
          shadow: Shadowing.none,
        )
      ],
    );
  }
}
