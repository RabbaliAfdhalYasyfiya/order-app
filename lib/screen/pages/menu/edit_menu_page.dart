import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../widget/button.dart';
import '../../../widget/form.dart';

class EditMenuPage extends StatefulWidget {
  const EditMenuPage({
    super.key,
    required this.imageMenu,
    required this.namaMenu,
    required this.hargaMenu,
    required this.stokMenu,
  });

  final String imageMenu;
  final String namaMenu;
  final String hargaMenu;
  final int stokMenu;

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  late TextEditingController namaMenuController;
  late TextEditingController hargaMenuController;
  late TextEditingController stokMenuController;

  final fieldNamaMenu = FocusNode();
  final fieldHargaMenu = FocusNode();
  final fieldStokMenu = FocusNode();

  @override
  void initState() {
    super.initState();
    namaMenuController = TextEditingController(text: widget.namaMenu);
    hargaMenuController = TextEditingController(text: widget.hargaMenu);
    stokMenuController = TextEditingController(text: widget.stokMenu.toString());
  }

  File? imageFile;

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
        title: const Text('Edit Menu'),
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
                                  imageUrl: widget.imageMenu,
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
                    prefixIcon: Iconsax.edit_2_outline,
                    inputType: TextInputType.name,
                    controller: namaMenuController,
                    hintText: 'Nama Menu',
                    tap: false,
                    maxLineBoolean: false,
                    textInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                    focusNode: fieldNamaMenu,
                    onFieldSubmit: (val) {
                      FocusScope.of(context).requestFocus(fieldHargaMenu);
                    },
                  ),
                  const Gap(10),
                  FormFields(
                    prefixIcon: Iconsax.dollar_square_outline,
                    inputType: TextInputType.number,
                    controller: hargaMenuController,
                    hintText: 'Harga Menu',
                    tap: false,
                    maxLineBoolean: false,
                    textInputFormatter: CurrencyTextInputFormatter.currency(
                      locale: 'id',
                      symbol: '',
                      decimalDigits: 0,
                    ),
                    focusNode: fieldHargaMenu,
                    onFieldSubmit: (val) {
                      FocusScope.of(context).requestFocus(fieldStokMenu);
                    },
                  ),
                  const Gap(10),
                  FormFields(
                    prefixIcon: Iconsax.folder_add_outline,
                    inputType: TextInputType.number,
                    controller: stokMenuController,
                    hintText: 'Stok Menu',
                    tap: false,
                    maxLineBoolean: false,
                    textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                    focusNode: fieldStokMenu,
                    onFieldSubmit: (val) {
                      FocusScope.of(context).requestFocus();
                    },
                  ),
                  const Gap(15),
                ],
              ),
              ButtonCustom(
                onPressed: () {
                  //updateDataMenu();
                },
                addBorder: false,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Text(
                  'Saved Menu',
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
}
