
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageScreen();
}

class _HomePageScreen extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
        items:  [1, 2, 3, 4, 5].map((i) {
          return Builder(
              builder: (BuildContext context) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    //decoration: const BoxDecoration(color: Colors.amber),
                    child: Container(decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: AssetImage('assets/images/$i.jpg')))));},);}).toList(),
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            pauseAutoPlayOnTouch: false,
            pauseAutoPlayOnManualNavigate: false,
            pauseAutoPlayInFiniteScroll: false,
            disableCenter: false,
            showIndicator: false,)
      );
  }
}
