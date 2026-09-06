import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/copy/whats_new_copy.dart';
import 'package:wristcheck/l10n/app_localizations.dart';

class WhatsNewBottomSheet extends StatelessWidget {
  const WhatsNewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Get.isDarkMode ? Colors.grey[600] : Colors.white38,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.wristTrackUpdatedBottomSheetTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.x),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(thickness: 2),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Markdown(
                      data: WhatsNewCopy.getLatestVersionCopy(),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
