
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AboutUsScreen.dart';
import '../main.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category? category;
  final int index;

  const CategoryCard({Key? key, this.category, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (category == null) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
            break;

          case 1:
            _launchURL1();
            break;


          case 2:
            _launchURL2();
            break;

          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUsScreen()),
            );
            break;
        }
      },
      child: Material(
        elevation: 8.0, // Set the elevation value as needed
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3, // Adjust the percentage as needed
                height: MediaQuery.of(context).size.height * 0.15, // Adjust the percentage as needed
                child: Lottie.asset(
                  category!.thumbnail,
                  fit: BoxFit.contain, // Ensure the asset fits within the specified dimensions
                ),
              ),
              SizedBox(height: 8),
              Text(
                category!.name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL1() async {
    const url = 'https://whatsapp.com/channel/0029VaCA67Z8KMqiUkP3ek3E';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchURL2() async {
    const url = 'https://www.tiwariacademy.com/ncert-solutions/class-2';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
