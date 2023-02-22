
import 'dart:convert';
import 'dart:typed_data';

class Personne{
  int? id;
  String? anarana;
  String? fanampiny;
  String? sexe;
  String? daty;
  String? adiresy;
  String? asa;
  String? phone;
  //String image = "";

  Personne(this.id, this.anarana, this.fanampiny, this.sexe, this.adiresy, this.phone, this.asa, this.daty,
      //this.image
      );

  Personne.fromJson(dynamic json){
    id = json['id'];
    anarana = json['anarana'];
    fanampiny = json['fanampiny'];
    sexe = json['sexe'];
    daty = json['daty'];
    adiresy = json['adiresy'];
    phone = json['phone'];
    asa = json['asa'];
    //image = json['image'];
  }
}
