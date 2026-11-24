import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/ui/widgets/bottomsheets/wrist_recap_bottomsheet.dart';
import 'package:wristcheck/ui/widgets/responsive_two_column_grid.dart';
import 'package:wristcheck/ui/widgets/wrist_track_bottom_nav_bar.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/annual_segments/top_brand_monthly.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/annual_segments/top_category_monthly.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/annual_segments/top_watch_monthly.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/collection_movement.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/brand_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/category_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/colour_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/wear_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/status_wear_chart.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/watches_worn_carousel.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_segments/wrist_recap_insights.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/empty_data.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/wrist_recap_adprompt.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/wrist_recap_thanks.dart';

class WristRecapHome extends StatelessWidget {
  WristRecapHome({super.key, this.month, this.year, this.selectedOption = WristRecapEnums.monthly});

  final int? month;
  final int? year;
  final WristRecapEnums selectedOption;
  final recapController = Get.put(WristRecapController());
  final wristCheckController = Get.put(WristCheckController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "wrist_recap_v2");
    //Initialise the controller
    if (month != null) recapController.updateMonth(month!);
    if (year != null) recapController.updateYear(year!);
    recapController.setRecapOption(selectedOption);
    //Run refresh in controller
    recapController.refresh();

    return Scaffold(
      appBar: AppBar(
        title: (Text("Wrist Recap")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: FaIcon(FontAwesomeIcons.sliders,),
            onPressed: (){
                showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context){
                return WristRecapBottomsheet();
                }
                );
                },
           )),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Obx(() {
              bool showNavigation = recapController.selectedRecapOption.value == WristRecapEnums.monthly ||
                  recapController.selectedRecapOption.value == WristRecapEnums.annually;
              return Row(
                children: [
                  if (showNavigation)
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.chevronLeft),
                      onPressed: () => recapController.decrementMonth(),
                    ),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  recapController.getRecapHeaderText(context),
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  if (showNavigation)
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.chevronRight),
                      onPressed: () => recapController.incrementMonth(),
                    ),
                ],
              );
            }),
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              right: false,
              child: Obx(() {
              final hasWorn = recapController.watchesWorn.isNotEmpty;
              final hasMovement = recapController.watchesBought.isNotEmpty ||
                  recapController.watchesSold.isNotEmpty;

              if (!_dataExists(
                hasWorn,
                recapController.watchesBought.isNotEmpty,
                recapController.watchesSold.isNotEmpty,
              )) {
                return WristRecapEmptyData();
              }

              final bool isAnnual =
                  recapController.selectedRecapOption.value == WristRecapEnums.annually;
              final bool showTopWatchMonthly = isAnnual &&
                  recapController.topWatchMonthly.any((element) => element.count > 0);
              final bool showBrandChart = recapController.duplicateBrand.value;
              final bool showTopBrandMonthly = isAnnual &&
                  showBrandChart &&
                  recapController.topBrandMonthly.any((element) => element.count > 0);
              final bool showCategoryChart = recapController.categoriesWorn.length > 1;
              final bool showTopCategoryMonthly = isAnnual &&
                  showCategoryChart &&
                  recapController.topCategoryMonthly.any((element) => element.count > 0);
              final bool showStatusChart = recapController.statusWorn.length > 1;
              final bool showColourChart = recapController.coloursWorn.isNotEmpty;

              final Widget? adPrompt = !wristCheckController.isAppPro.value &&
                      recapController.showOptionalAdCard.value
                  ? WristRecapAdprompt()
                  : null;

              final Widget? thanksCard = !wristCheckController.isAppPro.value &&
                      !recapController.showOptionalAdCard.value
                  ? WristRecapThanks()
                  : null;

              final List<Widget> cards = [
                if (hasWorn) WearChart(),
                if (hasWorn) WristRecapInsights(),
                if (showTopWatchMonthly) const TopWatchMonthly(),
                if (hasMovement) CollectionMovement(),
                if (showBrandChart) const BrandChart(),
                if (showTopBrandMonthly) const TopBrandMonthly(),
                if (showCategoryChart) CategoryChart(),
                if (showTopCategoryMonthly) const TopCategoryMonthly(),
                if (showStatusChart) StatusWearChart(),
                if (showColourChart) const WristRecapColourChart(),
              ];

              return ResponsiveWristRecapBody(
                adPrompt: adPrompt,
                watchesWornCarousel: hasWorn ? WatchesWornCarousel() : null,
                cards: cards,
                thanksCard: thanksCard,
                packColumns: recapController.packCharts.value,
              );
            }),
            ),
          ),
        ],
      ),
    );
  }

  bool _dataExists(bool watchesWorn, bool watchesBought, bool watchesSold){
    return watchesWorn || watchesBought || watchesSold;
  }

}

class ResponsiveWristRecapBody extends StatelessWidget {
  const ResponsiveWristRecapBody({
    super.key,
    this.adPrompt,
    this.watchesWornCarousel,
    required this.cards,
    this.thanksCard,
    this.breakpoint = WristTrackBottomNavBar.largeScreenBreakpoint,
    this.maxWidth = 1200.0,
    this.packColumns = true,
  });

  final Widget? adPrompt;
  final Widget? watchesWornCarousel;
  final List<Widget> cards;
  final Widget? thanksCard;
  final double breakpoint;
  final double maxWidth;
  final bool packColumns;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (adPrompt != null) adPrompt!,
              if (watchesWornCarousel != null) watchesWornCarousel!,
              if (cards.isNotEmpty)
                ResponsiveTwoColumnGrid(
                  breakpoint: breakpoint,
                  horizontalSpacing: 0.0,
                  maxWidth: maxWidth,
                  packColumns: packColumns,
                  children: cards,
                ),
              if (thanksCard != null) thanksCard!,
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
