import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the AdMob package

import '../ad_helper.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import '../widgets/circle_button.dart';
import '../widgets/search_field.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({Key? key}) : super(key: key);

  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(),
            Flexible(
              child: Body(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String greeting;

  @override
  void initState() {
    super.initState();
    updateGreeting();
  }

  void updateGreeting() {
    setState(() {
      greeting = getGreeting();
    });

    // Update the greeting every minute
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted before updating
        setState(() {
          greeting = getGreeting();
        });
      }
    });
  }

  String getGreeting() {
    var currentTime = DateTime.now().hour;

    if (currentTime >= 4 && currentTime < 12) {
      return 'Good Morning';
    } else if (currentTime >= 12 && currentTime < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 36, left: 14),
      height: 270, // Adjusted height to 250
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.lightBlueAccent,
            Colors.blueAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '${getGreeting()}, \n [Your Class] Students',
                      style: GoogleFonts.openSans(
                        textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 0, right: 12),
                    child: Row(
                      children: [
                        CircleButton(
                          icon: Icons.star_outline_outlined,
                          onPressed: () async {
                            const appStoreUrl =
                                'https://play.google.com/store/apps/details?id=xxxxxxx';

                            // Check if the URL can be launched
                            if (await canLaunch(appStoreUrl)) {
                              await launch(appStoreUrl);
                            } else {
                              print('Could not launch $appStoreUrl');
                            }
                          },
                        ),
                        const SizedBox(width: 20),
                        CircleButton(
                          icon: Icons.share_rounded,
                          onPressed: () {
                            // Share the Play Store link with a message
                            final playStoreUrl =
                                'https://play.google.com/store/apps/details?id=xxxxxxx';
                            Share.share(
                              'Download My App \n $playStoreUrl',
                              subject: 'Download My App',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppUsageMeter(// Example: Pass the actual app usage time duration here
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Category> filteredCategories = List.from(categoryList);

  void handleSearch(String query) {
    // Implement your search logic here
    setState(() {
      filteredCategories = categoryList
          .where((category) =>
          category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 15, left: 20, right: 20, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Explore Categories",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 24,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return CategoryCard(
                  category: filteredCategories[index],
                  index: index,
                );
              },
              childCount: filteredCategories.length,
            ),
          ),
        ),
      ],
    );
  }
}
