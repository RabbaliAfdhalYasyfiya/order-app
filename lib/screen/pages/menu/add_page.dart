import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../widget/loading.dart';
import '../../../widget/button.dart';
import '../../../widget/form.dart';
import '../../../widget/snackbar.dart';

class AddPage extends StatefulWidget {
  const AddPage({
    super.key,
    required this.currentUser,
    required this.kategori,
  });

  final User currentUser;
  final List<String> kategori;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _storage = FirebaseStorage.instance;

  final namaMenuController = TextEditingController();
  final hargaMenuController = TextEditingController();
  final stokMenuController = TextEditingController();
  final kategoriMenuController = TextEditingController();
  final kategoriManualController = TextEditingController();

  final fieldNamaMenu = FocusNode();
  final fieldHargaMenu = FocusNode();
  final fieldStokMenu = FocusNode();
  final fieldKategoriMenu = FocusNode();

  File? _imageFile;

  String idMenu = '';

  //var uuid = const Uuid().v4();

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
        _imageFile = File(file.path!);
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
  void initState() {
    widget.kategori;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: ButtonBack(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title: const Text('Add Menu'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
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
                                    child: _imageFile != null
                                        ? Image.file(
                                            _imageFile!,
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.low,
                                          )
                                        : Image.asset(
                                            'assets/images/empty_image.png',
                                            height: double.infinity,
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                            filterQuality: FilterQuality.low,
                                          ),
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
                                    backgroundColor:
                                        WidgetStatePropertyAll(Theme.of(context).primaryColor),
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
                        ),
                        const Spacer(),
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
                        FocusScope.of(context).requestFocus(fieldKategoriMenu);
                      },
                    ),
                    const Gap(10),
                    FormFieldsKategori(
                      prefixIcon: Iconsax.element_plus_outline,
                      inputType: TextInputType.name,
                      controller: kategoriMenuController,
                      manualController: kategoriManualController,
                      hintText: 'Kategori Menu',
                      tap: false,
                      maxLineBoolean: false,
                      textInputFormatter: FilteringTextInputFormatter.singleLineFormatter,
                      focusNode: fieldKategoriMenu,
                      onFieldSubmit: (val) {
                        FocusScope.of(context).requestFocus();
                      },
                      kategori: widget.kategori,
                    ),
                  ],
                ),
                const Gap(25),
                ButtonCustom(
                  onPressed: () {
                    enterAddMenu(5);
                  },
                  addBorder: false,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Text(
                    'Tambah Menu',
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

  Future<void> tambahMenu(
    String imageMenu,
    String namaMenu,
    String hargaMenu,
    String kategoriMenu,
    int stokMenu,
  ) async {
    try {
      DocumentReference menuRef = await FirebaseFirestore.instance
          .collection('tenants')
          .doc(widget.currentUser.uid)
          .collection('menus')
          .add({
        'id_tenant': widget.currentUser.uid,
        'image_menu': imageMenu,
        'nama_menu': namaMenu,
        'harga_menu': hargaMenu,
        'kategori_menu': kategoriMenu,
        'stock_menu': stokMenu,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await menuRef.update({
        'id_menu': menuRef.id,
      });

      idMenu = menuRef.id;
    } catch (e) {
      debugPrint('Add Menu error:  $e');
      idMenu = '';
    }
  }

  Future<void> enterAddMenu(int seconds) async {
    showLoading(context);

    try {
      final kategoriMenu = kategoriMenuController.text.isNotEmpty
          ? kategoriMenuController.text
          : kategoriManualController.text;

      await tambahMenu(
        '',
        namaMenuController.text.trim(),
        hargaMenuController.text.trim(),
        kategoriMenu.trim(),
        int.parse(stokMenuController.text.trim()),
      );

      if (idMenu.isEmpty) {
        throw Exception('Menu ID cannot be empty');
      } else {
        final imageUrl = await uploadImageToStorage(
          'image_menus/${widget.currentUser.uid}/$idMenu',
          _imageFile!,
        );

        await FirebaseFirestore.instance
            .collection('tenants')
            .doc(widget.currentUser.uid)
            .collection('menus')
            .doc(idMenu)
            .update({
          'image_menu': imageUrl,
        });

        hideLoading(context);

        Navigator.pop(context);

        snackBarCustom(
          context,
          Theme.of(context).colorScheme.secondary,
          'Menu ${namaMenuController.text} Added, Successfully',
          Colors.white,
          seconds,
        );
      }
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
