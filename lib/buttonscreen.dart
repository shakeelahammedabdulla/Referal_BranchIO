// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

// class MyApp extends StatelessWidget {


// StreamController<String> controllerUrl = StreamController<String>();

//   void generateLink(BranchUniversalObject buo, BranchLinkProperties lp) async {
//     BranchResponse response =
//         await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp);
//     if (response.success) {
//       print(response.result)
//       controllerUrl.sink.add('${response.result}');
//     } else {
//       controllerUrl.sink
//           .add('Error : ${response.errorCode} - ${response.errorMessage}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Referral Share Button'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
             


//   BranchLinkProperties lp = BranchLinkProperties(
//                 channel: 'facebook',
//                 feature: 'sharing',
//                 stage: 'new share',
//                 campaign: 'xxxxx',
//                 tags: ['one', 'two', 'three'],
//               );

//     lp.addControlParam('\$uri_redirect_mode', '1');

//      return generateLink(

//          BranchUniversalObject(
//         canonicalIdentifier: 'flutter/branch',
//         //canonicalUrl: '',
//         title: 'Flutter Branch Plugin',
//         imageUrl:
//             'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
//         contentDescription: 'Flutter Branch Description',
//         contentMetadata: BranchContentMetaData()
//           ..addCustomMetadata('custom_string', 'abc')
//           ..addCustomMetadata('custom_number', 12345)
//           ..addCustomMetadata('custom_bool', true)
//           ..addCustomMetadata('custom_list_string', ['a', 'b', 'c']),
//         keywords: ['Plugin', 'Branch', 'Flutter'],
//         publiclyIndex: true,
//         locallyIndex: true,
//         expirationDateInMilliSec:
//             DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch);

//               );
//             },
//             child: Text('generate link'),
//           ),
//         ),
//       ),
//     );
//   }
// }

