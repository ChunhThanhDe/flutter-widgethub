import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterui/screens/home/ui/apps/leave_review/utils/colors.dart';
import 'package:flutterui/screens/home/ui/apps/leave_review/utils/sizing.dart';
import 'package:flutterui/screens/home/ui/apps/leave_review/widgets/arc.dart';
import 'package:flutterui/screens/home/ui/apps/leave_review/widgets/slider.dart';
import 'package:flutterui/shared/ui/utils/sizing.dart';

class LeaveReviewHomeScreen extends StatefulWidget {
  const LeaveReviewHomeScreen({super.key});

  @override
  State<LeaveReviewHomeScreen> createState() => _LeaveReviewHomeScreenState();
}

class _LeaveReviewHomeScreenState extends State<LeaveReviewHomeScreen> {
  double value = 1.0;
  final pageController = PageController(initialPage: 1);
  int activeIndex = 1;

  final duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        value = 2.0;
        activeIndex = 2;
      });
      pageController.animateToPage(2, duration: duration, curve: Curves.elasticOut);
    });

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: LeaveReviewAppSizing.height(context),
        width: LeaveReviewAppSizing.width(context),
        decoration: BoxDecoration(color: generateColors()),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TweenAnimationBuilder(
                  duration: Duration(milliseconds: 1000),
                  tween: Tween<double>(begin: 1, end: 0),
                  curve: Curves.easeOutBack,
                  builder: (context, doubleVal, child) {
                    return Transform.translate(
                      offset: Offset(0, doubleVal * -LeaveReviewAppSizing.height(context) / 2),
                      child: Column(
                        children: [
                          headerSection(),
                          eyesSection(),
                        ],
                      ),
                    );
                  }),
              TweenAnimationBuilder(
                duration: Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 1, end: 0),
                curve: Curves.easeOutBack,
                builder: (context, doubleVal, child) {
                  return Transform.translate(
                    offset: Offset(0, doubleVal * LeaveReviewAppSizing.height(context) / 2),
                    child: textAndSliderSection(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: ReviewColors.bgBlack.withOpacity(0.1),
                child: Icon(Icons.close),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: ReviewColors.bgBlack.withOpacity(0.1),
                child: Icon(Icons.info_outline),
              ),
            ],
          ),
          LeaveReviewAppSizing.kh20(context),
          Text(
            "How was your shopping\nexperience",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          LeaveReviewAppSizing.khSpacer(LeaveReviewAppSizing.height(context) * 0.05),
        ],
      ),
    );
  }

  Widget eyesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            eye(),
            LeaveReviewAppSizing.kw20(context),
            eye(),
          ],
        ),
        LeaveReviewAppSizing.kh20(context),
        TweenAnimationBuilder(
            key: ValueKey(activeIndex),
            tween: activeIndex == 2
                ? Tween<double>(
                    begin: 1.0,
                    end: 0.0,
                  )
                : Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ),
            duration: const Duration(milliseconds: 500),
            builder: (context, animateValue, child) {
              return Transform.rotate(
                angle: pi * animateValue,
                // angle: value < 0.5 ? pi : pi * -value,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CustomPaint(
                    painter: ArcPainter(),
                  ),
                ),
              );
            })
      ],
    );
  }

  Widget eye() {
    return Builder(builder: (context) {
      double width = 70;
      double height = 35;
      double radius = 35;
      if (value <= 0.5) {
        width = 70;
        height = 70;
      }
      if (value > 0.5 && value < 1.2) {
        width = 70;
        height = 30;
      }
      if (value >= 1.2) {
        height = 120;
        width = 120;
        radius = 60;
      }
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ReviewColors.bgBlack,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    });
  }

  Widget textAndSliderSection() {
    List<String> items = ["BAD", "NOT BAD", "GOOD"];
    return Builder(
      builder: (context) {
        return Column(
          children: [
            SizedBox(
              height: LeaveReviewAppSizing.height(context) * 0.1,
              child: PageView.builder(
                  allowImplicitScrolling: false,
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  itemCount: items.length,
                  onPageChanged: (value) {
                    setState(() {
                      activeIndex = value;
                    });
                  },
                  itemBuilder: (context, i) {
                    return Center(
                      child: Text(
                        items[i],
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: ReviewColors.bgBlack.withOpacity(0.3),
                            ),
                      ),
                    );
                  }),
            ),
            LeaveReviewAppSizing.khSpacer(LeaveReviewAppSizing.height(context) * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AppSlider(
                onChanged: (dynamic val) {
                  setState(() {
                    value = val;
                  });

                  pageController.animateTo(
                    value * LeaveReviewAppSizing.width(context),
                    duration: const Duration(milliseconds: 1800),
                    curve: Curves.elasticOut,
                  );
                },
              ),
            ),
            LeaveReviewAppSizing.khSpacer(LeaveReviewAppSizing.height(context) * 0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: LeaveReviewAppSizing.width(context),
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: ReviewColors.bgBlack.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Add Note",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton.icon(
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                      label: Text(
                        "Submit",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  )
                ],
              ),
            ),
            LeaveReviewAppSizing.khSpacer(LeaveReviewAppSizing.height(context) * 0.05),
          ],
        );
      },
    );
  }

  Color generateColors() {
    if (value <= 0.5) {
      return ReviewColors.bgRed;
    } else if (value >= 0.5 && value <= 1.2) {
      return ReviewColors.bgOrange;
    } else {
      return ReviewColors.bgGreen;
    }
  }
}