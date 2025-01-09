import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../widget/button.dart';
import '../../../widget/form.dart';
import '../../../widget/loading.dart';
import '../../../widget/snackbar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.namaTenantController,
    required this.emailTenantController,
    required this.phoneTenantController,
    required this.imageTenantController,
    required this.currentUser,
  });

  final TextEditingController namaTenantController;
  final TextEditingController emailTenantController;
  final TextEditingController phoneTenantController;
  final TextEditingController imageTenantController;
  final User currentUser;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _storage = FirebaseStorage.instance;

  File? imageFile;

  final namaTenantFocusNode = FocusNode();
  final emailTenantFocusNode = FocusNode();
  final phoneTenantFocusNode = FocusNode();
  final savedTenantFocusNode = FocusNode();

  Future<void> getImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select a Image for Menu',
        lockParentWindow: true,
        allowCompression: true,
        withData: true,
        withReadStream: true,
        type: FileType.image,
      );
      if (result == null) return;

      final file = result.files.first;

      setState(() {
        imageFile = File(file.path!);
      });

      debugPrint('Name: ${file.name}');
      debugPrint('Bytes: ${file.bytes}');
      debugPrint('Size: ${file.size}');
      debugPrint('Extension: ${file.extension}');
      debugPrint('Path: ${file.path}');
    } catch (e) {
      debugPrint('Image error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: ButtonBack(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 175,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.deepPurple.shade200.withValues(alpha: 0.25),
                                Colors.deepPurple.shade100.withValues(alpha: 0.25),
                                Colors.deepPurple.shade50.withValues(alpha: 0.25),
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
                                  imageUrl: widget.imageTenantController.text,
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
                      Positioned(
                        bottom: 10,
                        right: 15,
                        child: IconButton(
                          visualDensity: VisualDensity.comfortable,
                          padding: const EdgeInsets.all(15),
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            elevation: const WidgetStatePropertyAll(2),
                            shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                            backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            getImage();
                          },
                          color: Theme.of(context).primaryColor,
                          icon: const Icon(
                            Iconsax.camera_outline,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),
                  FormFields(
                    prefixIcon: Iconsax.shop_outline,
                    inputType: TextInputType.name,
                    controller: widget.namaTenantController,
                    hintText: 'Nama Tenant',
                    tap: false,
                    maxLineBoolean: false,
                    textInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                    focusNode: namaTenantFocusNode,
                    onFieldSubmit: (p0) {
                      FocusScope.of(context).requestFocus(emailTenantFocusNode);
                    },
                  ),
                  const Gap(10),
                  FormFields(
                    prefixIcon: Iconsax.sms_outline,
                    inputType: TextInputType.emailAddress,
                    controller: widget.emailTenantController,
                    hintText: 'Email Address',
                    tap: false,
                    maxLineBoolean: false,
                    textInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                    focusNode: emailTenantFocusNode,
                    onFieldSubmit: (p0) {
                      FocusScope.of(context).requestFocus(phoneTenantFocusNode);
                    },
                  ),
                  const Gap(10),
                  FormFields(
                    prefixIcon: Iconsax.call_calling_outline,
                    inputType: TextInputType.phone,
                    controller: widget.phoneTenantController,
                    hintText: 'Phone Number',
                    tap: false,
                    maxLineBoolean: false,
                    textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                    focusNode: phoneTenantFocusNode,
                    onFieldSubmit: (p0) {
                      FocusScope.of(context).requestFocus(savedTenantFocusNode);
                    },
                  ),
                ],
              ),
              ButtonCustom(
                onPressed: () {
                  enterUpdate(5);
                },
                addBorder: false,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Text(
                  'Saved',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadImageToStorage(String childname, File file) async {
    Reference ref = _storage.ref().child(childname);
    Uint8List fileData = await file.readAsBytes();

    debugPrint('File size: ${fileData.lengthInBytes}');

    UploadTask uploadTask = ref.putData(fileData);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    debugPrint('Download URL: $downloadUrl');

    return downloadUrl;
  }

  Future<void> updateProfile(
    String imageTenant,
    String namaTenant,
    String emailTenant,
    String phoneNumberTenant,
  ) async {
    await FirebaseFirestore.instance.collection('tenants').doc(widget.currentUser.uid).update({
      'image_tenant': imageTenant,
      'nama_tenant': namaTenant,
      'email_tenant': emailTenant,
      'phoneNumber_tenant': phoneNumberTenant,
    });
  }

  Future<void> enterUpdate(int seconds) async {
    showLoading(context);
    try {
      updateProfile(
        await uploadImageToStorage('image_tenants/${widget.currentUser.uid}', imageFile!),
        widget.namaTenantController.text.trim(),
        widget.emailTenantController.text.trim(),
        widget.phoneTenantController.text.trim(),
      );

      Future.delayed(const Duration(milliseconds: 250), () {
        Navigator.pop(context);
      });

      snackBarCustom(
        context,
        Theme.of(context).colorScheme.secondary,
        'Saved Edited, Successfully',
        Colors.white,
        seconds,
      );
    } catch (e) {
      hideLoading(context);
      snackBarCustom(
        context,
        Theme.of(context).colorScheme.error,
        'Error : $e',
        Colors.white,
        seconds,
      );
    }
  }
}
