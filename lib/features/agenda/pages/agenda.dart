import 'package:devfest23/core/router/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants.dart';
import '../../../core/enums/devfest_day.dart';
import '../../../core/icons.dart';
import '../../../core/images.dart';
import '../../../core/providers/current_tab_provider.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/routes.dart';
import '../../../core/themes/themes.dart';
import '../../../core/widgets/schedule_tab_bar.dart';
import '../../home/pages/home.dart';
import '../../home/widgets/schedule_tile.dart';
import '../../home/widgets/speakers_chip.dart';
import '../../home/widgets/sponsors_chip.dart';

class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key, required this.initialDay});

  final DevfestDay initialDay;

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends ConsumerState<AgendaPage> {
  late DevfestDay day;

  @override
  void initState() {
    super.initState();

    day = widget.initialDay;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, isScrolledUnder) {
          return [
            SliverAppBar(
              backgroundColor: DevFestTheme.of(context).backgroundColor,
              elevation: 0,
              scrolledUnderElevation: 0,
              leadingWidth: 100,
              leading: Row(
                children: [
                  Constants.horizontalMargin.horizontalSpace,
                  SvgPicture.asset(
                    AppIcons.devfestLogo,
                    height: 16.h,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: Constants.horizontalMargin,
                right: Constants.horizontalMargin,
              ).w,
              sliver: SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Hey Bruce',
                        style: DevFestTheme.of(context).textTheme?.title01,
                        children: [
                          WidgetSpan(child: 4.horizontalSpace),
                          const TextSpan(text: '🤭')
                        ],
                      ),
                    ),
                    Constants.smallVerticalGutter.verticalSpace,
                    Text(
                      'Welcome to Devfest Lagos 2023 🥳',
                      style:
                          DevFestTheme.of(context).textTheme?.body02?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? DevfestColors.grey80
                                    : DevfestColors.grey40,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                    horizontal: Constants.horizontalMargin)
                .w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constants.verticalGutter.verticalSpace,
                Text(
                  'SCHEDULE',
                  style: DevFestTheme.of(context).textTheme?.body04?.copyWith(
                        color: DevfestColors.grey30,
                      ),
                ),
                Constants.verticalGutter.verticalSpace,
                ScheduleTabBar(
                  index: day.index,
                  onTap: (tab) {
                    setState(() {
                      day = DevfestDay.values.elementAt(tab);
                    });
                  },
                ),
                [
                  AnimatedScale(
                    key: const Key('AnimatedScaleDay1'),
                    scale: day.index == 0 ? 1.0 : 0.98,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 250),
                    child: AnimatedOpacity(
                      key: const Key('AnimatedOpacityDay1'),
                      opacity: day.index == 0 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.decelerate,
                      child: ListView.separated(
                        shrinkWrap: true,
                        key: const PageStorageKey<String>('Day1'),
                        padding:
                            const EdgeInsets.only(top: Constants.verticalGutter)
                                .w,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ScheduleTile(
                            isGeneral: index == 0,
                            onTap: () {
                              context.go("${RoutePaths.session}/$index");
                            },
                          );
                        },
                        separatorBuilder: (_, __) => 14.verticalSpace,
                        itemCount: 4,
                      ),
                    ),
                  ),
                  AnimatedScale(
                    key: const Key('AnimatedScaleDay2'),
                    scale: day.index == 1 ? 1.0 : 0.98,
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 100),
                    child: AnimatedOpacity(
                      key: const Key('AnimatedOpacityDay2'),
                      opacity: day.index == 1 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.decelerate,
                      child: ListView.separated(
                        shrinkWrap: true,
                        key: const PageStorageKey<String>('Day2'),
                        padding:
                            const EdgeInsets.only(top: Constants.verticalGutter)
                                .w,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ScheduleTile(
                            isGeneral: index == 0,
                            onTap: () {
                              context.go("${RoutePaths.session}/$index");
                            },
                          );
                        },
                        separatorBuilder: (_, __) => 14.verticalSpace,
                        itemCount: 4,
                      ),
                    ),
                  ),
                ].elementAt(day.index),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ref
                          .watch(appCurrentTab.notifier)
                          .update((state) => state = 1);
                      pageController.animateTo(1);
                    },
                    label: const Icon(
                      Icons.arrow_forward,
                      color: DevfestColors.blue,
                    ),
                    icon: const Text(
                      'View Full Agenda',
                      style: TextStyle(color: DevfestColors.blue),
                    ),
                  ),
                ),
                Text(
                  'SPONSORS',
                  style: DevFestTheme.of(context).textTheme?.body04,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: 16).h,
                  child: Row(
                    children: [
                      ...[
                        AppImages.googleLogo,
                        AppImages.spotifyLogo,
                        AppImages.uberLogo,
                        AppImages.lyftLogo
                      ]
                          .map(
                            (sponsorImage) => SponsorsChip(image: sponsorImage),
                          )
                          .toList()
                    ],
                  ),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    label: const Icon(
                      Icons.arrow_forward,
                      color: DevfestColors.blue,
                    ),
                    icon: const Text(
                      'View All Sponsors',
                      style: TextStyle(color: DevfestColors.blue),
                    ),
                  ),
                ),
                Text(
                  'SPEAKERS',
                  style: DevFestTheme.of(context).textTheme?.body04,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16).h,
                  itemBuilder: (context, index) {
                    var color = [
                      const Color(0xfff6eeee),
                      DevfestColors.greenSecondary,
                      DevfestColors.blueSecondary,
                      const Color(0xffffafff)
                    ].elementAt(index > 3 ? 3 : index);
                    return SpeakersChip(
                      moodColor: color,
                      name: 'Daniele Buffa',
                      shortInfo: 'CEO, Design Lead, O2 Labs',
                      onTap: () {
                        context.go('${RoutePaths.speakers}/$index');
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Constants.verticalGutter.verticalSpace,
                  itemCount: 4,
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ref
                          .watch(appCurrentTab.notifier)
                          .update((state) => state = 2);
                      pageController.animateTo(2);
                    },
                    label: const Icon(
                      Icons.arrow_forward,
                      color: DevfestColors.blue,
                    ),
                    icon: const Text(
                      'View All Speakers',
                      style: TextStyle(color: DevfestColors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}