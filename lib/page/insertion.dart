import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Insertion extends StatefulWidget {

  const Insertion({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InsertionScreen();
  }

class _InsertionScreen  extends State<Insertion>{
  final GlobalKey formKey = GlobalKey<FormState>();

  TextEditingController nomTEC = TextEditingController();
  TextEditingController domaineTEC = TextEditingController();
  TextEditingController desctiptionTEC = TextEditingController();

  validationForm() async {


    if(nomTEC.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ERREUR : le champ nom de l'élection est vide",
              textAlign: TextAlign.center), shape: BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
    }
    else if(domaineTEC.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ERREUR : le champ domaine de l'élection est vide",
          textAlign: TextAlign.center), shape: BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
    }
    else if(desctiptionTEC.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ERREUR : le champ description de l'élection est vide",
          textAlign: TextAlign.center), shape: BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
    }
    else{
      final Map<String, dynamic> data = <String, dynamic>{};
      data['nom'] = nomTEC.text;
      data['domaine'] = domaineTEC.text;
      data['description'] = desctiptionTEC.text;
      nomTEC.clear();
      desctiptionTEC.clear();
      domaineTEC.clear();

      Uri url = Uri.parse("http://10.42.0.1/API/polling/newPolling.php");
      var reponse = await http.post(url, body: data);
      if(reponse.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("éléction créée",
            textAlign: TextAlign.center), shape: BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
        nomTEC.clear();
        desctiptionTEC.clear();
        domaineTEC.clear();
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("statuscode = ${reponse.statusCode} and response = ${reponse.body}",
            textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(15),
      child: Form(
        key: formKey,
        child: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15)) ),
                    floatingLabelAlignment : FloatingLabelAlignment.center ,
                    label: Text('nom de l\'éléction', textAlign: TextAlign.center),
                    labelStyle: TextStyle(),
                    alignLabelWithHint: true,
                    hintText: "saisissez le nom de l'éléction",
                    icon: Icon(Icons.info_rounded, color: Colors.blue, size: 32,)),
                keyboardType: TextInputType.text,
                controller: nomTEC,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,

              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
              TextField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                controller: domaineTEC,
                decoration: const InputDecoration(
                    floatingLabelAlignment : FloatingLabelAlignment.center ,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    alignLabelWithHint: true,
                    label: Text('domaine de l\'éléction'),
                    icon: Icon(Icons.dashboard, color: Colors.blue, size: 32,),
                    hintText: "saisissez le domaine de l'éléction" ),
                keyboardType: TextInputType.text,

              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
              TextField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                controller: desctiptionTEC,
                decoration: const InputDecoration(
                  floatingLabelAlignment : FloatingLabelAlignment.center ,
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    label: Text('description de l\'éléction'),
                    icon: Icon(Icons.description, color: Colors.blue, size: 32,),
                    hintText: "saisissez le decription de l'éléction",
                    isDense: true,

                ),
                keyboardType: TextInputType.text,

              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
                  padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                ),
                onPressed: validationForm,
                child: const Text("créer l'éléction"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

