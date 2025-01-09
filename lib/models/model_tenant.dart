// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_menu.dart';
import 'model_order.dart';

class TenantModel {
  String idTenant;
  String imageTenant;
  String nameTenant;
  String emailTenant;
  String phoneNumberTenant;
  Timestamp timestamp;
  List<MenuModel> menu;
  List<OrderModel> order;

  TenantModel({
    required this.idTenant,
    required this.imageTenant,
    required this.nameTenant,
    required this.emailTenant,
    required this.phoneNumberTenant,
    required this.timestamp,
    required this.menu,
    required this.order,
  });

  factory TenantModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return TenantModel(
      idTenant: snapshot.id,
      imageTenant: data['image_tenant'],
      nameTenant: data['nama_tenant'],
      emailTenant: data['email_tenant'],
      phoneNumberTenant: data['phoneNumber_tenant'],
      timestamp: data['timestamp'],
      menu: [],
      order: [],
    );
  }

  Future<List<MenuModel>> fetchMenu() async {
    List<MenuModel> menus = [];
    final menuSnapshot = await FirebaseFirestore.instance
        .collection('tenants')
        .doc(idTenant)
        .collection('menu')
        .get();

    menu = menuSnapshot.docs.map((doc) => MenuModel.fromDocument(doc)).toList();

    return menus;
  }

  Future<List<OrderModel>> fetchOrder() async {
    List<OrderModel> orders = [];

    final orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('id_tenant', isEqualTo: idTenant)
        .get();

    order = orderSnapshot.docs.map((doc) => OrderModel.fromDocument(doc)).toList();

    return orders;
  }
}
