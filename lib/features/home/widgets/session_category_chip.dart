import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../core/constants.dart';
import '../../../core/providers/providers.dart';
import '../../../core/themes/themes.dart';
import '../../../core/widgets/widgets.dart';

@widgetbook.UseCase(
    name: 'Session category chip',
    type: DevfestChips,
    designLink:
        'https://www.figma.com/file/CCnX5Sh86ILqRn7ng6Shlr/DevFest-Jordan-Year---Mobile-App?node-id=1591%3A1213&mode=dev')
Widget devfestSessionCatChip(BuildContext context) {
  String selectedTab = 'All Speakers';
  return StatefulBuilder(builder: (context, setState) {
    return Material(
      color: DevFestTheme.of(context).backgroundColor,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.horizontalMargin),
          child: Center(
            child: Row(
              children: [
                SessionCategoryChip(
                  selectedTab: selectedTab,
                  tab: 'All Speakers',
                  onTap: () {
                    setState(() {
                      selectedTab = 'All Speakers';
                    });
                  },
                ),
                const SizedBox(width: 8),
                SessionCategoryChip(
                  selectedTab: selectedTab,
                  tab: 'Mobile Development',
                  onTap: () {
                    setState(() {
                      selectedTab = 'Mobile Development';
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}

class SessionCategoryChip extends ConsumerWidget {
  const SessionCategoryChip({
    super.key,
    required this.selectedTab,
    required this.tab,
    this.onTap,
  });

  final String selectedTab;
  final String tab;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, ref) {
    final tileColor = () {
      if (tab == selectedTab) {
        return ref.watch(isDarkProvider)
            ? DevfestColors.background
            : const Color(0xFF0F0E0E);
      }

      return ref.watch(isDarkProvider)
          ? DevfestColors.darkbackground
          : DevfestColors.background;
    }();

    final contentColor = () {
      if (tab == selectedTab) {
        return ref.watch(isDarkProvider)
            ? DevfestColors.grey0
            : DevfestColors.grey90;
      }

      return DevfestColors.grey60;
    }();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 38.h,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12).w,
        decoration: ShapeDecoration(
          color: tileColor,
          shape: RoundedRectangleBorder(
            side: tab == selectedTab
                ? BorderSide.none
                : const BorderSide(width: 0.50, color: DevfestColors.grey60),
            borderRadius: BorderRadius.circular(48),
          ),
        ),
        child: Center(
          child: Text(
            tab,
            style: DevFestTheme.of(context)
                .textTheme
                ?.body03
                ?.copyWith(color: contentColor),
          ),
        ),
      ),
    );
  }
}

class SessionCategoryShimmerChip extends ConsumerWidget {
  const SessionCategoryShimmerChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileColor = () {
      return ref.watch(isDarkProvider)
          ? DevfestColors.darkbackground
          : DevfestColors.background;
    }();

    final contentColor = () {
      return DevfestColors.grey60;
    }();
    return AnimatedContainer(
      height: 38.h,
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12).w,
      decoration: ShapeDecoration(
        color: tileColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: DevfestColors.grey60),
          borderRadius: BorderRadius.circular(48),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: contentColor,
        highlightColor: tileColor,
        period: Constants.kAnimationDur,
        child: Center(
          child: Container(
            height: 16,
            width: Random().nextInt(40) + 60, // random width from 60 to 80
            decoration: BoxDecoration(
              color: contentColor,
              borderRadius: const BorderRadius.all(
                  Radius.circular(Constants.smallVerticalGutter)),
            ),
          ),
        ),
      ),
    );
  }
}
