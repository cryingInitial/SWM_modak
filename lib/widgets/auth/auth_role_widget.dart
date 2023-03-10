import 'package:flutter/material.dart';
import 'package:modak_flutter_app/constant/coloring.dart';
import 'package:modak_flutter_app/constant/strings.dart';

class AuthRoleWidget extends StatefulWidget {
  const AuthRoleWidget({Key? key, required this.family, required this.isChecked}) : super(key: key);

  final String family;
  final bool isChecked;

  @override
  State<AuthRoleWidget> createState() => _AuthRoleWidgetState();
}

class _AuthRoleWidgetState extends State<AuthRoleWidget> {
  Map<String, String> data = {
    Strings.dad: "lib/assets/images/family/dad.png",
    Strings.mom: "lib/assets/images/family/mom.png",
    Strings.dau: "lib/assets/images/family/dau.png",
    Strings.son: "lib/assets/images/family/son.png",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isChecked ? null : Coloring.bg_orange,
        gradient: widget.isChecked ? Coloring.main : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Color(0X77FFFFFF),
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              data[widget.family]!,
              width: 58,
              height: 118,
            ),
          )
        ],
      ),
    );
  }
}
