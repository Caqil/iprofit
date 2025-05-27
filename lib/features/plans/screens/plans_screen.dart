// lib/features/plans/screens/plans_screen.dart
import 'package:app/models/plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/plans_provider.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../widgets/plan_card.dart';
import '../widgets/purchase_plan_dialog.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansState = ref.watch(plansProvider);
    final authState = ref.watch(authProvider);

    final user = authState.valueOrNull;
    final userPlanId = user?.planId ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Investment Plans')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(plansProvider.future),
        child: plansState.when(
          data: (plans) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose Your Investment Plan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upgrade your plan to unlock higher daily limits and more benefits.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Current plan
                  if (userPlanId > 0) ...[
                    Text(
                      'Your Current Plan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PlanCard(
                      plan: plans.firstWhere((plan) => plan.id == userPlanId),
                      isCurrentPlan: true,
                      onUpgrade: (_) {},
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Available plans
                  const Text(
                    'Available Plans',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      final isCurrentPlan = plan.id == userPlanId;

                      if (isCurrentPlan) {
                        return const SizedBox.shrink();
                      }

                      return PlanCard(
                        plan: plan,
                        isCurrentPlan: false,
                        onUpgrade: (plan) =>
                            _showPurchasePlanDialog(context, plan, ref),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Plan comparison
                  const Text(
                    'Plan Comparison',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  _buildPlanComparisonTable(context, plans, userPlanId),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(plansProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanComparisonTable(
    BuildContext context,
    List<Plan> plans,
    int userPlanId,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Plan')),
            DataColumn(label: Text('Deposit Limit')),
            DataColumn(label: Text('Withdrawal Limit')),
            DataColumn(label: Text('Profit Limit')),
            DataColumn(label: Text('Price')),
          ],
          rows: plans.map((plan) {
            final isCurrentPlan = plan.id == userPlanId;

            return DataRow(
              selected: isCurrentPlan,
              color: isCurrentPlan
                  ? MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    )
                  : null,
              cells: [
                DataCell(
                  Row(
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontWeight: isCurrentPlan
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isCurrentPlan)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Current',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                ),
                DataCell(
                  Text(Formatters.formatCurrency(plan.dailyDepositLimit)),
                ),
                DataCell(
                  Text(Formatters.formatCurrency(plan.dailyWithdrawalLimit)),
                ),
                DataCell(
                  Text(Formatters.formatCurrency(plan.dailyProfitLimit)),
                ),
                DataCell(Text(Formatters.formatCurrency(plan.price))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPurchasePlanDialog(BuildContext context, Plan plan, WidgetRef ref) {
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PurchasePlanDialog(
          plan: plan,
          userBalance: user.balance,
          onConfirm: () => _purchasePlan(context, plan.id, ref),
        );
      },
    );
  }

  Future<void> _purchasePlan(
    BuildContext context,
    int planId,
    WidgetRef ref,
  ) async {
    try {
      await ref.read(plansProvider.notifier).purchasePlan(planId);

      if (context.mounted) {
        SnackbarUtils.showSuccessSnackbar(
          context,
          'Plan purchased successfully',
        );
        Navigator.pop(context); // Close dialog
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showErrorSnackbar(context, e.toString());
        Navigator.pop(context); // Close dialog
      }
    }
  }
}
