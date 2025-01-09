// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String idTenant;
  String idOrder;
  Timestamp timeOrder;
  String payMethod;
  double subTotal;
  double hargaTotal;
  List<Menus> menus;

  OrderModel({
    required this.idTenant,
    required this.idOrder,
    required this.timeOrder,
    required this.payMethod,
    required this.subTotal,
    required this.hargaTotal,
    required this.menus,
  });

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      idTenant: data['tenant_id'],
      idOrder: data['order_id'],
      timeOrder: data['order_time'],
      payMethod: data['pay_method'],
      subTotal: data['sub_total'],
      hargaTotal: data['harga_total'],
      menus: (data['menus'] as List<dynamic>)
          .map(
            (e) => Menus.fromDocument(
              e as Map<String, dynamic>,
              data['order_time'],
              data['pay_method'],
            ),
          )
          .toList(),
    );
  }
}

class Menus {
  String idMenus;
  String imageMenus;
  String namaMenus;
  double hargaMenus;
  int qtyMenus;
  double valueTotal;
  Timestamp timeMenus;
  String payMethod;

  Menus({
    required this.idMenus,
    required this.imageMenus,
    required this.namaMenus,
    required this.hargaMenus,
    required this.qtyMenus,
    required this.valueTotal,
    required this.timeMenus,
    required this.payMethod,
  });

  factory Menus.fromDocument(
    Map<String, dynamic> doc,
    Timestamp timeMenus,
    String payMethod,
  ) {
    return Menus(
      idMenus: doc['menu_id'],
      imageMenus: doc['image_menu'],
      namaMenus: doc['nama_menu'],
      hargaMenus: doc['harga_menu'],
      qtyMenus: doc['qty_menu'],
      valueTotal: doc['value_total'],
      timeMenus: timeMenus,
      payMethod: payMethod,
    );
  }
}
