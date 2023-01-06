import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modak_flutter_app/assets/icons/light/LightIcons_icons.dart';
import 'package:modak_flutter_app/constant/coloring.dart';
import 'package:modak_flutter_app/constant/enum/chat_enum.dart';
import 'package:modak_flutter_app/constant/shadowing.dart';
import 'package:modak_flutter_app/data/dto/todo.dart';
import 'package:modak_flutter_app/data/dto/user.dart';
import 'package:modak_flutter_app/provider/chat_provider.dart';
import 'package:modak_flutter_app/provider/todo_provider.dart';
import 'package:modak_flutter_app/provider/user_provider.dart';
import 'package:modak_flutter_app/ui/todo/write/todo_write_screen.dart';
import 'package:modak_flutter_app/utils/date.dart';
import 'package:modak_flutter_app/widgets/button/button_main_widget.dart';
import 'package:modak_flutter_app/widgets/input/input_date_widget.dart';
import 'package:modak_flutter_app/widgets/input/input_select_widget.dart';
import 'package:modak_flutter_app/widgets/input/input_text_widget.dart';
import 'package:provider/provider.dart';

class FunctionTodoWidget extends StatefulWidget {
  const FunctionTodoWidget({Key? key}) : super(key: key);

  @override
  State<FunctionTodoWidget> createState() => _FunctionTodoWidgetState();
}

class _FunctionTodoWidgetState extends State<FunctionTodoWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Todo todo = Todo(
    todoId: -1,
    groupTodoId: -1,
    memberId: -1,
    title: '',
    color: 'color',
    isDone: false,
    timeTag: null,
    repeatTag: null,
    repeat: [0, 0, 0, 0, 0, 0, 0],
    memo: null,
    memoColor: 'default',
    date: Date.getFormattedDate(),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChatProvider, UserProvider, TodoProvider>(
      builder: (context, chatProvider, userProvider, todoProvider, child) {
        if (todo.title.isEmpty) {
          todo.title = context.read<ChatProvider>().todoTitle;
        }
        if (todo.memberId == -1) {
          todo.memberId = context.read<UserProvider>().me!.memberId;
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: InputTextWidget(
                  initText: context.read<ChatProvider>().todoTitle,
                  textEditingController: _textEditingController,
                  isBlocked: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: InputSelectWidget(
                  leftIconData: LightIcons.Profile,
                  title: "담당",
                  contents: userProvider.findUserById(todo.memberId)!.name,
                  isFilled: true,
                  buttons: {
                    for (User family in userProvider.familyMembers)
                      family.name: () {
                        setState(() {
                          todo.memberId = family.memberId;
                        });
                        Get.back();
                      }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: InputDateWidget(
                  title: "날짜",
                  contents: todo.date,
                  onChanged: (DateTime dateTime) {
                    setState(() {
                      todo.date = Date.getFormattedDate(dateTime: dateTime);
                    });
                  },
                  currTime: DateTime.parse(todo.date),
                  maxTime: DateTime(2025),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: InputSelectWidget(
                  leftIconData: LightIcons.MoreCircle,
                  title: "옵션 더보기",
                  contents: "",
                  isFilled: false,
                  onTap: () async {
                    List<dynamic>? result = await Get.to(
                        TodoWriteScreen(
                          title: todo.title,
                          manager: userProvider.findUserById(todo.memberId),
                          date: DateTime.parse(todo.date),
                        ),
                        preventDuplicates: false);
                    if (result == null) {
                      return;
                    } else {
                      setState(() {
                        todo.title = result[0];
                        todo.memberId = (result[1] as User?)?.memberId ??
                            userProvider.me!.memberId;
                        todo.date = result[2];
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ButtonMainWidget(
                  height: 50,
                  title: "일정 등록하기",
                  isValid: todo.title.trim().isNotEmpty,
                  onPressed: () async {
                    todoProvider.postTodo(todo);
                    chatProvider.chatMode = ChatMode.textInput;
                    Fluttertoast.showToast(msg: "집안일이 등록되었습니다.");
                  },
                  color: Coloring.main,
                  shadow: Shadowing.yellow,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
