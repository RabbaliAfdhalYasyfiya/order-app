import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../models/model_kategori.dart';
import '../../../models/model_menu.dart';
import '../../../widget/snackbar.dart';
import '../../../widget/tile.dart';
import 'edit_menu_page.dart';
import 'add_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({
    super.key,
    required this.currentUser,
  });

  final User currentUser;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<String> kategori = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => AddPage(
                currentUser: widget.currentUser,
                kategori: kategori,
              ),
            ),
          );
        },
        icon: const Icon(
          Iconsax.additem_bold,
          color: Colors.white,
        ),
        label: const Text(
          'Add Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tenants')
            .doc(widget.currentUser.uid)
            .collection('menus')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/Mobile testing-bro.svg',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    'There is no Menu yet.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
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
              ),
            );
          }

          final List<MenuModel> menuData =
              snapshot.data!.docs.map((doc) => MenuModel.fromDocument(doc)).toList();

          menuData.sort((a, b) => a.namaMenu.compareTo(b.namaMenu));

          final Map<String, List<MenuModel>> kategoriMenus = {};

          for (var menu in menuData) {
            kategoriMenus.putIfAbsent(menu.kategoriMenu, () => []).add(menu);
          }

          final List<KategoriModel> kategoriData = kategoriMenus.entries
              .map((e) => KategoriModel(
                    kategori: e.key,
                    menuItems: e.value,
                  ))
              .toList();

          kategoriData.sort((a, b) => a.kategori.compareTo(b.kategori));

          final List<String> kategoriList = kategoriData.map((e) => e.kategori).toList();

          kategori = kategoriList;

          return SafeArea(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: kategoriData.length,
                      (context, index) {
                        final kategori = kategoriData[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${kategori.kategori} (${kategori.menuItems.length})',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(5),
                            ListView.separated(
                              separatorBuilder: (context, index) => const Gap(5),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: kategori.menuItems.length,
                              padding: const EdgeInsets.only(bottom: 16),
                              itemBuilder: (context, index) {
                                final menu = kategori.menuItems[index];
                                double hargaMenuDouble = double.parse(
                                    menu.hargaMenu.replaceAll('.', '').replaceAll(',', '.'));
                                int hargaMenuInt = hargaMenuDouble.toInt();

                                return Slidable(
                                  key: ValueKey(index),
                                  closeOnScroll: true,
                                  enabled: true,
                                  direction: Axis.horizontal,
                                  dragStartBehavior: DragStartBehavior.start,
                                  useTextDirection: true,
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    extentRatio: 0.35,
                                    dragDismissible: true,
                                    children: [
                                      CustomSlidableAction(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        backgroundColor: Colors.deepPurpleAccent.shade200,
                                        borderRadius: BorderRadius.circular(15),
                                        autoClose: true,
                                        onPressed: (context) {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => EditMenuPage(
                                                imageMenu: menu.imageMenu,
                                                namaMenu: menu.namaMenu,
                                                hargaMenu: menu.hargaMenu,
                                                stokMenu: menu.stokMenu,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Iconsax.edit_outline,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            Gap(5),
                                            Text(
                                              'Edit',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomSlidableAction(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        backgroundColor: Colors.redAccent.shade400,
                                        borderRadius: BorderRadius.circular(15),
                                        foregroundColor: Colors.white,
                                        autoClose: true,
                                        onPressed: (context) {
                                          deletedMenu(
                                            menu.idMenu,
                                            menu.namaMenu,
                                            5,
                                          );
                                        },
                                        child: const Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Iconsax.trash_outline,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            Gap(5),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: MenuTile(
                                    menuItem: menu,
                                    hargaMenuInt: hargaMenuInt,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> deletedMenu(
    String idMenu,
    String namaMenu,
    int seconds,
  ) async {
    try {
      final imagePath = 'image_menus/${widget.currentUser.uid}/$idMenu';

      final storageRef = FirebaseStorage.instance.ref().child(imagePath);

      await storageRef.delete();

      await FirebaseFirestore.instance
          .collection('tenants')
          .doc(widget.currentUser.uid)
          .collection('menus')
          .doc(idMenu)
          .delete();

      snackBarCustom(
        context,
        Theme.of(context).primaryColor,
        'Menu $namaMenu Deleted, Successfully',
        Colors.white,
        seconds,
      );
    } catch (e) {
      debugPrint('Error deleting menu: $e');
    }
  }
}
