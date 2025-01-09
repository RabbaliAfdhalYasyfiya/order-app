import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

import '../../../models/model_order.dart';
import '../other/success_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({
    super.key,
    required this.currentUser,
  });

  final User currentUser;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('tenant_id', isEqualTo: widget.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            debugPrint('Tenant ID: ${widget.currentUser.uid}');
            if (snapshot.hasError) {
              debugPrint('${snapshot.error}');
              return Center(
                child: Text('An error occurred: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/Mobile testing-bro.svg',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const Text(
                      'There is no Activity yet.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }

            final orderData =
                snapshot.data!.docs.map((doc) => OrderModel.fromDocument(doc)).toList();

            orderData.sort((a, b) => b.timeOrder.compareTo(a.timeOrder));

            final orderTimes = <String, List<OrderModel>>{};

            for (var order in orderData) {
              final orderDate = DateFormat('MMMM dd, yyyy').format(order.timeOrder.toDate());
              if (orderTimes.containsKey(orderDate)) {
                orderTimes[orderDate]!.add(order);
              } else {
                orderTimes[orderDate] = [order];
              }
            }

            List<Menus> allMenus = [];

            debugPrint('$allMenus');

            for (var order in orderData) {
              for (var menu in order.menus) {
                allMenus.add(
                  Menus.fromDocument(
                    {
                      'menu_id': menu.idMenus,
                      'image_menu': menu.imageMenus,
                      'nama_menu': menu.namaMenus,
                      'harga_menu': menu.hargaMenus,
                      'qty_menu': menu.qtyMenus,
                      'value_total': menu.valueTotal,
                    },
                    order.timeOrder,
                    order.payMethod,
                  ),
                );
              }
            }

            double taxFee = 1.0;
            double totalValue = 0.0;

            for (var menu in allMenus) {
              totalValue += menu.valueTotal;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Gap(10),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: orderTimes.keys.length,
                    itemBuilder: (context, index) {
                      final date = orderTimes.keys.elementAt(index);
                      final orders = orderTimes[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          ListView.separated(
                            separatorBuilder: (context, index) => const Gap(10),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];

                              List<Menus> allMenus = [];

                              for (var menu in order.menus) {
                                allMenus.add(
                                  Menus.fromDocument(
                                    {
                                      'menu_id': menu.idMenus,
                                      'image_menu': menu.imageMenus,
                                      'nama_menu': menu.namaMenus,
                                      'harga_menu': menu.hargaMenus,
                                      'qty_menu': menu.qtyMenus,
                                      'value_total': menu.valueTotal,
                                    },
                                    order.timeOrder,
                                    order.payMethod,
                                  ),
                                );
                              }

                              return InkWell(
                                splashColor: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(15),
                                onLongPress: () {
                                  debugPrint('Order ID : ${order.idOrder}');
                                  Navigator.push(
                                    context,
                                    createRoute(
                                      SuccessPage(
                                        orderedMenus: allMenus,
                                        priceTotal: order.hargaTotal,
                                        payMethod: order.payMethod,
                                        taxFee: 1,
                                        tenantId: widget.currentUser.uid,
                                        orderTime: order.timeOrder,
                                        initialIndex: 1,
                                        badge: false,
                                      ),
                                    ),
                                  );
                                },
                                onDoubleTap: () {
                                  debugPrint('Order ID : ${order.idOrder}');
                                  Navigator.push(
                                    context,
                                    createRoute(
                                      SuccessPage(
                                        orderedMenus: allMenus,
                                        priceTotal: order.hargaTotal,
                                        payMethod: order.payMethod,
                                        taxFee: 1,
                                        tenantId: widget.currentUser.uid,
                                        orderTime: order.timeOrder,
                                        initialIndex: 1,
                                        badge: false,
                                      ),
                                    ),
                                  );
                                },
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    extentRatio: 0.15,
                                    children: [
                                      CustomSlidableAction(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        backgroundColor: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(15),
                                        foregroundColor: Colors.white,
                                        autoClose: true,
                                        onPressed: (context) {
                                          Navigator.push(
                                            context,
                                            createRoute(
                                              SuccessPage(
                                                orderedMenus: allMenus,
                                                priceTotal: order.hargaTotal,
                                                payMethod: order.payMethod,
                                                taxFee: 1,
                                                tenantId: widget.currentUser.uid,
                                                orderTime: order.timeOrder,
                                                initialIndex: 1,
                                                badge: false,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Iconsax.receipt_2_outline,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: ExpansionTile(
                                    visualDensity: VisualDensity.comfortable,
                                    tilePadding: const EdgeInsets.symmetric(horizontal: 12.5),
                                    expansionAnimationStyle: AnimationStyle(
                                      curve: Curves.easeInSine,
                                      duration: const Duration(milliseconds: 150),
                                    ),
                                    expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                    expandedAlignment: Alignment.topCenter,
                                    initiallyExpanded: false,
                                    collapsedBackgroundColor:
                                        Theme.of(context).appBarTheme.backgroundColor,
                                    childrenPadding:
                                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                        width: 0.75,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: order.payMethod == 'QRIS'
                                          ? Colors.blue.shade50
                                          : Colors.green.shade50,
                                      child: Icon(
                                        order.payMethod == 'QRIS'
                                            ? Iconsax.scan_barcode_outline
                                            : Iconsax.moneys_outline,
                                        color:
                                            order.payMethod == 'QRIS' ? Colors.blue : Colors.green,
                                      ),
                                    ),
                                    title: Text(
                                      order.payMethod,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      order.idOrder,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    showTrailingIcon: true,
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Rp ${NumberFormat('#,##0.000', 'id_ID').format(order.hargaTotal).replaceAll(',', '.')}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const Text(
                                          '+ Tax Fee',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: allMenus.map(
                                      (e) {
                                        return ListTile(
                                          visualDensity: VisualDensity.compact,
                                          leading: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: Container(
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
                                                child: CachedNetworkImage(
                                                  imageUrl: e.imageMenus,
                                                  filterQuality: FilterQuality.low,
                                                  fit: BoxFit.cover,
                                                  useOldImageOnUrlChange: true,
                                                  fadeInCurve: Curves.easeIn,
                                                  fadeOutCurve: Curves.easeOut,
                                                  fadeInDuration: const Duration(milliseconds: 500),
                                                  fadeOutDuration:
                                                      const Duration(milliseconds: 750),
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
                                          ),
                                          title: Text(
                                            e.namaMenus,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 16,
                                              height: 1,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${e.qtyMenus}x',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                          trailing: Text(
                                            'Rp ${NumberFormat('#,##0.000', 'id_ID').format(e.valueTotal).replaceAll(',', '.')}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          const Gap(10),
                        ],
                      );
                    },
                  ),
                ),
                AnimatedSlide(
                  offset: isCheckoutCardVisible ? const Offset(0, 0) : const Offset(0, 1),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Tax Fee',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Text(
                                  'Rp ${NumberFormat('#,##0.000', 'id_ID').format(taxFee * orderData.length).replaceAll(',', '.')}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Sales',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Text(
                                  'Rp ${NumberFormat('#,##0.000', 'id_ID').format(totalValue).replaceAll(',', '.')}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Text(
                                  'Rp ${NumberFormat('#,##0.000', 'id_ID').format(totalValue + (taxFee * orderData.length)).replaceAll(',', '.')}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
