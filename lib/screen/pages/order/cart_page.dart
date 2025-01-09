import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

import '../../../models/model_menu.dart';
import '../../../models/model_order.dart';
import '../../../widget/bottom_sheet.dart';
import '../../../widget/button.dart';
import '../../../widget/loading.dart';
import '../../../widget/snackbar.dart';
import '../../../widget/tile.dart';
import '../other/success_page.dart';

enum MenuTypeEnum { QRIS, Cash }

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
    required this.currentTenant,
    required this.selectedMenus,
    required this.selectedQuantities,
  });

  final User currentTenant;
  final List<MenuModel> selectedMenus;
  final List<int> selectedQuantities;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  MenuTypeEnum? _productTypeEnum;

  ScrollController scrollController = ScrollController();

  bool isCheckoutCardVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        setState(() {
          isCheckoutCardVisible = true;
        });
      },
    );
  }

  double _calculateSubtotal() {
    double subtotal = 0;
    for (int i = 0; i < widget.selectedMenus.length; i++) {
      final double price =
          double.tryParse(widget.selectedMenus[i].hargaMenu.replaceAll('Rp', '')) ?? 0;
      subtotal += price * widget.selectedQuantities[i];
    }
    return subtotal;
  }

  void addCheckoutMenu() async {
    showLoading(context);

    final List<Menus> orderMenu = [];
    double subTotal = _calculateSubtotal();
    double taxFee = 1;
    double priceTotal = 0.0 + taxFee;

    var payMethod = _productTypeEnum?.name;
    var orderTime = FieldValue.serverTimestamp();
    for (int i = 0; i < widget.selectedMenus.length; i++) {
      final menu = widget.selectedMenus[i];
      final quantity = widget.selectedQuantities[i];
      final double price = double.tryParse(menu.hargaMenu.replaceAll('Rp', '')) ?? 0.0;
      final double valuePrice = price * quantity;

      orderMenu.add(
        Menus(
          idMenus: menu.idMenu,
          imageMenus: menu.imageMenu,
          namaMenus: menu.namaMenu,
          hargaMenus: price,
          qtyMenus: quantity,
          valueTotal: valuePrice,
          timeMenus: Timestamp.now(),
          payMethod: payMethod!,
        ),
      );

      priceTotal += valuePrice;

      await FirebaseFirestore.instance
          .collection('tenants')
          .doc(widget.currentTenant.uid)
          .collection('menus')
          .doc(menu.idMenu)
          .update({
        'stock_menu': FieldValue.increment(-quantity),
      });
    }

    DocumentReference orderRef = await FirebaseFirestore.instance.collection('orders').add({
      'tenant_id': widget.currentTenant.uid,
      'menus': orderMenu
          .map(
            (p) => {
              'menu_id': p.idMenus,
              'image_menu': p.imageMenus,
              'nama_menu': p.namaMenus,
              'harga_menu': p.hargaMenus,
              'qty_menu': p.qtyMenus,
              'value_total': p.valueTotal,
            },
          )
          .toList(),
      'sub_total': subTotal,
      'harga_total': priceTotal,
      'pay_method': payMethod,
      'order_time': orderTime,
    });
    await orderRef.update({
      'order_id': orderRef.id,
    });

    // Get the actual order data including the timestamp
    DocumentSnapshot orderSnapshot = await orderRef.get();
    var actualOrderTime = orderSnapshot.get('order_time') as Timestamp;

    for (var menu in orderMenu) {
      menu.timeMenus = actualOrderTime;
    }

    // Simpan notifikasi ke Firestore
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': 'Order Success',
      'message': 'Your order has been successfully processed.',
      'time': FieldValue.serverTimestamp(),
      'read': false,
    });


    hideLoading(context);

    Navigator.push(
      context,
      createRoute(
        SuccessPage(
          orderedMenus: orderMenu,
          priceTotal: priceTotal,
          taxFee: taxFee,
          payMethod: payMethod!,
          tenantId: widget.currentTenant.uid,
          orderTime: actualOrderTime,
          initialIndex: 0,
          badge: true,
        ),
      ),
    );

    snackBarCustom(
      context,
      Colors.greenAccent.shade400,
      'Orders, Menu Successfully',
      Colors.white,
      5,
    );
  }

  // Future<void> _sendLocalNotification(String title, String message) async {
  //   var androidDetails = const AndroidNotificationDetails(
  //     'order_channel_id',
  //     'Order Notifications',
  //     channelDescription: 'Notifications for order updates.',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   var notificationDetails = NotificationDetails(android: androidDetails);
  //   await FlutterLocalNotificationsPlugin().show(
  //     0,
  //     title,
  //     message,
  //     notificationDetails,
  //   );
  // }

  Route createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void deleteMenu(int index) {
    showLoading(context);
    setState(() {
      widget.selectedMenus.removeAt(index);
      widget.selectedQuantities.removeAt(index);
      _calculateSubtotal();
    });
    Navigator.pop(context);
  }

  void countInfoEdit(
    final String imageProduct,
    final String nameProduct,
    final int quantity,
    final double valuePrice,
    final int index,
    final Function(int) deleteProduct,
  ) {
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 1 / 2,
      isScrollControlled: false,
      enableDrag: false,
      useRootNavigator: false,
      showDragHandle: false,
      useSafeArea: true,
      isDismissible: false,
      barrierColor: Theme.of(context).shadowColor,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomEditCount(
          imageProduct: imageProduct,
          nameProduct: nameProduct,
          quantity: quantity,
          valuePrice: valuePrice,
          index: index,
          deleteProduct: deleteProduct,
          onSaveChanges: (newQuantity, newTotalPrice) {
            updateProduct(index, newQuantity);
          },
        );
      },
    );
  }

  void updateProduct(int index, int newQuantity) {
    setState(() {
      widget.selectedQuantities[index] = newQuantity;
      _calculateSubtotal(); // Update the subtotal
    });
  }

  void _deleteMenu(int index) {
    showLoading(context);
    setState(() {
      widget.selectedMenus.removeAt(index);
      widget.selectedQuantities.removeAt(index);
      _calculateSubtotal();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double subTotal = _calculateSubtotal();
    double taxFee = 1; // Example fixed tax fee
    double orderTotal = subTotal + taxFee;
    debugPrint('$orderTotal');

    if (widget.selectedMenus.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          Navigator.pop(context);
        },
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Iconsax.arrow_square_left_bold,
            color: Theme.of(context).primaryColor,
            size: 25,
          ),
        ),
        titleSpacing: 0,
        title: const Text('Cart Order'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: widget.selectedMenus.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Here, there are',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          Text(
                            'no Menu in the Cart yet',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ScrollbarTheme(
                      data: const ScrollbarThemeData(
                        crossAxisMargin: 0,
                        trackVisibility: WidgetStatePropertyAll(false),
                        thumbVisibility: WidgetStatePropertyAll(true),
                        interactive: true,
                        minThumbLength: 5,
                        radius: Radius.circular(50),
                        thickness: WidgetStatePropertyAll(5),
                        mainAxisMargin: 50,
                        thumbColor: WidgetStatePropertyAll(Colors.black26),
                      ),
                      child: Scrollbar(
                        controller: scrollController,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Gap(10),
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: widget.selectedMenus.length,
                          itemBuilder: (context, index) {
                            MenuModel menu = widget.selectedMenus[index];
                            int quantity = widget.selectedQuantities[index];
                            double price =
                                double.tryParse(menu.hargaMenu.replaceAll('Rp', '')) ?? 0;
                            double valuePrice = price * quantity;

                            return CartTile(
                              menu: menu,
                              quantity: quantity,
                              valuePrice: valuePrice,
                              onLongPress: () {
                                _deleteMenu(index);
                              },
                              onTap: () {
                                countInfoEdit(
                                  menu.imageMenu,
                                  menu.namaMenu,
                                  quantity,
                                  valuePrice,
                                  index,
                                  (index) {
                                    _deleteMenu(index);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
            ),
            Expanded(
              flex: 6,
              child: checkoutCard(
                context,
                widget.selectedMenus.length,
                subTotal,
                taxFee,
                orderTotal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkoutCard(
    BuildContext context,
    int items,
    double subtotal,
    double taxFee,
    double orderTotal,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Menu Items',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '$items',
                        style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,##0.000', 'id_ID').format(subtotal).replaceAll(',', '.')}',
                        style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tax Fee',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,##0.000', 'id_ID').format(taxFee).replaceAll(',', '.')}',
                        style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(5),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade600.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Rp ${NumberFormat('#,##0.000', 'id_ID').format(orderTotal).replaceAll(',', '.')}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.5,
              indent: 10,
              endIndent: 10,
              color: Theme.of(context).dividerColor,
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gap(10),
                      Icon(
                        Iconsax.empty_wallet_bold,
                        size: 21,
                        color: Colors.black,
                      ),
                      Gap(10),
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.grey,
                            ),
                            child: RadioListTile<MenuTypeEnum>(
                              visualDensity: VisualDensity.compact,
                              activeColor: Colors.deepPurple.shade600,
                              value: MenuTypeEnum.QRIS,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                              title: Text(
                                MenuTypeEnum.QRIS.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              groupValue: _productTypeEnum,
                              onChanged: (value) {
                                setState(() {
                                  _productTypeEnum = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.grey,
                            ),
                            child: RadioListTile<MenuTypeEnum>(
                              visualDensity: VisualDensity.compact,
                              activeColor: Colors.deepPurple.shade600,
                              value: MenuTypeEnum.Cash,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                              title: Text(
                                MenuTypeEnum.Cash.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              groupValue: _productTypeEnum,
                              onChanged: (value) {
                                setState(() {
                                  _productTypeEnum = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(15),
            ButtonCustom(
              onPressed: () {
                if (widget.selectedMenus.isEmpty) {
                  snackBarCustom(
                    context,
                    Colors.redAccent.shade400,
                    'Menus, Ordered in Cart are Empty',
                    Colors.white,
                    5,
                  );
                } else if (_productTypeEnum == null) {
                  snackBarCustom(
                    context,
                    Colors.redAccent.shade400,
                    'Payment Method, not Checked',
                    Colors.white,
                    5,
                  );
                } else {
                  addCheckoutMenu();
                }
              },
              addBorder: false,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Text(
                'Checkout',
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
    );
  }
}
