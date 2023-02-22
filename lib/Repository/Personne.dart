
class Personne{
  int? id;
  String? anarana;
  String? fanampiny;
  String? sexe;
  String? daty;
  String? adiresy;
  String? asa;
  String? phone;
  String image = "";

  Personne(this.id, this.anarana, this.fanampiny, this.sexe, this.adiresy, this.phone, this.asa, this.daty,
      this.image
      );

  Personne.fromJson(Map<String, dynamic> json){
    id = json['id'];
    anarana = json['anarana'];
    fanampiny = json['fanampiny'];
    sexe = json['sexe'];
    List<String> dati = json['daty'].split("-");
    DateTime actu = DateTime.now();
    int x1 = actu.year;
    int x2 = int.parse(dati[2]);
    x2 = x1 - x2;
    daty = "$x2 ans";
    adiresy = json['adiresy'];
    phone = json['phone'];
    asa = json['asa'];
    image = json['image'];
  }

  static final List<String> _base64Char = [
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
  "+", "/",
  ];

  static List<int> base64Decoder(String str) {

  str = str.replaceAll("\n", "");
  List<int> list = [];
  if (str.length % 4 == 0) {

  for (int i = 0; i < str.length; i += 4) {
  String char1 = str.substring(i, i + 1);
  String char2 = str.substring(i + 1, i + 2);
  String char3 = str.substring(i + 2, i + 3);
  String char4 = str.substring(i + 3, i + 4);


  int code1 = _base64Char.indexOf(char1);
  int code2 = _base64Char.indexOf(char2);
  int code3 = 0;
  if ("=" != char3) {
  code3 = _base64Char.indexOf(char3);
  }
  int code4 = 0;
  if ("=" != char4) {
  code4 = _base64Char.indexOf(char4);
  }


  int decode1 = ((code1 & 0x3F) << 2) + ((code2 & 0x30) >> 4);

  int decode2 = 0;
  if ("=" != char3) {
  decode2 = ((code2 & 0x0F) << 4) + ((code3 & 0x3C) >> 2);
  }

  int decode3 = 0;
  if ("=" != char4) {
  decode3 = ((code3 & 0x03) << 6) + code4;
  }

  list.add(decode1);
  if ("=" != char3) {
  list.add(decode2);
  }
  if ("=" != char4) {
  list.add(decode3);
  }
  }
  }
  return list;
  }

  static String base64Encoder(List<int> list) {
    StringBuffer sb = StringBuffer();
    int remainder = list.length % 3;
    int size = list.length - remainder;

    for (int i = 0; i < size; i += 3) {
    int code1 = list[i];
    int code2 = list[i + 1];
    int code3 = list[i + 2];

    int encode1 = (code1 >> 2) & 0x3F;

    int encode2 = ((code1 & 0x03) << 4) + ((code2 >> 4) & 0x0F);

    int encode3 = ((code2 & 0x0F) << 2) + ((code3 >> 6) & 0x03);

    int encode4 = code3 & 0x3F;

    String char1 = _base64Char[encode1];
    String char2 = _base64Char[encode2];
    String char3 = _base64Char[encode3];
    String char4 = _base64Char[encode4];

    sb.write(char1);
    sb.write(char2);
    sb.write(char3);
    sb.write(char4);
    }

    if (remainder != 0) {

    int code1 = list[size];
    int code2 = 0;
    if (remainder == 2) {
    code2 = list[size + 1];
    }

    int encode1 = (code1 >> 2) & 0x3F;
    int encode2 = ((code1 & 0x03) << 4) + ((code2 >> 4) & 0x0F);
    String char1 = _base64Char[encode1];
    String char2 = _base64Char[encode2];

    int encode3;
    String char3 = "=";
    if (remainder == 2) {
    encode3 = (code2 & 0x0F) << 2;
    char3 = _base64Char[encode3];
    }

    String char4 = "=";

    sb.write(char1);
    sb.write(char2);
    sb.write(char3);
    sb.write(char4);
    }

    return sb.toString();
  }

}
