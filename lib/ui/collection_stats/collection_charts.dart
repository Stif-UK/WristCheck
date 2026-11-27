import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_diameter_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_thickness_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/colour_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/lug2lug_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/model_year_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/power_reserve_chart_enum.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/model/enums/stats_enums/wr_units_enum.dart';
import 'package:wristcheck/model/watch_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/charts/collection_charts/category_chart.dart';
import 'package:wristcheck/ui/charts/collection_charts/colour_chart.dart';
import 'package:wristcheck/ui/charts/collection_charts/cost_per_wear_chart.dart';
import 'package:wristcheck/ui/charts/collection_charts/date_complication_chart.dart';
import 'package:wristcheck/ui/charts/collection_charts/model_year_chart.dart';
import 'package:wristcheck/ui/charts/collection_charts/movement_chart.dart';
import 'package:wristcheck/ui/charts/collection_charts/power_reserve_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/case_diameters_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/case_material_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/case_thickness_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/lug2lug_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/lug_width_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/water_resistance_chart.dart';
import 'package:wristcheck/ui/widgets/responsive_two_column_grid.dart';
import 'package:wristcheck/ui/widgets/wrist_track_bottom_nav_bar.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_completeness_indicator.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';

class CollectionCharts extends StatefulWidget {
  CollectionCharts({Key? key}) : super(key: key);
  final collectionStatsController = Get.put(CollectionStatsController());

  @override
  State<CollectionCharts> createState() => _CollectionChartsState();
}

class _CollectionChartsState extends State<CollectionCharts> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "collection_charts");
    final wristCheckController = Get.put(WristCheckController());

    return ValueListenableBuilder<Box<Watches>>(
      valueListenable: Boxes.getWatches().listenable(),
      builder: (context, box, _) {
        final collectionWatches = Boxes.getCollectionWatches();
        return Obx(
          () => CollectionChartsBody(
            collectionWatches: collectionWatches,
            isPro: wristCheckController.isAppPro.value,
            costPerWearDataSize: ChartHelper.getCostPerWearChartSize(),
          ),
        );
      },
    );
  }
}

class CollectionChartsBody extends StatelessWidget {
  const CollectionChartsBody({
    super.key,
    required this.collectionWatches,
    required this.isPro,
    this.costPerWearDataSize,
    this.localeOverride,
    this.wrUnitOverride,
    this.onNavigateToDataCompleteness,
  });

  final List<Watches> collectionWatches;
  final bool isPro;
  final int? costPerWearDataSize;
  final LocationEnum? localeOverride;
  final WRUnitsEnum? wrUnitOverride;
  final VoidCallback? onNavigateToDataCompleteness;

