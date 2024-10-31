// import 'package:flutter/material.dart';
// import '../../model/tl_theme.dart';
// import '../../constants/styles.dart';

// Future<void> notifyCategoryIsAdded(
//     {required BuildContext context, required String addedCategoryName}) {
//   final TLThemeData _tlThemeData = TLTheme.of(context);
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: _tlThemeData.alertColor,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0, bottom: 12),
//                   child: Text(
//                     addedCategoryName,
//                     style: TextStyle(
//                         color: _tlThemeData.accentColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                 ),
//                 Text(
//                   "を追加しました!",
//                   style: TextStyle(
//                       color: Colors.black.withOpacity(0.7),
//                       fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     style:
//                         alertButtonStyle(accentColor: _tlThemeData.accentColor),
//                     child: Text(
//                       "OK",
//                       style: TextStyle(color: _tlThemeData.accentColor),
//                     ))
//               ],
//             ),
//           ),
//         );
//       });
// }