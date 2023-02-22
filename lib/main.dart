
import 'package:e_vote_management/page/home.dart';
import 'package:e_vote_management/page/insertion.dart';
import 'package:e_vote_management/page/liste.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainScreen();
}

class _MainScreen extends State<MainPage>{
  int _currentIndex = 0;
  int _currentPage = 0;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
      _currentPage = _currentIndex + 1;
    });
  }
  initCurrentIndex(){
    setState(() {
      _currentIndex = 0;
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      [
        AppBar(
          centerTitle: true,
          title: const Text("GESTION DES ÉLECTIONS"),
        ),
        AppBar(
          centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.home_sharp), onPressed:() => initCurrentIndex(), iconSize: 40,),
          title: const Text("Création d'une éléction"),
        ),
        AppBar(
          centerTitle: true, 
          leading: IconButton(icon: const Icon(Icons.home_sharp), onPressed:() => initCurrentIndex(), iconSize: 40),
          title: const Text("Liste des éléctions"),)
      ][_currentPage],
        bottomNavigationBar:
        BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blue,
          currentIndex: _currentIndex,
          onTap : (int item) {setCurrentIndex(item);},
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Créer une élection",),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Liste des élections")
          ],
        ),
        body: [
            const HomePage(),
            const Insertion(),
            const Liste()
          ][_currentPage],
      );
  }
}


