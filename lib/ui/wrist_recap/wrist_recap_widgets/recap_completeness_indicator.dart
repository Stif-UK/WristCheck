import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/ui/appdata/data_completeness.dart';

class RecapCompletenessIndicator extends StatelessWidget {
  const RecapCompletenessIndicator({
    super.key,
    required this.isComplete,
    this.useCollectionCopy = false,
    this.onNavigateToDataCompleteness,
  });

  final bool isComplete;
  final bool useCollectionCopy;
  final VoidCallback? onNavigateToDataCompleteness;

  String _message(AppLocalizations l) {
    if (useCollectionCopy) {
      return isComplete
          ? l.collectionDataCompleteTooltip
          : l.collectionDataIncompleteTooltip;
    }
    return isComplete
        ? l.recapDataCompleteTooltip
        : l.recapDataIncompleteTooltip;
  }

  Widget _buildIcon({required double circleSize, required double warningSize}) {
    return isComplete
        ? Icon(
            Icons.circle,
            color: Colors.green,
            size: circleSize,
          )
        : FaIcon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.amber,
            size: warningSize,
          );
  }

  void _showCompletenessDialog(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final String message = _message(l);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: _buildIcon(circleSize: 32, warningSize: 32),
        title: Text(
          isComplete
              ? l.recapDataCompleteDialogTitle
              : l.recapDataIncompleteDialogTitle,
        ),
        content: Text(message),
        actions: [
          TextButton.icon(
            icon: const FaIcon(FontAwesomeIcons.listCheck, size: 16),
            label: Text(l.viewDataCompleteness),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (onNavigateToDataCompleteness != null) {
                onNavigateToDataCompleteness!();
              } else {
                Get.to(() => DataCompleteness());
              }
            },
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final String message = _message(l);

    return Tooltip(
      message: message,
      preferBelow: false,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showCompletenessDialog(context),
        child: Padding(
          padding: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
          child: _buildIcon(circleSize: 12, warningSize: 16),
        ),
      ),
    );
  }
}
