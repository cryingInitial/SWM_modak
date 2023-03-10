import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:modak_flutter_app/constant/strings.dart';
import 'package:modak_flutter_app/data/repository/user_repository.dart';
import 'package:modak_flutter_app/provider/user_provider.dart';
import 'package:modak_flutter_app/ui/auth/register/register_name_agreement_screen.dart';
import 'package:modak_flutter_app/ui/auth/register/register_role_screen.dart';
import 'package:modak_flutter_app/utils/provider_controller.dart';
import 'package:modak_flutter_app/widgets/modal/theme_modal_widget.dart';
import 'package:provider/provider.dart';

class AuthRegisterVM extends ChangeNotifier {
  final List<String> _buttonText = [
    "다음으로",
    "회원가입",
  ];

  Future<void> init() async {
    _userRepository = UserRepository();

    _name = _userRepository.getName() ?? "";
    _birthDay = _userRepository.getBirthDay();
    _isLunar = _userRepository.getIsLunar() ?? false;
    _role = _userRepository.getRole() ?? "";
    _userRepository.setIsRegisterProgress(true);
    notifyListeners();
  }

  late final UserRepository _userRepository;

  int _page = 0;
  String _name = "";
  DateTime? _birthDay;
  bool _isLunar = false;
  String _role = "";
  bool _isPrivateInformationAgreed = true;
  bool _isOperatingPolicyAgreed = true;

  int get page => _page;

  String get name => _name;

  DateTime? get birthDay => _birthDay;

  bool get isLunar => _isLunar;

  String get role => _role;

  bool get isPrivateInformationAgreed => _isPrivateInformationAgreed;

  bool get isOperatingPolicyAgreed => _isOperatingPolicyAgreed;

  set name(String name) {
    _name = name;
    _userRepository.setName(name);
    notifyListeners();
  }

  set birthDay(DateTime? birthDay) {
    _birthDay = birthDay;
    if (birthDay != null) _userRepository.setBirthDay(birthDay);
    notifyListeners();
  }

  set isLunar(bool isLunar) {
    _isLunar = isLunar;
    _userRepository.setIsLunar(isLunar);
    notifyListeners();
  }

  set role(String role) {
    _role = role;
    _userRepository.setRole(role);
    notifyListeners();
  }

  set isPrivateInformationAgreed(bool isPrivateInformationAgreed) {
    _isPrivateInformationAgreed = isPrivateInformationAgreed;
    notifyListeners();
  }

  set isOperatingPolicyAgreed(bool isOperatingPolicyAgreed) {
    _isOperatingPolicyAgreed = isOperatingPolicyAgreed;
    notifyListeners();
  }

  void goNextPage(BuildContext context) {
    if (_page < 1) {
      _page += 1;
    } else {
      _trySignUp(context);
    }
    notifyListeners();
  }

  void goPreviousPage(BuildContext context) {
    if (page > 0) {
      _page -= 1;
    } else {
      _userRepository.setIsRegisterProgress(false);
      themeModalWidget(
        context,
        title: "회원가입을 종료하시겠습니까?",
        okText: "회원가입 종료",
        onOkPress: () async {
          Get.offAllNamed("/auth/landing");
        },
      );
    }
    notifyListeners();
  }

  bool getIsPageDone() {
    if (_page == 0) {
      return _name.trim().length > 2 &&
          _birthDay != null &&
          _isPrivateInformationAgreed &&
          _isOperatingPolicyAgreed;
    } else if (_page == 1) {
      return _role != "";
    }
    return false;
  }

  Widget getPage(AuthRegisterVM provider, TextEditingController controller) {
    if (_page == 0) {
      return RegisterNameAgreementScreen(
        provider: provider,
        controller: controller,
      );
    } else {
      return RegisterRoleScreen(
        provider: provider,
      );
    }
  }

  String getButtonText() {
    return _buttonText[page];
  }

  _trySignUp(BuildContext context) async {
    Map<String, dynamic> response = await _userRepository.signUp();
    switch (response[Strings.message]) {
      case Strings.success:
        Fluttertoast.showToast(msg: "회원가입 성공");
        await Future(() => context.read<UserProvider>().me =
            response[Strings.response][Strings.me]);
        await Future(() => context.read<UserProvider>().familyMembers =
            response[Strings.response][Strings.familyMembers]);
        await Future(() => ProviderController.startProviders(context));

        Get.offAllNamed("/main");
        break;
      case Strings.valueAlreadyExist:
        Fluttertoast.showToast(msg: "이미 계정이 존재합니다");
        Get.offAllNamed("/auth/landing");
        break;
      case Strings.noValue:
        Fluttertoast.showToast(msg: "입력되지 않은 값이 있습니다");
        break;
      case Strings.fail:
        Fluttertoast.showToast(msg: "예상치 못한 문제가 발생하였습니다");
    }
  }
}
