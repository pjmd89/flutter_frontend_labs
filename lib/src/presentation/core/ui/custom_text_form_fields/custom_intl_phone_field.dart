// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gps_flutter_desktop/components/format_validator/main.dart';
// import 'package:gps_flutter_desktop/components/list_errors/backend.dart';
// import 'package:gps_flutter_desktop/provider/session.dart';
// import 'package:intl_phone_field/country_picker_dialog.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// class CustomIntlPhoneField extends StatefulWidget {
//   final LoggedNotifier sessionProviderRdr;
//   final void Function(String) onChange;
//   const CustomIntlPhoneField({
//     super.key,
//     required this.onChange, required this.sessionProviderRdr
//   });
//   @override
//   State<CustomIntlPhoneField> createState() => _CustomIntlPhoneFieldState();
// }

// class _CustomIntlPhoneFieldState extends State<CustomIntlPhoneField> {
//   String countryCode = "+52";
//   String phone = "";
//   String? initialCountryCode;
//   bool enabled = false;

  

//   void secureSetState(){
//     if(mounted) setState((){});
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Skeletonizer(
//       enabled: !enabled,
//       child: IntlPhoneField(
//         onCountryChanged: (country) {
//           countryCode = "+${country.fullCountryCode}";
//           setState(() {});
//           setState(() {});
//           String completeNumber = "$countryCode$phone";
//           widget.onChange(completeNumber);
//         },
//         onChanged: (value) {
//           phone = value.number;
//           countryCode = value.countryCode;
//           setState(() {});
//           String completeNumber = "$countryCode$phone";
//           widget.onChange(completeNumber);
//         },
//         inputFormatters: [
//           FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))
//         ],
//         validator: (value) {
//           String completeNumber = "$countryCode$phone";
//           return FormatValidator.validateUserCellPhone(context, completeNumber);
//         },  
//         pickerDialogStyle: PickerDialogStyle(
//           searchFieldInputDecoration: InputDecoration(
//             label: Text(AppLocalizations.of(context)!.findByConuntry)
//           )
//         ),
//         invalidNumberMessage: ListBackendError(context, "122").errorMessage,
//         flagsButtonPadding: const EdgeInsets.all(8),
//         dropdownIconPosition: IconPosition.trailing,
//         decoration: InputDecoration(
//           label: Text(AppLocalizations.of(context)!.phone),
//           isDense: true,
//           border: const OutlineInputBorder(),
//           counterText: "",
//           helperText: "  "
//         ),
//         initialCountryCode: initialCountryCode ?? 'MX',
//       ),
//     );
//   }
// }