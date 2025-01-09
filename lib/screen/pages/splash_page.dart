import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      extendBody: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: SizedBox(
              height: 175,
              width: 175,
              child: Image.asset(
                'assets/images/logo.png',
                filterQuality: FilterQuality.low,
                alignment: Alignment.center,
                fit: BoxFit.contain,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            child: Column(
              children: [
                const Text(
                  'QuickBite',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(7.5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 0.75,
                    ),
                  ),
                  child: Text(
                    'v ${_packageInfo.version}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
