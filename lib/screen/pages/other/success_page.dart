import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

import '../../../models/model_tenant.dart';
import '../../../models/model_order.dart';
import '../../../widget/snackbar.dart';
import '../../../widget/button.dart';
import '../../main_page.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({
    super.key,
    required this.orderTime,
    required this.orderedMenus,
    required this.payMethod,
    required this.priceTotal,
    required this.taxFee,
    required this.tenantId,
    required this.initialIndex,
    required this.badge,
  });

  final Timestamp orderTime;
  final List<Menus> orderedMenus;
  final String payMethod;
  final double priceTotal;
  final double taxFee;
  final String tenantId;
  final int initialIndex;
  final bool badge;

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  ScrollController scrollController = ScrollController();
  List<BluetoothDevice> devices = [];
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  BluetoothDevice? selectedDevice;

  @override
  void initState() {
    super.initState();
    getPrinter();
  }

  void getPrinter() async {
    devices = await printer.getBondedDevices();

    setState(() {
      printer.isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('tenants').doc(widget.tenantId).snapshots(),
        builder: (context, snapshot) {
          debugPrint('Tenant ID : ${widget.tenantId}');
          if (!snapshot.hasData) {
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
                    'There is no Orders yet.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            debugPrint('${snapshot.error}');
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          }

          final tenant = TenantModel.fromDocument(snapshot.data!);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            color: Colors.transparent,
                            child: LottieBuilder.asset(
                              'assets/animations/success_animation.json',
                              filterQuality: FilterQuality.low,
                              alignment: Alignment.center,
                              repeat: true,
                              animate: true,
                              backgroundLoading: false,
                            ),
                          ),
                          const Text(
                            'The order has been Successfully!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(25),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter,
                          colors: [
                            Colors.grey.shade300,
                            Colors.grey.shade200,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // List Menu

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 6, 0, 5),
                                  child: Text(
                                    'Order Menu',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: ScrollbarTheme(
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
                                      child: ListView.builder(
                                        controller: scrollController,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: widget.orderedMenus.length,
                                        itemBuilder: (context, index) {
                                          final menu = widget.orderedMenus[index];

                                          return ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(horizontal: 16),
                                            titleAlignment: ListTileTitleAlignment.center,
                                            visualDensity: VisualDensity.comfortable,
                                            leading: ClipRRect(
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
                                                  imageUrl: menu.imageMenus,
                                                  filterQuality: FilterQuality.low,
                                                  fit: BoxFit.cover,
                                                  useOldImageOnUrlChange: true,
                                                  fadeInCurve: Curves.easeIn,
                                                  fadeOutCurve: Curves.easeOut,
                                                  fadeInDuration: const Duration(milliseconds: 500),
                                                  fadeOutDuration:
                                                      const Duration(milliseconds: 750),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              menu.namaMenus,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                height: 1,
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${menu.qtyMenus}x',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            trailing: Text(
                                              'Rp ${NumberFormat('#,##0.000', 'id_ID').format(menu.valueTotal).replaceAll(',', '.')}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          // Detail Order
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800.withValues(alpha: 0.035),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Date & Time',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Gap(5),
                                        Text(
                                          DateFormat('MMM dd, yyy - hh:mm')
                                              .format(widget.orderTime.toDate()),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1.5,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Payment Method',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Gap(5),
                                        Text(
                                          widget.payMethod.toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1.5,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tax Fee',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Rp ${NumberFormat('#,##0.000', 'id_ID').format(widget.taxFee).replaceAll(',', '.')}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1.5,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Rp ${NumberFormat('#,##0.000', 'id_ID').format(widget.priceTotal).replaceAll(',', '.')}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ButtonWithIcon(
                          onPressed: () {
                            orderPrint(
                              tenant.nameTenant,
                              tenant.emailTenant,
                              tenant.phoneNumberTenant,
                            );

                            setState(() {
                              getPrinter();
                            });
                          },
                          addBorder: false,
                          backgroundColor: Colors.greenAccent.shade700,
                          icon: const Icon(
                            CupertinoIcons.printer,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Print',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: ButtonCustom(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(
                                  initialIndex: widget.initialIndex,
                                  badge: widget.badge,
                                ),
                              ),
                            );
                          },
                          addBorder: false,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void orderPrint(
    String nameTenant,
    String emailTenant,
    String phoneTenant,
  ) {
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 1 / 1.75,
      isScrollControlled: false,
      enableDrag: false,
      useRootNavigator: false,
      showDragHandle: false,
      useSafeArea: true,
      isDismissible: false,
      barrierColor: Theme.of(context).shadowColor,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        style: ButtonStyle(
                          shadowColor: WidgetStatePropertyAll(Theme.of(context).shadowColor),
                          elevation: const WidgetStatePropertyAll(1),
                          backgroundColor: const WidgetStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          CupertinoIcons.xmark,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Icon(
                              Icons.drag_handle_rounded,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const Gap(15),
                          const Text(
                            'Select Device Printer',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),
                          ),
                          Divider(
                            thickness: 0.75,
                            color: Theme.of(context).dividerColor,
                            endIndent: 15,
                            indent: 15,
                          ),
                          Expanded(
                            child: devices.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Device Printer',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                : ListView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: devices.map(
                                      (e) {
                                        return ListTile(
                                          visualDensity: VisualDensity.comfortable,
                                          contentPadding:
                                              const EdgeInsets.symmetric(horizontal: 10),
                                          leading: Icon(
                                            CupertinoIcons.printer,
                                            color: Colors.grey.shade700,
                                          ),
                                          title: Text(
                                            e.name!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                            ),
                                          ),
                                          subtitle: Text(
                                            e.address!,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13,
                                            ),
                                          ),
                                          selected: selectedDevice == e,
                                          trailing: TextButton(
                                            onPressed: () async {
                                              setModalState(() {
                                                selectedDevice = e;
                                              });

                                              if (await printer.isConnected == true) {
                                                printDocument(nameTenant, emailTenant, phoneTenant);
                                                //printer.disconnect();
                                                snackBarCustom(
                                                  context,
                                                  Colors.greenAccent.shade400,
                                                  'Enter, Print Successfully',
                                                  Colors.white,
                                                  5,
                                                );
                                              } else {
                                                if (await printer.isAvailable == true) {
                                                  await printer.connect(selectedDevice!);

                                                  snackBarCustom(
                                                    context,
                                                    Theme.of(context).primaryColor,
                                                    'Connected to Printer ${e.name}',
                                                    Colors.white,
                                                    5,
                                                  );
                                                }
                                              }
                                              setModalState(() {});
                                            },
                                            style: ButtonStyle(
                                              visualDensity: VisualDensity.comfortable,
                                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50))),
                                              backgroundColor: WidgetStatePropertyAll(
                                                selectedDevice == e
                                                    ? Theme.of(context).primaryColor
                                                    : Colors.greenAccent.shade400,
                                              ),
                                            ),
                                            child: Text(
                                              selectedDevice == e ? 'Print' : 'Connect',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void printDocument(String name, String email, String phone) {
    const int maxLineLength = 9;

    List<String> splitStringToTwoLines(String str, int length) {
      if (str.length <= length) {
        return [str, ''];
      } else {
        String firstLine = '${str.substring(0, length)}-';
        String secondLine = '${str.substring(length)}...';
        return [firstLine, secondLine];
      }
    }

    printer.paperCut();
    printer.printNewLine();
    printer.printNewLine();
    printer.printCustom(name, 2, 1);
    printer.printNewLine();
    printer.printCustom(email, 1, 1);
    printer.printCustom(phone, 1, 1);
    printer.printNewLine();
    printer.printNewLine();

    printer.printLeftRight(
        'Date Due:', DateFormat('dd MMM yyyy').format(widget.orderTime.toDate()), 0);
    printer.printLeftRight('Pay Method:', widget.payMethod, 0);
    printer.printNewLine();
    printer.print3Column('Product', 'Qty', 'Price', 1);
    for (var i = 0; i < widget.orderedMenus.length; i++) {
      final menu = widget.orderedMenus[i];
      // String truncateString(String str, int length) {
      //   return (str.length <= length) ? str : '${str.substring(0, length)}...';
      // }
      // truncateString(product['name_product'], maxLineLength);

      // Memotong name_product jika terlalu panjang
      List<String> nameProductLines = splitStringToTwoLines(menu.namaMenus, maxLineLength);
      printer.print3Column(
          nameProductLines[0], '${menu.qtyMenus}x', menu.valueTotal.toStringAsFixed(3), 0);
      if (nameProductLines[1].isNotEmpty) {
        String secondLine = nameProductLines[1].trim();
        printer.printCustom(secondLine, 0, 0);
      }
    }
    printer.printNewLine();
    printer.printLeftRight('Tax Fee', 'Rp ${widget.taxFee.toStringAsFixed(3)}', 1);
    printer.printNewLine();
    printer.printLeftRight('Total', 'Rp ${widget.priceTotal.toStringAsFixed(3)}', 3);
    printer.printNewLine();
    printer.printNewLine();

    printer.printCustom('*** Terima Kasih! ***', 1, 1);
    printer.printNewLine();
    printer.printNewLine();
    printer.printNewLine();
    printer.paperCut();
  }
}
