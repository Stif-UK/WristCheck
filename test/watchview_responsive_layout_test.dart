import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/watchview_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/watch_status_enum.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/ui/watch/header/watch_image_carousel.dart';
import 'package:wristcheck/ui/watch/tabs/dates_tab.dart';
import 'package:wristcheck/ui/watch/tabs/info_tab.dart';
import 'package:wristcheck/ui/watch/tabs/notes_tab.dart';
import 'package:wristcheck/ui/watch/tabs/value_tab.dart';
import 'package:wristcheck/ui/widgets/responsive_two_column_grid.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  Future<void> pumpWithSize(
    WidgetTester tester, {
    required Size screenSize,
    required Widget child,
    double? paneWidth,
  }) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: paneWidth != null
                ? Center(
                    child: SizedBox(
                      width: paneWidth,
                      child: child,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ResponsiveTwoColumnGrid', () {
    testWidgets('stacks children in single column below 500dp', (tester) async {
      await pumpWithSize(
        tester,
        screenSize: const Size(450, 800),
        child: const ResponsiveTwoColumnGrid(
          children: [
            SizedBox(height: 50, child: Text('Item 1')),
            SizedBox(height: 50, child: Text('Item 2')),
            SizedBox(height: 50, child: Text('Item 3')),
          ],
        ),
      );

      final rect1 = tester.getRect(find.text('Item 1'));
      final rect2 = tester.getRect(find.text('Item 2'));
      final rect3 = tester.getRect(find.text('Item 3'));

      expect(rect1.top, lessThan(rect2.top));
      expect(rect2.top, lessThan(rect3.top));
    });

    testWidgets('lays out children in 2-column rows at >= 500dp including odd trailing item',
        (tester) async {
      await pumpWithSize(
        tester,
        screenSize: const Size(700, 800),
        child: const ResponsiveTwoColumnGrid(
          children: [
            SizedBox(height: 50, child: Text('Item 1')),
            SizedBox(height: 50, child: Text('Item 2')),
            SizedBox(height: 50, child: Text('Item 3')),
          ],
        ),
      );

      final rect1 = tester.getRect(find.text('Item 1'));
      final rect2 = tester.getRect(find.text('Item 2'));
      final rect3 = tester.getRect(find.text('Item 3'));

      expect(rect1.top, rect2.top);
      expect(rect1.left, lessThan(rect2.left));
      expect(rect3.top, greaterThan(rect1.top));
      expect(rect3.left, rect1.left);
    });
  });

  group('Tabs responsive 2-column layout', () {
    testWidgets('InfoTab pairs fields in 2 columns on wide pane without overflow', (tester) async {
      final controller = Get.put(WatchViewController());
      controller.updateInEditState(true);
      controller.updateViewState(WatchViewEnum.add);

      final manufacturer = TextEditingController();
      final model = TextEditingController();
      final serial = TextEditingController();
      final reference = TextEditingController();
      final movement = TextEditingController();
      final category = TextEditingController();
      final primaryColour = TextEditingController();
      final secondaryColour = TextEditingController();

      addTearDown(() {
        manufacturer.dispose();
        model.dispose();
        serial.dispose();
        reference.dispose();
        movement.dispose();
        category.dispose();
        primaryColour.dispose();
        secondaryColour.dispose();
      });

      await pumpWithSize(
        tester,
        screenSize: const Size(800, 1200),
        child: Builder(
          builder: (context) => InfoTab(
            manufacturerFieldController: manufacturer,
            modelFieldController: model,
            serialNumberFieldController: serial,
            referenceNumberFieldController: reference,
            movementFieldController: movement,
            categoryFieldController: category,
            primaryColourFieldController: primaryColour,
            secondaryColourFieldController: secondaryColour,
            bodyLarge: Theme.of(context).textTheme.bodyLarge,
            context: context,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final l10n = AppLocalizations.of(tester.element(find.byType(InfoTab)))!;
      final manufacturerRect = tester.getRect(find.text(l10n.manufacturerRowTitle));
      final modelRect = tester.getRect(find.text(l10n.modelRowTitle));
      final categoryRect = tester.getRect(find.text(l10n.categoryRowTitle));
      final movementRect = tester.getRect(find.text(l10n.movementRowTitle));

      expect(manufacturerRect.top, modelRect.top);
      expect(manufacturerRect.left, lessThan(modelRect.left));
      expect(categoryRect.top, movementRect.top);
      expect(categoryRect.left, lessThan(movementRect.left));
      expect(categoryRect.top, greaterThan(manufacturerRect.top));
    });

    testWidgets('DatesTab packs visible fields cleanly without blank gaps when status is Sold',
        (tester) async {
      final controller = Get.put(WatchViewController());
      controller.updateInEditState(true);
      controller.updateViewState(WatchViewEnum.edit);
      controller.updateSelectedStatus(WatchStatusEnum.sold.toDbString());

      final modelYear = TextEditingController();
      final delivery = TextEditingController();
      final purchase = TextEditingController();
      final sold = TextEditingController();
      final timeInCollection = TextEditingController();
      final serviceInterval = TextEditingController();
      final warrantyEnd = TextEditingController();
      final lastServiced = TextEditingController();
      final nextServiceDue = TextEditingController();

      addTearDown(() {
        modelYear.dispose();
        delivery.dispose();
        purchase.dispose();
        sold.dispose();
        timeInCollection.dispose();
        serviceInterval.dispose();
        warrantyEnd.dispose();
        lastServiced.dispose();
        nextServiceDue.dispose();
      });

      await pumpWithSize(
        tester,
        screenSize: const Size(800, 1200),
        child: DatesTab(
          modelYearFieldController: modelYear,
          deliveryDateFieldController: delivery,
          purchaseDateFieldController: purchase,
          soldDateFieldController: sold,
          timeInCollectionFieldController: timeInCollection,
          serviceIntervalFieldController: serviceInterval,
          warrantyEndDateFieldController: warrantyEnd,
          lastServicedDateFieldController: lastServiced,
          nextServiceDueFieldController: nextServiceDue,
          currentWatch: null,
        ),
      );

      expect(tester.takeException(), isNull);
      final l10n = AppLocalizations.of(tester.element(find.byType(DatesTab)))!;
      final modelYearRect = tester.getRect(find.text(l10n.modelYearRowTitle));
      final purchaseDateRect = tester.getRect(find.text(l10n.purchaseDateRowTitle));
      final soldDateRect = tester.getRect(find.text(l10n.soldDateRowTitle));
      final warrantyEndRect = tester.getRect(find.text(l10n.warrantyEndRowTitle));

      expect(modelYearRect.top, purchaseDateRect.top);
      expect(soldDateRect.top, warrantyEndRect.top);
      expect(soldDateRect.left, lessThan(warrantyEndRect.left));
    });

    testWidgets('ValueTab aligns view-mode price rows in 2 columns without overflow', (tester) async {
      final controller = Get.put(WatchViewController());
      controller.updateInEditState(false);
      controller.updateViewState(WatchViewEnum.view);
      controller.updateSelectedStatus(WatchStatusEnum.sold.toDbString());
      controller.updatePurchasePrice(5000);
      controller.updateSoldPrice(5500);
      controller.updateCurrentValue(6000);

      final purchasePrice = TextEditingController(text: '5000');
      final purchasedFrom = TextEditingController(text: 'Authorized Dealer');
      final soldPrice = TextEditingController(text: '5500');
      final soldTo = TextEditingController(text: 'Private Buyer');
      final currentValue = TextEditingController(text: '6000');

      addTearDown(() {
        purchasePrice.dispose();
        purchasedFrom.dispose();
        soldPrice.dispose();
        soldTo.dispose();
        currentValue.dispose();
      });

      await pumpWithSize(
        tester,
        screenSize: const Size(800, 1200),
        child: Builder(
          builder: (context) => ValueTab(
            purchasePriceFieldController: purchasePrice,
            purchasedFromFieldController: purchasedFrom,
            soldPriceFieldController: soldPrice,
            soldToFieldController: soldTo,
            currentValueFieldController: currentValue,
            currentWatch: null,
            bodyLarge: Theme.of(context).textTheme.bodyLarge,
            headlineSmall: Theme.of(context).textTheme.headlineSmall,
            locale: 'en_US',
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final l10n = AppLocalizations.of(tester.element(find.byType(ValueTab)))!;
      final purchasePriceRect = tester.getRect(find.text(l10n.purchasePriceRowTitle));
      final purchasedFromRect = tester.getRect(find.text(l10n.purchasedFromRowTitle));
      final soldPriceRect = tester.getRect(find.text(l10n.soldPriceRowTitle));
      final soldToRect = tester.getRect(find.text(l10n.soldToRowTitle));

      expect(purchasePriceRect.top, purchasedFromRect.top);
      expect(soldPriceRect.top, soldToRect.top);
    });

    testWidgets('NotesTab caps width at 800dp on wide screens', (tester) async {
      Get.put(WatchViewController());
      final notes = TextEditingController();
      addTearDown(notes.dispose);

      await pumpWithSize(
        tester,
        screenSize: const Size(1200, 800),
        child: NotesTab(notesFieldController: notes),
      );

      expect(tester.takeException(), isNull);
      final fieldRect = tester.getRect(find.byType(TextFormField));
      expect(fieldRect.width, lessThanOrEqualTo(800.0));
    });
  });

  group('WatchImageCarousel constrained left pane', () {
    testWidgets('fits within 450dp left pane on 1200x800 landscape tablet', (tester) async {
      Get.put(WatchViewController());

      await pumpWithSize(
        tester,
        screenSize: const Size(1200, 800),
        paneWidth: 450.0,
        child: WatchImageCarousel(currentWatch: null),
      );

      expect(tester.takeException(), isNull);
      final carouselRect = tester.getRect(find.byType(WatchImageCarousel));
      expect(carouselRect.width, lessThanOrEqualTo(450.0));
      expect(carouselRect.height, lessThanOrEqualTo(400.0));
    });
  });
}
