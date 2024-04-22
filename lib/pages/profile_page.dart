import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pengaduan_masyarakat/common/constant.dart';
import 'package:pengaduan_masyarakat/pages/sign_in_page.dart';
import 'package:pengaduan_masyarakat/providers/auth_provider.dart';
import 'package:pengaduan_masyarakat/providers/user_provider.dart';
import 'package:pengaduan_masyarakat/widgets/custom_button_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  navigate() {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        child: const SignInPage(),
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

  Future<void> getData() async {
    Provider.of<UserProvider>(
      context,
      listen: false,
    ).user();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });

    return Consumer2<UserProvider, AuthProvider>(
      builder: (context, userProvider, authProvider, child) {
        return Scaffold(
          backgroundColor: black1,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: white,
                ),
              ),
            automaticallyImplyLeading: false,
            backgroundColor: black1,
            centerTitle: true,
            title: Text(
              "Profil Saya",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: height(context) * 0.3,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(36, 36, 39, 255),
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userProvider.userModel?.name.toString() ?? "",
                          style: primaryTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                        Text(
                          userProvider.userModel?.email.toString() ?? "",
                          style: primaryTextStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadius),
                        )),
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: black1,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                  defaultBorderRadius,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 5,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Text(
                                  "Keluar?",
                                  style: primaryTextStyle,
                                ),
                                SizedBox(
                                  height: defaultPadding,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: CustomButtonWidget(
                                        text: "Batal",
                                        color: primaryColor,
                                        isLoading: false,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: defaultPadding,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: CustomButtonWidget(
                                        text: "Keluar",
                                        color: Colors.red,
                                        isLoading: false,
                                        onPressed: () async {
                                          if (await authProvider.signOut()) {
                                            navigate();
                                          } else {
                                            showSnackBar(
                                              "Gagal keluar",
                                              Colors.red,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Keluar",
                      style: primaryTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