  @override
  Widget build(BuildContext context) {
    final collectionStatsController = Get.put(CollectionStatsController());
    final l = AppLocalizations.of(context)!;

    final int effectiveCostPerWearSize = costPerWearDataSize ??
        collectionWatches
            .where((w) => WatchMethods.calculateCostPerWear(w) != 0.0)
            .length;

    final List<Widget> sections = [
      _buildSection(
        header: isPro
            ? _buildChartHeader(
                context: context,
                title: l.costPerWear,
                isComplete: CollectionStatsController.isCostPerWearComplete(
                  collectionWatches,
                ),
                trailing: Obx(
                  () => IconButton(
                    key: const Key('collection_cost_per_wear_price_button'),
                    icon: Icon(
                      collectionStatsController.showPrice.value
                          ? Icons.attach_money
                          : Icons.money_off,
                    ),
                    onPressed: () {
                      collectionStatsController.updateShowPrice(
                        !collectionStatsController.showPrice.value,
                      );
                    },
                  ),
                ),
              )
            : Text(
                l.goProTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
        body: isPro
            ? SizedBox(
                height: _calculateChartSpace(context, effectiveCostPerWearSize),
                child: Obx(
                  () => CostPerWearChart(
                    showData: collectionStatsController.showPrice.value,
                    watchesOverride: collectionWatches,
                    localeOverride: localeOverride,
                  ),
                ),
              )
            : ListTile(
                title: Text(l.upgradeToProForMoreCharts),
                trailing: Image.asset(
                  'assets/customicons/pro_icon.png',
                  scale: 1.0,
                  height: 30.0,
                  width: 30.0,
                  color: Theme.of(context).hintColor,
                ),
                onTap: () => WristCheckDialogs.getProUpgradeMessage(context),
              ),
      ),
      _buildSection(
        header: _buildChartHeader(
          context: context,
          title: l.movements,
          isComplete: CollectionStatsController.isMovementComplete(
            collectionWatches,
          ),
          trailing: Obx(
            () => IconButton(
              key: const Key('collection_movement_chart_type_button'),
              icon: buildCategoryChartTypeIcon(
                collectionStatsController.movementChartType.value,
              ),
              onPressed: collectionStatsController.cycleMovementChartType,
            ),
          ),
        ),
        body: MovementChart(watchesOverride: collectionWatches),
      ),
      _buildSection(
        header: _buildChartHeader(
          context: context,
          title: l.categories,
          isComplete: CollectionStatsController.isCategoryComplete(
            collectionWatches,
          ),
          trailing: Obx(
            () => IconButton(
              key: const Key('collection_category_chart_type_button'),
              icon: buildCategoryChartTypeIcon(
                collectionStatsController.categoryChartType.value,
              ),
              onPressed: collectionStatsController.cycleCategoryChartType,
            ),
          ),
        ),
        body: CategoryChart(watchesOverride: collectionWatches),
      ),
      _buildSection(
        header: Obx(() {
          final chartType = collectionStatsController.colourChartType.value;
          Widget iconWidget;
          if (chartType == ColourChartEnum.pie) {
            iconWidget = const FaIcon(FontAwesomeIcons.chartPie, size: 18);
          } else if (chartType == ColourChartEnum.donut) {
            iconWidget = const Icon(Icons.donut_large, size: 22);
          } else {
            iconWidget = const FaIcon(FontAwesomeIcons.layerGroup, size: 18);
          }
          return _buildChartHeader(
            context: context,
            title: l.colourChartTitle,
            subtitle: (chartType == ColourChartEnum.pie ||
                    chartType == ColourChartEnum.donut)
                ? l.primaryColourOnlySubHeader
                : null,
            isComplete: CollectionStatsController.isColourComplete(
              collectionWatches,
            ),
            trailing: IconButton(
              key: const Key('collection_colour_chart_type_button'),
              icon: iconWidget,
              onPressed: collectionStatsController.cycleColourChartType,
            ),
          );
        }),
        body: ColourChart(watchesOverride: collectionWatches),
      ),
      if (CollectionStatsController.hasModelYearData(collectionWatches))
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.modelYearRowTitle.replaceAll(':', ''),
            isComplete: CollectionStatsController.isModelYearComplete(
              collectionWatches,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => IconButton(
                    key: const Key('collection_model_year_decade_button'),
                    icon: collectionStatsController.groupWatchYearByDecade.value
                        ? const FaIcon(FontAwesomeIcons.layerGroup, size: 18)
                        : const FaIcon(FontAwesomeIcons.calendar, size: 18),
                    onPressed: () {
                      collectionStatsController.updateGroupWatchYearByDecade(
                        !collectionStatsController.groupWatchYearByDecade.value,
                      );
                    },
                  ),
                ),
                Obx(
                  () => IconButton(
                    key: const Key('collection_model_year_chart_type_button'),
                    icon: _buildModelYearChartIcon(
                      collectionStatsController.modelYearChartType.value,
                    ),
                    onPressed:
                        collectionStatsController.cycleModelYearChartType,
                  ),
                ),
              ],
            ),
          ),
          body: ModelYearChart(watchesOverride: collectionWatches),
        ),
      if (isPro) ...[
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.dateComplications,
            isComplete: CollectionStatsController.isDateComplicationComplete(
              collectionWatches,
            ),
            trailing: Obx(
              () => IconButton(
                key: const Key('collection_date_complication_chart_type_button'),
                icon: buildCategoryChartTypeIcon(
                  collectionStatsController.dateComplicationChartType.value,
                ),
                onPressed:
                    collectionStatsController.cycleDateComplicationChartType,
              ),
            ),
          ),
          body: DateComplicationChart(watchesOverride: collectionWatches),
        ),
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.caseDiameter,
            isComplete: CollectionStatsController.isCaseDiameterComplete(
              collectionWatches,
            ),
            trailing: Obx(
              () => IconButton(
                key: const Key('collection_case_diameter_chart_type_button'),
                icon: collectionStatsController.caseDiameterChartType.value ==
                        CaseDiameterChartEnum.line
                    ? const FaIcon(FontAwesomeIcons.chartLine, size: 18)
                    : const FaIcon(FontAwesomeIcons.chartSimple, size: 18),
                onPressed: collectionStatsController.toggleCaseDiameterChartType,
              ),
            ),
          ),
          body: CaseDiameterChart(watchesOverride: collectionWatches),
        ),
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.lugWidth,
            isComplete: CollectionStatsController.isLugWidthComplete(
              collectionWatches,
            ),
            trailing: Obx(
              () => IconButton(
                key: const Key('collection_lug_width_chart_type_button'),
                icon: buildCategoryChartTypeIcon(
                  collectionStatsController.lugWidthChartType.value,
                ),
                onPressed: collectionStatsController.cycleLugWidthChartType,
              ),
            ),
          ),
          body: LugWidthChart(watchesOverride: collectionWatches),
        ),
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.lugToLug,
            isComplete: CollectionStatsController.isLugToLugComplete(
              collectionWatches,
            ),
            trailing: Obx(
              () => IconButton(
                key: const Key('collection_lug2lug_chart_type_button'),
                icon: collectionStatsController.lug2lugChartType.value ==
                        Lug2lugChartEnum.line
                    ? const FaIcon(FontAwesomeIcons.chartLine, size: 18)
                    : const FaIcon(FontAwesomeIcons.chartSimple, size: 18),
                onPressed: () {
                  collectionStatsController.lug2lugChartType.value ==
                          Lug2lugChartEnum.line
                      ? collectionStatsController
                          .updateLug2LugChartType(Lug2lugChartEnum.bar)
                      : collectionStatsController
                          .updateLug2LugChartType(Lug2lugChartEnum.line);
                },
              ),
            ),
          ),
          body: L2LChart(watchesOverride: collectionWatches),
        ),
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.caseThickness,
            isComplete: CollectionStatsController.isCaseThicknessComplete(
              collectionWatches,
            ),
            trailing: Obx(
              () => IconButton(
                key: const Key('collection_case_thickness_chart_type_button'),
                icon: collectionStatsController.caseThicknessChartType.value ==
                        CaseThicknessChartEnum.line
                    ? const FaIcon(FontAwesomeIcons.chartLine, size: 18)
                    : const FaIcon(FontAwesomeIcons.chartSimple, size: 18),
                onPressed: () {
                  collectionStatsController.caseThicknessChartType.value ==
                          CaseThicknessChartEnum.line
                      ? collectionStatsController
                          .updateCaseThicknessChartType(
                            CaseThicknessChartEnum.bar,
                          )
                      : collectionStatsController
                          .updateCaseThicknessChartType(
                            CaseThicknessChartEnum.line,
                          );
                },
              ),
            ),
          ),
          body: CaseThicknessChart(watchesOverride: collectionWatches),
        ),
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.powerReserveRowHintText,
            isComplete: CollectionStatsController.isPowerReserveComplete(
              collectionWatches,
            ),
            trailing: Obx(
              () => IconButton(
                key: const Key('collection_power_reserve_chart_type_button'),
                icon: collectionStatsController.powerReserveChartType.value ==
                        PowerReserveChartEnum.line
                    ? const FaIcon(FontAwesomeIcons.chartLine, size: 18)
                    : const FaIcon(FontAwesomeIcons.chartSimple, size: 18),
                onPressed: () {
                  collectionStatsController.powerReserveChartType.value ==
                          PowerReserveChartEnum.line
                      ? collectionStatsController
                          .updatePowerReserveChartType(
                            PowerReserveChartEnum.bar,
                          )
                      : collectionStatsController
                          .updatePowerReserveChartType(
                            PowerReserveChartEnum.line,
                          );
                },
              ),
            ),
          ),
          body: PowerReserveChart(watchesOverride: collectionWatches),
        ),
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.waterResistance,
            isComplete: CollectionStatsController.isWaterResistanceComplete(
              collectionWatches,
            ),
            trailing: Obx(
              () => IconButton(
                key: const Key('collection_water_resistance_chart_type_button'),
                icon: buildCategoryChartTypeIcon(
                  collectionStatsController.waterResistanceChartType.value,
                ),
                onPressed:
                    collectionStatsController.cycleWaterResistanceChartType,
              ),
            ),
          ),
          body: WaterResistanceChart(
            watchesOverride: collectionWatches,
            unitOverride: wrUnitOverride,
          ),
        ),
        _buildSection(
          header: _buildChartHeader(
            context: context,
            title: l.caseMaterials,
            isComplete: CollectionStatsController.isCaseMaterialComplete(
              collectionWatches,
            ),
            trailing: Obx(
              () => IconButton(
                key: const Key('collection_case_material_chart_type_button'),
                icon: buildCategoryChartTypeIcon(
                  collectionStatsController.caseMaterialChartType.value,
                ),
                onPressed: collectionStatsController.cycleCaseMaterialChartType,
              ),
            ),
          ),
          body: CaseMaterialChart(watchesOverride: collectionWatches),
        ),
      ],
    ];

    return SingleChildScrollView(
      child: ResponsiveCollectionChartsLayout(sections: sections),
    );
  }

  Widget _buildModelYearChartIcon(ModelYearChartEnum chartType) {
    switch (chartType) {
      case ModelYearChartEnum.bar:
        return const FaIcon(FontAwesomeIcons.chartSimple, size: 18);
      case ModelYearChartEnum.column:
        return const Icon(Icons.bar_chart, size: 22);
      case ModelYearChartEnum.splineArea:
        return const Icon(Icons.area_chart, size: 22);
    }
  }

  Widget _buildChartHeader({
    required BuildContext context,
    required String title,
    String? subtitle,
    required bool isComplete,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RecapCompletenessIndicator(
          isComplete: isComplete,
          useCollectionCopy: true,
          onNavigateToDataCompleteness: onNavigateToDataCompleteness,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        trailing ?? const SizedBox(width: 24),
      ],
    );
  }

  Widget _buildSection({
    required Widget header,
    required Widget body,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: header,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: body,
        ),
      ],
    );
  }
}

class ResponsiveCollectionChartsLayout extends StatelessWidget {
  const ResponsiveCollectionChartsLayout({
    super.key,
    required this.sections,
    this.breakpoint = WristTrackBottomNavBar.largeScreenBreakpoint,
    this.maxWidth = 1200.0,
  });

  final List<Widget> sections;
  final double breakpoint;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final bool useTwoColumns = availableWidth >= breakpoint;

        if (!useTwoColumns) {
          final List<Widget> phoneChildren = [];
          for (int i = 0; i < sections.length; i++) {
            phoneChildren.add(sections[i]);
            if (i < sections.length - 1) {
              phoneChildren.add(const Divider(thickness: 2));
            }
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: phoneChildren,
          );
        }

        final List<Widget> cards = sections
            .map(
              (section) => Card(
                elevation: 4,
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: section,
                ),
              ),
            )
            .toList();

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: ResponsiveTwoColumnGrid(
                breakpoint: breakpoint,
                horizontalSpacing: 0.0,
                maxWidth: maxWidth,
                packColumns: true,
                children: cards,
              ),
            ),
          ),
        );
      },
    );
  }
}

double _calculateChartSpace(BuildContext context, int dataSize) {
  return ChartHelper.calculateChartSpace(context, dataSize);
}
