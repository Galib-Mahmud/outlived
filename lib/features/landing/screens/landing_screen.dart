import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/custom_bottom_nav_bar.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Landing Screen'),
        ),
      ),
      bottomNavigationBar: CustomBottomNavStack()
    );
  }
}
