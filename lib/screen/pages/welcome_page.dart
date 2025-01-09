// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widget/button.dart';
import 'auth/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final pageController = PageController();

  final nextFocusNode = FocusNode();
  final welcomeFocusNode = FocusNode();

  bool lastPage = false;

  List<Widget> pages = [
    const PageContent(
      title: 'Select Multiple Menu Orders.',
      image: 'assets/images/UI-UX team-bro.svg',
      subTitle:
          'Enjoy the convenience of managing orders for several menus at once easily in one transaction.',
      height: 200,
    ),
    const PageContent(
      title: 'Print Receipts and Manage Orders Easily.',
      image: 'assets/images/Receipt-bro.svg',
      subTitle:
          'Each order will be printed immediately, helping Tenants record transactions easily.',
      height: 225,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                alignment: const Alignment(0, 0.5),
                child: Image.asset(
                  'assets/images/QuickBite.png',
                  height: 30,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: PageView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    lastPage = (index == 1);
                  });
                },
                children: pages,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmoothPageIndicator(
                      controller: pageController,
                      count: pages.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: Theme.of(context).primaryColor,
                        dotColor: Colors.grey.shade300,
                      ),
                    ),
                    const Gap(15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: !lastPage,
                          child: ButtonCustom(
                            onPressed: () {
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInExpo,
                              );
                            },
                            addBorder: true,
                            backgroundColor: Colors.grey.shade50,
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Gap(15),
                        ButtonCustom(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          addBorder: false,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Text(
                            'Start Explore',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.title,
    required this.image,
    required this.subTitle,
    required this.height,
  });

  final String title;
  final String image;
  final String subTitle;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
          ),
          SvgPicture.asset(
            image,
            height: height,
            fit: BoxFit.cover,
          ),
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
