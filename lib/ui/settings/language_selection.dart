import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/language_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/language_enum.dart';

class LanguageSelection extends StatelessWidget {
  LanguageSelection({super.key});

  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.languageLink),
      ),
      body: Obx(() {
        // Accessing the observable here ensures Obx tracks changes to the language
        final currentLocale = languageController.language.value;

        return ListView.separated(
            itemCount: LanguageEnum.values.length,
            separatorBuilder: (context, index) => const Divider(thickness: 2),
            itemBuilder: (context, index) {
              final lang = LanguageEnum.values[index];
              final isSelected = currentLocale.languageCode == lang.locale.languageCode;

              return ListTile(
                title: Text(lang.name, style: Theme.of(context).textTheme.bodyLarge),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.red) : null,
                onTap: () {
                  languageController.updateLocalePref(lang.locale);
                },
              );

            });

      }),
    );
  }
}
