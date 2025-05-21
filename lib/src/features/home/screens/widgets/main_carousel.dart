import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/constants/images.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainCarousel extends StatefulWidget {
  const MainCarousel({super.key});

  @override
  State<MainCarousel> createState() => _MainCarouselState();
}

class _MainCarouselState extends State<MainCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        // height: 200,
        // autoPlay: true,
        // autoPlayInterval: const Duration(seconds: 5),
        // autoPlayAnimationDuration: const Duration(milliseconds: 1300),
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: true,
        viewportFraction: .9,
        initialPage: 0,
        aspectRatio: 16/7,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
        // enableInfiniteScroll: true,
      ),
      items: carouselImages.map((item) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              item,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 340,
            ),
          ),
        )
      )).toList(),
    );
  }
}
