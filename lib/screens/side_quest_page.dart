import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/game_repository.dart';
import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/day_pager.dart';
import '../widgets/quest_card.dart';
import '../widgets/shell_controls.dart';

/// Landing screen: today's rolled quests + reroll. Wired to
/// [rolledQuestsForSelectedDateProvider] and [GameRepository].
class SideQuestPage extends ConsumerStatefulWidget {
  const SideQuestPage({super.key});
  @override
  ConsumerState<SideQuestPage> createState() => _SideQuestPageState();
}

class _SideQuestPageState extends ConsumerState<SideQuestPage> {
  @override
  void initState() {
    super.initState();
    // Lazy daily roll on first view (Data Models §4.5).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(isTodayProvider)) {
        ref.read(gameRepositoryProvider).ensureRollForToday();
      }
    });
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), duration: AppMotion.fill * 3));

  Future<void> _onMark(String questId) async {
    final outcome =
        await ref.read(gameRepositoryProvider).markQuestComplete(questId);
    if (outcome == ActionOutcome.leveledUpAwaitingPlacement) {
      _snack('⭐ Level up! Head to the biome to plant your tree.');
    }
  }

  Future<void> _onReroll() async {
    final r = await ref.read(gameRepositoryProvider).reroll();
    _snack(switch (r) {
      RerollOutcome.success => '🎲 Rerolled!',
      RerollOutcome.alreadyUsedToday => 'Come back tomorrow — 1 reroll a day.',
      RerollOutcome.completionExists => 'Unmark today\'s quests to reroll.',
      RerollOutcome.notEnoughLe => 'Need 10⚡ in this level to reroll.',
      RerollOutcome.blocked => 'Place your tree first.',
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPast = ref.watch(isPastProvider);
    final isFuture = ref.watch(isFutureProvider);
    final quests = ref.watch(rolledQuestsForSelectedDateProvider);
    final date = ref.watch(selectedDateProvider);

    return DayPager(
      padding: const EdgeInsets.fromLTRB(
          AppSpace.screenGutter, 128, AppSpace.screenGutter, 24),
      children: [
        DateDisplay(date: date),
        const SizedBox(height: 16),
        _header(quests.asData?.value),
        const SizedBox(height: 16),
        if (isFuture)
          _empty('🔮', 'Side Quests not determined.\nThey roll on the day itself.')
        else
          quests.when(
            loading: () => const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Text('$e', style: AppType.body),
            data: (list) => list.isEmpty
                ? _empty('🌱',
                    isPast ? 'No quests were rolled this day.' : 'No active quests — add some in the Workshop.')
                : Column(
                    children: [
                      for (final rq in list) ...[
                        QuestCard(
                          rolled: rq,
                          readOnly: isPast,
                          onMark: () => _onMark(rq.quest.id),
                          onUndo: () => ref
                              .read(gameRepositoryProvider)
                              .unmarkQuest(rq.quest.id),
                        ),
                        const SizedBox(height: 14),
                      ],
                      if (!isPast) _rerollButton(),
                    ],
                  ),
          ),
      ],
    );
  }

  Widget _header(List<dynamic>? list) {
    final total = list?.length ?? 0;
    final done = list?.where((e) => e.done == true).length ?? 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Side Quests', style: AppType.display),
          const SizedBox(height: 3),
          Container(
              width: 120,
              height: 5,
              decoration: BoxDecoration(
                  color: AppColors.popPurple,
                  borderRadius: AppRadii.r(AppRadii.pill))),
        ]),
        Text('$done of $total done',
            style: AppType.label.copyWith(fontSize: 14)),
      ],
    );
  }

  Widget _rerollButton() {
    // Wide horizontal pill pinned below the list (design §5).
    return GestureDetector(
      onTap: _onReroll,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration:
            popSurface(fill: AppColors.energy, radius: AppRadii.pill, stroke: 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.casino_rounded, size: 22, color: AppColors.ink),
          const SizedBox(width: 10),
          Text('REROLL TODAY', style: AppType.label.copyWith(fontSize: 16)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: AppColors.ink, borderRadius: AppRadii.r(AppRadii.sm)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('-10',
                  style: AppType.label
                      .copyWith(fontSize: 13, color: AppColors.cream)),
              const Icon(Icons.bolt, size: 13, color: AppColors.energy),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _empty(String emoji, String msg) => Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 44)),
          const SizedBox(height: 12),
          Text(msg,
              textAlign: TextAlign.center,
              style: AppType.body.copyWith(color: AppColors.textMuted)),
        ]),
      );
}
