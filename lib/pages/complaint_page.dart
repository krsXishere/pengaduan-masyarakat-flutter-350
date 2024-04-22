import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pengaduan_masyarakat/common/constant.dart';
import 'package:pengaduan_masyarakat/pages/profile_page.dart';
import 'package:pengaduan_masyarakat/providers/complaint_provider.dart';
import 'package:pengaduan_masyarakat/providers/user_provider.dart';
import 'package:pengaduan_masyarakat/widgets/custom_button_widget.dart';
import 'package:pengaduan_masyarakat/widgets/custom_textformfield_widget.dart';
import 'package:provider/provider.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final nikController = TextEditingController();
  final namaController = TextEditingController();
  final aduanController = TextEditingController();

  Future<void> pickFile(ComplaintProvider value) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'mp4',
        'mp3',
      ],
    );
    if (result != null) {
      value.checkFilePicked(result);
    }
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

  aduan(ComplaintProvider value, UserProvider value2) async {
    if (aduanController.text.isNotEmpty) {
      if (await value.create(
        value2.userModel!.id.toString(),
        aduanController.text,
        value.filePicked,
      )) {
        showSnackBar(
          "Berhasil mengirim pengaduan!",
          primaryColor,
        );

        nikController.clear();
        namaController.clear();
        aduanController.clear();
      } else {
        showSnackBar(
          "Gagal mengirim pengaduan",
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

    return Consumer2<ComplaintProvider, UserProvider>(
      builder: (context, value, value2, child) {
        return Scaffold(
          backgroundColor: black1,
          appBar: AppBar(
          backgroundColor: black1,
            centerTitle: true,
            title: Text(
              "Pengaduan",
              style: primaryTextStyle.copyWith(
                fontSize: 14,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageTransition(
                      child: const ProfilePage(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: Icon(
                  Icons.person,
                  color: white,
                ),
              ),
              SizedBox(
                width: defaultPadding,
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(defaultPadding),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  CustomTextFormFieldWidget(
                    hintText: "Deskripsikan perihal yang ingin disampaikan",
                    label: "Aduan",
                    isPasswordField: false,
                    controller: aduanController,
                    type: TextInputType.text,
                    expands: true,
                    onTap: () {},
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Container(
                    padding: EdgeInsets.all(defaultPadding),
                    height: height(context) * 0.4,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: black1,
                      borderRadius: BorderRadius.circular(defaultPadding),
                      border: Border.all(
                        color: white,
                      ),
                    ),
                    child: DottedBorder(
                      dashPattern: const [
                        10,
                        5,
                      ],
                      color: primaryColor,
                      strokeCap: StrokeCap.round,
                      child: value.filePicked != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    value.filePicked!.names.toString(),
                                    style: primaryTextStyle.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      value.deleteFilePicked();
                                    },
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                pickFile(value);
                              },
                              child: SizedBox(
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.file_present_rounded,
                                        color: primaryColor,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Text(
                                        "Sertakan bukti",
                                        style: primaryTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 100,
                        child: CustomButtonWidget(
                          text: "Hapus",
                          color: Colors.red,
                          isLoading: false,
                          onPressed: () {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 5,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      SizedBox(
                                        height: defaultPadding,
                                      ),
                                      Text(
                                        "Hapus laporan?",
                                        style: primaryTextStyle,
                                      ),
                                      SizedBox(
                                        height: defaultPadding,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              text: "Hapus",
                                              color: Colors.red,
                                              isLoading: false,
                                              onPressed: () {
                                                nikController.clear();
                                                namaController.clear();
                                                aduanController.clear();

                                                value.deleteFilePicked();
                                                Navigator.of(context).pop();
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  CustomButtonWidget(
                    text: "Kirim Sekarang!",
                    color: primaryColor,
                    isLoading: value.isLoading,
                    onPressed: () {
                      aduan(
                        value,
                        value2,
                      );
                    },
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
