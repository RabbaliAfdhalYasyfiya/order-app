import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'button.dart';

class BottomSheetInfo extends StatelessWidget {
  const BottomSheetInfo({
    super.key,
    required this.iconInfo,
    required this.colorIcon,
    required this.textInfo,
    required this.textButton,
    required this.colorButton,
    required this.onTap,
  });

  final IconData iconInfo;
  final Color colorIcon;
  final String textInfo;
  final String textButton;
  final Color colorButton;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Center(
                child: Icon(
                  Icons.drag_handle_rounded,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Icon(
                        iconInfo,
                        color: colorIcon,
                        size: 45,
                      ),
                    ),
                    const Gap(15),
                    Expanded(
                      flex: 2,
                      child: Text(
                        textInfo,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(15),
          Row(
            children: [
              Expanded(
                child: ButtonInfo(
                  text: textButton,
                  color: colorButton,
                  borderColor: colorButton,
                  textColor: Colors.white,
                  smallText: false,
                  onTap: onTap,
                ),
              ),
              const Gap(10),
              Expanded(
                child: ButtonInfo(
                  text: 'Cancel',
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderColor: Theme.of(context).colorScheme.outline,
                  textColor: Theme.of(context).primaryColor,
                  smallText: false,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class BottomEditCount extends StatefulWidget {
  const BottomEditCount({
    super.key,
    required this.imageProduct,
    required this.nameProduct,
    required this.quantity,
    required this.valuePrice,
    required this.index,
    required this.deleteProduct,
    required this.onSaveChanges,
  });

  final String imageProduct;
  final String nameProduct;
  final int quantity;
  final double valuePrice;
  final int index;
  final Function(int) deleteProduct;
  final Function(int, double) onSaveChanges;

  @override
  State<BottomEditCount> createState() => _BottomEditCountState();
}

class _BottomEditCountState extends State<BottomEditCount> {
  late int currentQuantity;
  late double unitPrice;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    currentQuantity = widget.quantity;
    unitPrice = widget.valuePrice / widget.quantity;
    totalPrice = unitPrice * currentQuantity;
  }

  void decCount() {
    setState(() {
      if (currentQuantity > 0) {
        currentQuantity--;
        totalPrice = unitPrice * currentQuantity;
      }
    });
  }

  void incCount() {
    setState(() {
      currentQuantity++;
      totalPrice = unitPrice * currentQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.down,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Gap(10),
                IconButton(
                  style: ButtonStyle(
                    shadowColor: WidgetStatePropertyAll(Theme.of(context).shadowColor),
                    elevation: const WidgetStatePropertyAll(1),
                    backgroundColor:
                        WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    CupertinoIcons.xmark,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.drag_handle_rounded,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                height: double.infinity,
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
                                child: CachedNetworkImage(
                                  imageUrl: widget.imageProduct,
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
                          ),
                          title: Text(
                            widget.nameProduct,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              height: 1.15,
                            ),
                          ),
                          visualDensity: VisualDensity.standard,
                          trailing: Text(
                            'Rp ${totalPrice == 0 ? '-' : NumberFormat('#,##0.000', 'id_ID').format(totalPrice).replaceAll(',', '.')}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            '${currentQuantity}x',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Gap(15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                decCount();
                              },
                              icon: const Icon(CupertinoIcons.minus),
                              color: Colors.white,
                              style: ButtonStyle(
                                shape: const WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10),
                                      left: Radius.circular(15),
                                    ),
                                  ),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 50,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              child: Center(
                                child: Text(
                                  '$currentQuantity',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                incCount();
                              },
                              icon: const Icon(CupertinoIcons.add),
                              color: Colors.white,
                              style: ButtonStyle(
                                shape: const WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(10),
                                      right: Radius.circular(15),
                                    ),
                                  ),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(25),
                  ElevatedButton(
                    onPressed: () {
                      if (currentQuantity == 0) {
                        Navigator.pop(context);
                        widget.deleteProduct(widget.index);
                      } else {
                        widget.onSaveChanges(currentQuantity, totalPrice);
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      fixedSize: const WidgetStatePropertyAll(Size.fromWidth(double.maxFinite)),
                      elevation: const WidgetStatePropertyAll(1),
                      backgroundColor: WidgetStatePropertyAll(
                        currentQuantity == 0
                            ? Colors.redAccent.shade400
                            : Theme.of(context).primaryColor,
                      ),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    child: Text(
                      currentQuantity == 0 ? 'Delete' : 'Save Changes',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

