import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
class FetchErrorScreen extends StatelessWidget {
  const FetchErrorScreen({super.key, this.callBack});
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(AppLocalizations.of(context)!.somethingWentWrong, style: Theme.of(context).textTheme.headlineSmall),
          ),
          Text(AppLocalizations.of(context)!.connectionError, style: Theme.of(context).textTheme.bodyMedium),
          Text(AppLocalizations.of(context)!.pleaseTryLater, style: Theme.of(context).textTheme.bodyMedium),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: OutlinedButton(
              onPressed: callBack ?? (){},  
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.restart_alt),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(AppLocalizations.of(context)!.tryAgain),
                ],
              )),
          )
        ],
      ),
    );
  }
}