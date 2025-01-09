import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../models/model_menu.dart';
import '../../../widget/snackbar.dart';
import '../../../widget/tile.dart';
import 'cart_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    super.key,
    required this.currentUser,
  });

  final User currentUser;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  final currentTenant = FirebaseAuth.instance.currentUser;

  final Map<String, List<bool>> _checkedMenusMap = {};
  final Map<String, List<int>> _countsMap = {};
  final Map<String, List<MenuModel>> _menuDataMap = {};

  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  late Future<List<String>> _categoriesFuture;

  @override
  void initState() {
    _scrollController;
    _categoriesFuture = fetchCategories();
    _categoriesFuture.then((categories) {
      _tabController = TabController(length: categories.length, vsync: this);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void decCount(String categoryKey, int index) {
    setState(() {
      if (_countsMap[categoryKey]![index] > 0) {
        _countsMap[categoryKey]![index]--;
      }
    });
  }

  void incCount(String categoryKey, int index) {
    setState(() {
      _countsMap[categoryKey]![index]++;
    });
  }

  Future<List<String>> fetchCategories() async {
    final categories = <String>{}; // Menggunakan Set untuk menghindari duplikasi

    // Ambil dokumen produk berdasarkan tenantId
    final menusSnapshot = await FirebaseFirestore.instance
        .collection('tenants')
        .doc(currentTenant!.uid)
        .collection('menus')
        .get();

    // Iterasi dokumen untuk mendapatkan category_product
    for (var doc in menusSnapshot.docs) {
      final category = doc.data()['kategori_menu'] as String;
      if (category.isNotEmpty) {
        categories.add(category); // Menambahkan ke Set (otomatis menghindari duplikasi)
      }
    }

    return categories.toList(); // Konversi Set ke List
  }

  void processToCart() {
    List<MenuModel> selectedMenus = [];
    List<int> selectedCounts = [];

    _checkedMenusMap.forEach((categoryKey, checkedMenus) {
      for (int i = 0; i < checkedMenus.length; i++) {
        debugPrint('Product: $checkedMenus, dengan Category: $categoryKey');
        if (checkedMenus[i] && _countsMap[categoryKey]![i] > 0) {
          selectedMenus.add(_menuDataMap[categoryKey]![i]);
          selectedCounts.add(_countsMap[categoryKey]![i]);
        }
      }
    });

    if (selectedCounts.isEmpty) {
      debugPrint('Count Empty');
      snackBarCustom(
        context,
        Colors.redAccent.shade400,
        'Product Quantity needs to be filled in',
        Colors.white,
        5,
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CartPage(
            currentTenant: currentTenant!,
            selectedMenus: selectedMenus,
            selectedQuantities: selectedCounts,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _categoriesFuture,
      builder: (context, categorySnapshot) {
        if (categorySnapshot.hasError) {
          return Center(
            child: Text('Error: ${categorySnapshot.error}'),
          );
        } else if (!categorySnapshot.hasData || categorySnapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No categories found',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          );
        } else if (categorySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final categories = categorySnapshot.data!;

        categories.sort((a, b) => a.compareTo(b));

        if (_tabController.length != categories.length) {
          _tabController = TabController(length: categories.length, vsync: this);
        }

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 5, 16, 10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.deepPurple.shade100,
                      width: 1,
                    ),
                  ),
                  child: DefaultTabController(
                    length: categories.length,
                    animationDuration: const Duration(milliseconds: 250),
                    child: TabBar(
                      physics: const BouncingScrollPhysics(),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                      controller: _tabController,
                      isScrollable: true,
                      splashBorderRadius: BorderRadius.circular(10),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                      indicator: UnderlineTabIndicator(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                        borderSide: BorderSide(
                          width: 4,
                          color: Colors.deepPurple.shade400,
                        ),
                      ),
                      tabAlignment: TabAlignment.start,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.deepPurple.shade300,
                        fontWeight: FontWeight.w400,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 17,
                        color: Colors.deepPurple.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                      dividerColor: Colors.transparent,
                      automaticIndicatorColorAdjustment: true,
                      overlayColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
                      tabs: categories.map((category) => Tab(text: category)).toList(),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: TabBarView(
                  dragStartBehavior: DragStartBehavior.start,
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: categories.map(
                    (category) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('tenants')
                            .doc(currentTenant!.uid)
                            .collection('menus')
                            .where('kategori_menu', isEqualTo: category)
                            .snapshots(),
                        builder: (context, menuSnapshot) {
                          if (menuSnapshot.hasError) {
                            debugPrint('${menuSnapshot.error}');
                            return Center(
                              child: Text('An error occurred: ${menuSnapshot.error}'),
                            );
                          } else if (categorySnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!menuSnapshot.hasData) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Mobile testing-bro.svg',
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    'There no is Products have yet.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final menuData = menuSnapshot.data!.docs
                              .map<MenuModel>((doc) => MenuModel.fromDocument(doc))
                              .toList();

                          menuData
                              .sort((MenuModel a, MenuModel b) => a.namaMenu.compareTo(b.namaMenu));

                          final categoryKey = category;

                          _menuDataMap[categoryKey] = menuData;

                          if (!_checkedMenusMap.containsKey(categoryKey)) {
                            _checkedMenusMap[categoryKey] =
                                List<bool>.filled(menuData.length, false);
                            _countsMap[categoryKey] = List<int>.filled(menuData.length, 0);
                          }

                          final checkedMenus = _checkedMenusMap[categoryKey]!;
                          final counts = _countsMap[categoryKey]!;

                          return Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    mainAxisExtent: 275,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                                  shrinkWrap: true,
                                  itemCount: menuData.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    final menu = menuData[index];

                                    return OrderTile(
                                      index: index,
                                      count: counts[index],
                                      imageMenu: menu.imageMenu,
                                      namaMenu: menu.namaMenu,
                                      hargaMenu: menu.hargaMenu,
                                      checkMenu: checkedMenus[index],
                                      tapped: () {
                                        setState(() {
                                          checkedMenus[index] = !checkedMenus[index];
                                          if (checkedMenus[index]) {
                                            incCount(categoryKey, index);
                                          } else {
                                            counts[index] = 0;
                                          }
                                        });
                                      },
                                      onChanged: (bool? value) {
                                        setState(() {
                                          checkedMenus[index] = value!;
                                          if (value) {
                                            incCount(categoryKey, index);
                                          } else {
                                            counts[index] = 0;
                                          }
                                        });
                                      },
                                      onDecCount: () => decCount(categoryKey, index),
                                      onIncCount: () => incCount(categoryKey, index),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: AnimatedSlide(
                                  offset: checkedMenus.contains(true)
                                      ? const Offset(0, 0)
                                      : const Offset(0, 1),
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  child: Visibility(
                                    visible: checkedMenus.contains(true),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 25,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.vertical(top: Radius.circular(25)),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.vertical(
                                                top: Radius.circular(25)),
                                            color: Theme.of(context).appBarTheme.backgroundColor,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              const Gap(20),
                                              ElevatedButton.icon(
                                                icon: const Icon(
                                                  Iconsax.shopping_cart_outline,
                                                  color: Colors.white,
                                                ),
                                                iconAlignment: IconAlignment.start,
                                                label: const Text(
                                                  'Order Menu',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  processToCart();
                                                },
                                                style: ButtonStyle(
                                                  fixedSize: const WidgetStatePropertyAll(
                                                      Size.fromWidth(double.maxFinite)),
                                                  shape: WidgetStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15),
                                                    ),
                                                  ),
                                                  backgroundColor: WidgetStatePropertyAll(
                                                      Theme.of(context).primaryColor),
                                                  padding: const WidgetStatePropertyAll(
                                                    EdgeInsets.symmetric(vertical: 20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
