import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  String idMenu;
  String imageMenu;
  String namaMenu;
  String hargaMenu;
  String kategoriMenu;
  int stokMenu;
  Timestamp timestamp;

  MenuModel({
    required this.idMenu,
    required this.imageMenu,
    required this.namaMenu,
    required this.hargaMenu,
    required this.kategoriMenu,
    required this.stokMenu,
    required this.timestamp,
  });

  factory MenuModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuModel(
      idMenu: doc.id,
      imageMenu: data['image_menu'],
      namaMenu: data['nama_menu'],
      hargaMenu: data['harga_menu'],
      kategoriMenu: data['kategori_menu'],
      stokMenu: data['stock_menu'],
      timestamp: data['timestamp'],
    );
  }
}

