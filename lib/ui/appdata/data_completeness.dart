import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/watches.dart';

class DataCompleteness extends StatelessWidget {
  DataCompleteness({super.key});

  final wristCheckController = Get.put(WristCheckController());

  bool _isPopulated(dynamic value) {
    if (value == null) return false;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return false;
      if (trimmed == 'Not Entered' || trimmed == 'Not Selected') return false;
      return true;
    }
    return true;
  }

  Widget _buildFieldTile({
    required BuildContext context,
    required String title,
    required List<Watches> collectionWatches,
    required dynamic Function(Watches) fieldExtractor,
    bool isProField = false,
    required bool isAppPro,
  }) {
    final totalCount = collectionWatches.length;

    if (isProField && !isAppPro) {
      return ListTile(
        leading: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: Image.asset(
              'assets/customicons/pro_icon.png',
              height: 30.0,
              width: 30.0,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        title: Text(title),
        trailing: Text(
          '-/$totalCount',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final populatedCount = collectionWatches.where((w) {
      final val = fieldExtractor(w);
      return _isPopulated(val);
    }).length;

    final progress = totalCount > 0 ? (populatedCount / totalCount) : 0.0;
    final isComplete = totalCount > 0 && populatedCount == totalCount;

    return ListTile(
      leading: SizedBox(
        width: 36,
        height: 36,
        child: isComplete
            ? const Center(
                child: FaIcon(
                  FontAwesomeIcons.circleCheck,
                  color: Colors.green,
                  size: 36,
                ),
              )
            : CircularProgressIndicator(
                value: progress,
                strokeWidth: 8.0,
                backgroundColor: Colors.grey.withValues(alpha: 0.3),
              ),
      ),
      title: Text(title),
      trailing: Text(
        '$populatedCount/$totalCount',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.headlineSmall;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Completeness'),
      ),
      body: ValueListenableBuilder<Box<Watches>>(
        valueListenable: Boxes.getWatches().listenable(),
        builder: (context, box, _) {
          final collectionWatches = Boxes.getCollectionWatches();
          final count = collectionWatches.length;
          final l = AppLocalizations.of(context);

          return Obx(() {
            final isAppPro = wristCheckController.isAppPro.value;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Watches in collection:',
                        style: headerStyle,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count',
                        style: headerStyle,
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 2),
                Expanded(
                  child: ListView(
                    children: [
                      // --- Standard (Non-Pro) Fields ---
                      _buildFieldTile(
                        context: context,
                        title: l?.serialNumberRowHintText ?? 'Serial Number',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.serialNumber,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.purchaseDateRowHintText ?? 'Purchase Date',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.purchaseDate,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.lastServicedDateRowHintText ?? 'Last Serviced Date',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.lastServicedDate,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.referenceNumberRowHelpText ?? 'Reference Number',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.referenceNumber,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.movement ?? 'Movement',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.movement,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.category ?? 'Category',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.category,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.purchasedFromHintText ?? 'Purchased From',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.purchasedFrom,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.purchasePriceRowHintText ?? 'Purchase Price',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.purchasePrice,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.modelYearRowHintText ?? 'Model Year',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.year,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.primaryColourHintText ?? 'Colour',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.primaryColour,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.secondaryColourHintText ?? 'Secondary Colour',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.secondaryColour,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),

                      // --- Pro Fields (Grouped together at the bottom) ---
                      _buildFieldTile(
                        context: context,
                        title: l?.caseDiameterRowHintText ?? 'Case Diameter',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.caseDiameter,
                        isProField: true,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.lugWidthHintText ?? 'Lug Width',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.lugWidth,
                        isProField: true,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.lug2lugRowHintText ?? 'Lug to Lug',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.lug2lug,
                        isProField: true,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.caseThicknessRowHintText ?? 'Case Thickness',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.caseThickness,
                        isProField: true,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.waterResistanceRowHintText ?? 'Water Resistance',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.waterResistance,
                        isProField: true,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.caseMaterial ?? 'Case Material',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.caseMaterial,
                        isProField: true,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.dateComplication ?? 'Date Complication',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.dateComplication,
                        isProField: true,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                      _buildFieldTile(
                        context: context,
                        title: l?.powerReserveRowHintText ?? 'Power Reserve',
                        collectionWatches: collectionWatches,
                        fieldExtractor: (w) => w.powerReserve,
                        isProField: true,
                        isAppPro: isAppPro,
                      ),
                      const Divider(thickness: 2),
                    ],
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
  }
}
