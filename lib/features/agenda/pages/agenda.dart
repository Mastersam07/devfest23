import 'package:devfest23/core/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/data/data.dart';
import '../../../core/router/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants.dart';
import '../../../core/enums/devfest_day.dart';
import '../../../core/icons.dart';
import '../../../core/providers/current_tab_provider.dart';
import '../../../core/providers/providers.dart';
import '../../../core/router/routes.dart';
import '../../../core/themes/themes.dart';
import '../../../core/ui_state_model/ui_state_model.dart';
import '../../../core/widgets/schedule_tab_bar.dart';
import '../../../core/widgets/widgets.dart';
import '../../home/pages/home.dart';
import '../../home/widgets/schedule_tile.dart';
import '../../home/widgets/speakers_chip.dart';
import '../../schedule/application/controllers.dart';
import '../../schedule/application/sessions/view_model.dart';
import '../../speakers/application/application.dart';

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

  static const itemCount = 4;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    return SafeArea(
      child: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                    StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        return Text.rich(
                          TextSpan(
                            text:
                                'Hey ${snapshot.data?.displayName?.split(' ').first ?? 'friend'}',
                            style: DevFestTheme.of(context).textTheme?.title01,
                            children: [
                              WidgetSpan(child: 4.horizontalSpace),
                              const TextSpan(text: '🤭')
                            ],
                          ),
                        );
                      },
                    ),
                    Constants.smallVerticalGutter.verticalSpace,
                    Text(
                      'Welcome to DevFest Lagos 2023 🥳',
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
                        color: isDark
                            ? DevfestColors.grey100
                            : DevfestColors.grey30,
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
                  switch (ref.watch(sessionsViewModelProvider
                      .select((value) => value.viewState))) {
                    ViewState.loading => Padding(
                        padding: const EdgeInsets.symmetric(
                                vertical: Constants.verticalGutter)
                            .h,
                        child: const FetchingSessions(),
                      ),
                    ViewState.success => ProviderScope(
                        overrides: [
                          _schedulesProvider.overrideWithValue(
                            ref
                                .watch(day1SessionsProvider)
                                .safeSublist(itemCount),
                          ),
                        ],
                        child: const _AgendaSchedules(),
                      ),
                    _ => const SizedBox.shrink(),
                  },
                  switch (ref.watch(sessionsViewModelProvider
                      .select((value) => value.viewState))) {
                    ViewState.loading => Padding(
                        padding: const EdgeInsets.symmetric(
                                vertical: Constants.verticalGutter)
                            .h,
                        child: const FetchingSessions(),
                      ),
                    ViewState.success => ProviderScope(
                        overrides: [
                          _schedulesProvider.overrideWithValue(
                            ref
                                .watch(day2SessionsProvider)
                                .safeSublist(itemCount),
                          ),
                        ],
                        child: const _AgendaSchedules(),
                      ),
                    _ => const SizedBox.shrink(),
                  },
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
                  'SPEAKERS',
                  style: DevFestTheme.of(context).textTheme?.body04,
                ),
                [
                  switch (ref.watch(speakersViewModelProvider
                      .select((value) => value.viewState))) {
                    ViewState.loading => const FetchingSpeakers(),
                    ViewState.success => ProviderScope(
                        overrides: [
                          _speakersProvider.overrideWithValue(
                              ref.watch(day1AllSpeakersProvider)),
                        ],
                        child: const _Speakers(),
                      ),
                    _ => const SizedBox.shrink(),
                  },
                  switch (ref.watch(speakersViewModelProvider
                      .select((value) => value.viewState))) {
                    ViewState.loading => const FetchingSpeakers(),
                    ViewState.success => ProviderScope(
                        overrides: [
                          _speakersProvider.overrideWithValue(
                              ref.watch(day2AllSpeakersProvider)),
                        ],
                        child: const _Speakers(),
                      ),
                    _ => const SizedBox.shrink(),
                  },
                ].elementAt(day.index),
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

final _schedulesProvider = Provider.autoDispose<List<Session>>((ref) {
  throw UnimplementedError();
});

class _AgendaSchedules extends ConsumerWidget {
  const _AgendaSchedules();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(_schedulesProvider);
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: Constants.verticalGutter).w,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return ScheduleTile(
          isGeneral: session.sessionId.isEmpty,
          title: session.title,
          speaker: session.owner,
          time: session.scheduledDuration,
          venue: session.hall,
          category: session.category,
          speakerImage: session.speakerImage,
          hasRsvped: session.hasRsvped,
          onTap: () {
            context.go(RoutePaths.session, extra: session);
          },
        );
      },
      separatorBuilder: (_, __) => 14.verticalSpace,
      itemCount: sessions.length,
    );
  }
}

final _speakersProvider = Provider.autoDispose<List<Speaker>>((ref) {
  throw UnimplementedError();
});

class _Speakers extends ConsumerWidget {
  const _Speakers();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speakers = ref.watch(_speakersProvider);
    return ListView.separated(
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

        final speaker = speakers[index];
        return SpeakersChip(
          moodColor: color,
          name: speaker.name,
          shortInfo: speaker.role,
          avatarImageUrl: speaker.avatar,
          onTap: () {
            context.go(RoutePaths.speakers, extra: speaker);
          },
        );
      },
      separatorBuilder: (context, index) =>
          Constants.verticalGutter.verticalSpace,
      itemCount: speakers.length,
    );
  }
}
