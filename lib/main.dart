

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:url_launcher/url_launcher.dart';  // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FlutterBranchSdk.init();
  } catch (error) {
    print("Error initializing Branch SDK: $error");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BranchContentMetaData metadata = BranchContentMetaData();
  BranchUniversalObject? buo;
  BranchLinkProperties lp = BranchLinkProperties();
  BranchEvent? eventStandart;
  BranchEvent? eventCustom;

  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  StreamController<String> controllerUrl = StreamController<String>();

  @override
  void initState() {
    super.initState();
    listenDynamicLinks();
    initDeepLinkData();
  }

  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      print('listenDynamicLinks - DeepLink Data: $data');
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        print('------------------------------------Link clicked----------------------------------------------');
        print('Custom string: ${data['custom_string']}');
        print('Custom number: ${data['custom_number']}');
        print('Custom bool: ${data['custom_bool']}');
        print('Custom list number: ${data['custom_list_number']}');
        print('------------------------------------------------------------------------------------------------');
        showSnackBar(
            context: context,
            message: 'Link clicked: Custom string - ${data['custom_string']}',
            duration: 10);
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print('InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSession.add('InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  void initDeepLinkData() {
    metadata = BranchContentMetaData()
        .addCustomMetadata('custom_string', 'abc')
        .addCustomMetadata('custom_number', 12345)
        .addCustomMetadata('custom_bool', true)
        .addCustomMetadata('custom_list_number', [1, 2, 3, 4, 5])
        .addCustomMetadata('custom_list_string', ['a', 'b', 'c']);

    buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: 'Flutter Branch Plugin',
        imageUrl: 'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
        contentDescription: 'Flutter Branch Description',
        contentMetadata: metadata,
        keywords: ['Plugin', 'Branch', 'Flutter'],
        publiclyIndex: true,
        locallyIndex: true,
        expirationDateInMilliSec: DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch);

    FlutterBranchSdk.registerView(buo: buo!);

    lp = BranchLinkProperties(
        channel: 'email', // The channel through which the link is shared
        feature: 'invite', // The feature of your app being used
        stage: 'new_user', // The stage of your marketing campaign
        campaign: 'welcome_campaign', // The name of your campaign
        tags: ['invite', 'new_user', 'promotion'] // Tags for categorization
    );
    lp.addControlParam('\$uri_redirect_mode', '1');

    eventStandart = BranchEvent.standardEvent(BranchStandardEvent.ADD_TO_CART);
    eventCustom = BranchEvent.customEvent('Custom_event');
    eventCustom!.addCustomData('Custom_Event_Property_Key1', 'Custom_Event_Property_val1');
    eventCustom!.addCustomData('Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
  }

  void generateLink() async {
    if (buo != null && lp != null) {
      BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp);
      if (response.success) {
        controllerUrl.sink.add(response.result!);
        showSnackBar(context: context, message: 'Generated Link: ${response.result}');
        _launchURL(response.result!);  // Open the generated link
      } else {
        controllerUrl.sink.add('Error : ${response.errorCode} - ${response.errorMessage}');
      }
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showSnackBar({required BuildContext context, required String message, int duration = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message), duration: Duration(seconds: duration)));
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    controllerData.close();
    controllerInitSession.close();
    controllerUrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Referral Share Button')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            generateLink();
          },
          child: Text('Generate and Open Link'),
        ),
      ),
    );
  }
}

