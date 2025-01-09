import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

import '../../../models/model_tenant.dart';
import '../../../widget/bottom_sheet.dart';
import '../../../widget/snackbar.dart';
import '../../../widget/loading.dart';
import '../../../widget/tile.dart';
import '../auth/login_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.currentUser,
  });

  final User currentUser;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? imageFile;

  final imageTenantController = TextEditingController();
  final namaTenantController = TextEditingController();
  final emailTenantController = TextEditingController();
  final phoneTenantController = TextEditingController();
  final joinTenantController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tenants')
                  .doc(widget.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/Mobile testing-bro.svg',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        'No data found.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/404 error with a landscape-bro.svg',
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'An error occurred: ${snapshot.error}.',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  );
                }

                final tenantData = TenantModel.fromDocument(snapshot.data!);

                imageTenantController.text = tenantData.imageTenant;
                namaTenantController.text = tenantData.nameTenant;
                emailTenantController.text = tenantData.emailTenant;
                phoneTenantController.text = tenantData.phoneNumberTenant;
                joinTenantController.text =
                    DateFormat('MMMM dd, yyyy').format(tenantData.timestamp.toDate());

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 125,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey.shade100,
                                  Colors.grey.shade200,
                                  Colors.grey.shade300,
                                  Colors.grey.shade400,
                                ],
                              ),
                            ),
                            child: imageFile != null
                                ? Image.file(
                                    File(imageFile!.path),
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.low,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: imageTenantController.text,
                                    filterQuality: FilterQuality.low,
                                    fit: BoxFit.cover,
                                    useOldImageOnUrlChange: true,
                                    fadeInCurve: Curves.easeIn,
                                    fadeOutCurve: Curves.easeOut,
                                    fadeInDuration: const Duration(milliseconds: 500),
                                    fadeOutDuration: const Duration(milliseconds: 750),
                                    errorWidget: (context, url, error) {
                                      return Center(
                                        child: Text(
                                          'Image $error',
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const Gap(15),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black38, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 15, top: 15),
                                child: Text(
                                  'General',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ProfileTile(
                                iconData: Iconsax.shop_outline,
                                title: namaTenantController.text,
                                onTap: () {},
                                isLine: true,
                                mainColor: Colors.black,
                                other: false,
                                tapped: false,
                              ),
                              ProfileTile(
                                iconData: Iconsax.sms_outline,
                                title: emailTenantController.text,
                                onTap: () {},
                                isLine: true,
                                mainColor: Colors.black,
                                other: false,
                                tapped: false,
                              ),
                              ProfileTile(
                                iconData: Iconsax.call_outline,
                                title: phoneTenantController.text,
                                onTap: () {},
                                isLine: true,
                                mainColor: Colors.black,
                                other: false,
                                tapped: false,
                              ),
                              ProfileTile(
                                iconData: Iconsax.calendar_1_outline,
                                title: 'Joined ${joinTenantController.text}',
                                onTap: () {},
                                isLine: false,
                                mainColor: Colors.black,
                                other: false,
                                tapped: false,
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black38, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 15, top: 15),
                                child: Text(
                                  'Account',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ProfileTile(
                                iconData: Iconsax.edit_outline,
                                title: 'Edit Account',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => EditProfilePage(
                                        namaTenantController: namaTenantController,
                                        emailTenantController: emailTenantController,
                                        phoneTenantController: phoneTenantController,
                                        imageTenantController: imageTenantController,
                                        currentUser: widget.currentUser,
                                      ),
                                    ),
                                  );
                                },
                                isLine: true,
                                mainColor: Colors.black,
                                other: true,
                                tapped: true,
                              ),
                              ProfileTile(
                                iconData: Iconsax.logout_outline,
                                title: 'Keluar Account',
                                onTap: closeAccount,
                                isLine: true,
                                mainColor: Colors.black,
                                other: true,
                                tapped: true,
                              ),
                              ProfileTile(
                                iconData: Iconsax.trash_outline,
                                title: 'Delete Account',
                                onTap: deleteAccount,
                                isLine: false,
                                mainColor: Theme.of(context).colorScheme.error,
                                other: true,
                                tapped: true,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void closeAccount() {
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 1 / 3.5,
      isScrollControlled: false,
      enableDrag: false,
      useRootNavigator: false,
      showDragHandle: false,
      useSafeArea: true,
      isDismissible: false,
      barrierColor: Theme.of(context).shadowColor,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheetInfo(
          iconInfo: CupertinoIcons.question_circle,
          colorIcon: Theme.of(context).primaryColor,
          textInfo: 'Are you sure you want to go out ?',
          textButton: 'Yes',
          colorButton: Theme.of(context).primaryColor,
          onTap: () {
            enterClose(5);
          },
        );
      },
    );
  }

  Future<void> enterClose(int seconds) async {
    showLoading(context);

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );

    snackBarCustom(
      context,
      Theme.of(context).colorScheme.secondary,
      'Closed, Successfully',
      Colors.white,
      seconds,
    );
  }

  void deleteAccount() {
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 1 / 3.5,
      isScrollControlled: false,
      enableDrag: false,
      useRootNavigator: false,
      showDragHandle: false,
      useSafeArea: true,
      isDismissible: false,
      barrierColor: Theme.of(context).shadowColor,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheetInfo(
          iconInfo: Iconsax.info_circle_outline,
          colorIcon: Theme.of(context).colorScheme.error,
          textInfo: 'Are you sure you want to Delete Account ?',
          textButton: 'Delete',
          colorButton: Theme.of(context).colorScheme.error,
          onTap: () {
            enterDelete(5);
          },
        );
      },
    );
  }

  Future<void> enterDelete(int seconds) async {
    showLoading(context);

    try {
      final user = widget.currentUser;

      final authCredential = EmailAuthProvider.credential(
        email: user.email!,
        password: 'password_pengguna', // Ganti dengan cara mengumpulkan password pengguna
      );
      await user.reauthenticateWithCredential(authCredential);
      final imageTenantPath = 'image_tenants/${user.uid}';
      final imageMenuPath = 'image_menus/${user.uid}';

      final storageRef = FirebaseStorage.instance.ref();
      final ListResult tenantFiles = await storageRef.child(imageTenantPath).listAll();
      final ListResult menuFiles = await storageRef.child(imageMenuPath).listAll();

      // Hapus semua file dari imageTenantPath
      for (var file in tenantFiles.items) {
        await file.delete();
      }

      for (var file in menuFiles.items) {
        await file.delete();
      }
      await FirebaseFirestore.instance.collection('tenants').doc(user.uid).delete();

      await user.delete();

      snackBarCustom(
        context,
        Theme.of(context).colorScheme.secondary,
        'Deleted, Successfully',
        Colors.white,
        seconds,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Error deleting account: $e');
      snackBarCustom(
        context,
        Theme.of(context).colorScheme.error,
        'Error: $e',
        Colors.white,
        seconds,
      );
    } finally {
      hideLoading(context);
    }
  }
}
