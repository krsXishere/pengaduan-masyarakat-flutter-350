import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pengaduan_masyarakat/pages/complaint_page.dart';
import 'package:pengaduan_masyarakat/pages/sign_in_page.dart';
import 'package:pengaduan_masyarakat/widgets/custom_button_question_auth_widget.dart';
import 'package:pengaduan_masyarakat/widgets/custom_button_widget.dart';
import 'package:provider/provider.dart';
import '../common/constant.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_textformfield_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationPasswordController =
      TextEditingController();
  TextEditingController phoneController = TextEditingController();

  navigate() {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        child: const ComplaintPage(),
        type: PageTransitionType.rightToLeft,
      ),
      (Route<dynamic> route) => false,
    );
  }

  showSnackBar(
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          message,
          style: primaryTextStyle.copyWith(
            color: white,
          ),
        ),
      ),
    );
  }

  signUp(AuthProvider value) async {
    if (nikController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmationPasswordController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      if (passwordController.text == confirmationPasswordController.text) {
        if (await value.signUp(
              nikController.text,
              nameController.text,
              emailController.text,
              passwordController.text,
              phoneController.text,
            ) &&
            value.authModel!.status == 200) {
          navigate();
        } else if (value.authModel!.status == 422) {
          showSnackBar(
            value.authModel!.message.toString(),
            Colors.red,
          );
        } else if (value.authModel!.message!.contains("already")) {
          showSnackBar(
            "Email telah terdaftar",
            Colors.red,
          );
        } else if (value.authModel!.status == 500) {
          showSnackBar(
            "Server error",
            Colors.red,
          );
        } else {
          showSnackBar(
            "Gagal masuk\nError tidak diketahui",
            Colors.red,
          );
        }
      } else {
        showSnackBar(
          "Kata sandi harus sama",
          Colors.red,
        );
      }
    } else {
      showSnackBar(
        "Isi semua data",
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: black1,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  children: [
                    SizedBox(
                      height: height(context) * 0.2,
                    ),
                    Center(
                      child: FlutterLogo(
                        size: 100,
                        textColor: primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Center(
                      child: Text(
                        "Daftar Pengaduan Masyarakat",
                        style: primaryTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextFormFieldWidget(
                      hintText: "NIK",
                      label: "NIK",
                      isPasswordField: false,
                      controller: nikController,
                      type: TextInputType.number,
                      onTap: () {},
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextFormFieldWidget(
                      hintText: "Nama",
                      label: "Nama",
                      isPasswordField: false,
                      controller: nameController,
                      type: TextInputType.text,
                      onTap: () {},
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextFormFieldWidget(
                      hintText: "No. HP",
                      label: "No. HP",
                      isPasswordField: false,
                      controller: phoneController,
                      type: TextInputType.number,
                      onTap: () {},
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextFormFieldWidget(
                      hintText: "Email",
                      label: "Email",
                      isPasswordField: false,
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      onTap: () {},
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextFormFieldWidget(
                      hintText: "Kata sandi",
                      label: "Kata Sandi",
                      isPasswordField: true,
                      controller: passwordController,
                      type: TextInputType.text,
                      isObsecure: value.isObsecure,
                      onTap: () {
                        value.checkObsecure();
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextFormFieldWidget(
                      hintText: "Konfirmasi kata sandi",
                      label: "Konfirmasi Kata Sandi",
                      isPasswordField: true,
                      controller: confirmationPasswordController,
                      type: TextInputType.text,
                      isObsecure: value.isObsecureConfirmation,
                      onTap: () {
                        value.checkObsecureConfirmation();
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomButtonWidget(
                      text: "Daftar",
                      color: primaryColor,
                      isLoading: value.isLoading,
                      onPressed: () {
                        signUp(value);
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    const CustomButtonQuestionAuthWidget(
                      question: "Sudah mendaftar?",
                      buttonText: "Masuk",
                      page: SignInPage(),
                    ),
                    SizedBox(
                      height: height(context) * 0.1,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}