import 'package:cached_network_image/cached_network_image.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';

import '../models/model_menu.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.index,
    required this.count,
    required this.imageMenu,
    required this.namaMenu,
    required this.hargaMenu,
    required this.checkMenu,
    required this.tapped,
    required this.onChanged,
    required this.onDecCount,
    required this.onIncCount,
  });

  final int index;
  final int count;
  final String imageMenu;
  final String namaMenu;
  final String hargaMenu;
  final bool checkMenu;
  final Function() tapped;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDecCount;
  final VoidCallback onIncCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: tapped,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
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
                            imageUrl: imageMenu,
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
                  ),
                ),
                const Gap(10),
                Column(
                  children: [
                    Text(
                      namaMenu,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        height: 1,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      'Rp $hargaMenu',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 10,
                      endIndent: 10,
                      indent: 10,
                      color: Theme.of(context).dividerColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: onDecCount,
                              icon: const Icon(CupertinoIcons.minus),
                              color: Colors.white,
                              constraints: const BoxConstraints(minHeight: double.infinity),
                              style: ButtonStyle(
                                shape: const WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: onIncCount,
                              icon: const Icon(CupertinoIcons.add),
                              color: Colors.white,
                              constraints: const BoxConstraints(minHeight: double.infinity),
                              style: ButtonStyle(
                                shape: const WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(15),
                                      topLeft: Radius.circular(10),
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 1,
            left: 1,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Checkbox.adaptive(
                value: checkMenu,
                visualDensity: VisualDensity.compact,
                activeColor: Theme.of(context).primaryColor,
                side: const BorderSide(color: Colors.black, width: 1.5),
                autofocus: true,
                splashRadius: 50,
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  MenuTile({
    super.key,
    required this.menuItem,
    required this.hargaMenuInt,
  });

  MenuModel menuItem;
  int hargaMenuInt;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      visualDensity: VisualDensity.comfortable,
      horizontalTitleGap: 10,
      leading: AspectRatio(
        aspectRatio: 1 / 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
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
              imageUrl: menuItem.imageMenu,
              filterQuality: FilterQuality.low,
              fit: BoxFit.cover,
              useOldImageOnUrlChange: true,
              fadeInCurve: Curves.easeIn,
              fadeOutCurve: Curves.easeOut,
              fadeInDuration: const Duration(milliseconds: 250),
              fadeOutDuration: const Duration(milliseconds: 500),
              errorWidget: (context, url, error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Iconsax.info_circle_bold,
                        size: 15,
                        color: Colors.redAccent,
                      ),
                      const Gap(2),
                      Text(
                        'Image $error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 5,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      isThreeLine: false,
      title: Text(
        menuItem.namaMenu,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        '${menuItem.kategoriMenu} · (${menuItem.stokMenu} Stok)',
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          'Rp ${NumberFormat('#,##0', 'id_ID').format(hargaMenuInt).replaceAll(',', '.')}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class CartTile extends StatelessWidget {
  const CartTile({
    super.key,
    required this.menu,
    required this.quantity,
    required this.valuePrice,
    required this.onLongPress,
    required this.onTap,
  });

  final MenuModel menu;
  final int quantity;
  final double valuePrice;
  final Function() onLongPress;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5),
      ),
      autofocus: true,
      dense: false,
      style: ListTileStyle.list,
      visualDensity: VisualDensity.comfortable,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 5),
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
              imageUrl: menu.imageMenu,
              filterQuality: FilterQuality.low,
              fit: BoxFit.cover,
              useOldImageOnUrlChange: true,
              fadeInCurve: Curves.easeIn,
              fadeOutCurve: Curves.easeOut,
              fadeInDuration: const Duration(milliseconds: 500),
              fadeOutDuration: const Duration(milliseconds: 750),
            ),
          ),
        ),
      ),
      title: Text(
        menu.namaMenu,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 17,
          height: 1,
        ),
      ),
      subtitle: Text(
        '${quantity}x',
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onLongPress: onLongPress,
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            radius: 15,
            splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
            child: Text(
              'Edit',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Text(
            'Rp ${NumberFormat('#,##0.000', 'id_ID').format(valuePrice).replaceAll(',', '.')}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.iconData,
    required this.title,
    required this.onTap,
    required this.isLine,
    required this.mainColor,
    required this.other,
    required this.tapped,
  });

  final IconData iconData;
  final String title;
  final bool tapped;
  final Function() onTap;
  final bool isLine;
  final bool other;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          selected: true,
          style: ListTileStyle.list,
          horizontalTitleGap: 20,
          enabled: tapped,
          leading: Icon(
            iconData,
            color: mainColor,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          title: Text(
            title,
            style: TextStyle(
              color: mainColor,
              fontSize: 17,
              fontWeight: other ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          onTap: onTap,
        ),
        Visibility(
          visible: isLine,
          child: Divider(
            thickness: 0.5,
            color: Theme.of(context).colorScheme.outline,
            indent: 55,
            height: 0,
          ),
        )
      ],
    );
  }
}
