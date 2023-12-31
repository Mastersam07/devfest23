import 'package:devfest23/features/onboarding/pages/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/router/navigator.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/theme_data.dart';
import '../../../core/widgets/buttons.dart';
import '../widgets/title_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants.dart';
import '../../../core/enums/tab_item.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(
                '${RoutePaths.onboarding}/${RoutePaths.auth}?result=${AuthState.success.name}',
              );
            });
          }
          return Scaffold(
            backgroundColor: DevFestTheme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: DevFestTheme.of(context).backgroundColor,
              toolbarHeight: 0,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: Constants.horizontalMargin)
                        .w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleTile(
                          emoji: '🤭',
                          title: 'Welcome Back!',
                          backgroundColor: DevfestColors.greenSecondary,
                        ),
                        Text(
                          'We are back and ready to awe',
                          style: DevFestTheme.of(context)
                              .textTheme
                              ?.headline02
                              ?.copyWith(
                                color:
                                    DevFestTheme.of(context).onBackgroundColor,
                                height: 1.2,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50).w,
                          child: Consumer(
                            builder: (context, ref, child) {
                              return Text(
                                'We have great speakers and amazing sessions in place for this year’s DevFest! 🥳',
                                style: DevFestTheme.of(context)
                                    .textTheme
                                    ?.body02
                                    ?.copyWith(
                                        color: ref.watch(isDarkProvider)
                                            ? DevfestColors.grey70
                                            : DevfestColors.grey30),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Categories(),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.horizontalMargin),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DevfestFilledButton(
                          title: const Text('Login to RSVP'),
                          onPressed: () {
                            context.go(
                                '${RoutePaths.onboarding}/${RoutePaths.auth}');
                          },
                        ),
                        13.verticalSpace,
                        DevfestOutlinedButton(
                          title: const Text('Continue Without Login'),
                          onPressed: () {
                            context
                                .pushNamedAndClear('/app/${TabItem.home.name}');
                          },
                        ),
                      ],
                    ),
                  ),
                  26.verticalSpace,
                ],
              ),
            ),
          );
        });
  }
}

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const InfiniteScrollCategoriesWidget(
          children: [
            CategoryChip(
              chipColor: Color(0xffeee4dd),
              emoji: '🎨',
              title: 'Design',
            ),
            CategoryChip(
              chipColor: Color(0xffffd4cc),
              emoji: '📊',
              title: 'Blockchain',
            ),
            CategoryChip(
              chipColor: Color(0xffffd4cc),
              emoji: '🖼️',
              title: 'Frontend',
            ),
          ],
        ),
        8.verticalSpace,
        const InfiniteScrollCategoriesWidget(
          children: [
            CategoryChip(
              chipColor: Color(0xffeeebdd),
              emoji: '🪛',
              title: 'Backend',
            ),
            CategoryChip(
              chipColor: Color(0xffccf4ff),
              emoji: '☯️',
              title: 'Mental Health',
            ),
            CategoryChip(
              chipColor: Color(0xffffe2cc),
              emoji: '⭐',
              title: 'Leader',
            ),
          ],
        ),
        8.verticalSpace,
        const InfiniteScrollCategoriesWidget(
          children: [
            CategoryChip(
              chipColor: Color(0xffe6ddee),
              emoji: '💼',
              title: 'Product Management',
            ),
            CategoryChip(
              chipColor: Color(0xffffebcc),
              emoji: '🛡️',
              title: 'Cybersecurity',
            ),
          ],
        ),
        8.verticalSpace,
        const InfiniteScrollCategoriesWidget(
          children: [
            CategoryChip(
              chipColor: Color(0xfffdccff),
              emoji: '♠️',
              title: 'Networking',
            ),
            CategoryChip(
              chipColor: Color(0xffccf8ff),
              emoji: '✨',
              title: 'DevOps',
            ),
            CategoryChip(
              chipColor: Color(0xffefefdc),
              emoji: '📉',
              title: 'Big Data',
            ),
          ],
        ),
      ],
    );
  }
}

class InfiniteScrollCategoriesWidget extends StatefulWidget {
  const InfiniteScrollCategoriesWidget({super.key, required this.children});

  final List<Widget> children;

  @override
  State<InfiniteScrollCategoriesWidget> createState() =>
      _InfiniteScrollCategoriesWidgetState();
}

class _InfiniteScrollCategoriesWidgetState
    extends State<InfiniteScrollCategoriesWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  final _listController = ScrollController(initialScrollOffset: 50);

  @override
  void initState() {
    super.initState();

    // Duration is set to keep the framework happy and doesn't impact scroll speed
    _animController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(_animateList)
          ..repeat();
  }

  void _animateList() {
    if (_listController.hasClients) {
      _listController.animateTo(
        _listController.offset + 1.0,
        duration: const Duration(milliseconds: 20),
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.w,
      child: ListView.builder(
        controller: _listController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final page = index % widget.children.length;

          return Padding(
            padding: const EdgeInsets.only(right: 8).w,
            child: widget.children[page],
          );
        },
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.chipColor,
    required this.emoji,
    required this.title,
  });

  final Color chipColor;
  final String emoji;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).w,
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: const BorderRadius.all(Radius.circular(48)),
      ),
      child: Text.rich(
        TextSpan(
          text: emoji,
          style: DevFestTheme.of(context)
              .textTheme
              ?.body01
              ?.copyWith(color: DevfestColors.grey20),
          children: [
            WidgetSpan(child: SizedBox(width: 8.w)),
            TextSpan(text: title),
          ],
        ),
      ),
    );
  }
}
