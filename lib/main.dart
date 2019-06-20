import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News In App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const homeUrl = 'https://news.ycombinator.com/';

class _MyHomePageState extends State<MyHomePage> {
  WebViewController controller;
  String url = homeUrl;

  NavigationDecision navigationDelegate(NavigationRequest request) {
    setState(() {
      url = request.url;
    });
    return NavigationDecision.navigate;
  }

  _load() async {
    js = await rootBundle.loadString('assets/hn.js');
  }

  String js = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onHorizontalDragUpdate: (detail) {
          if (detail.delta.dx < -10) {
            controller?.goBack();
          } else if (detail.delta.dx > 10) {
            controller?.goForward();
          }
        },
        child: Scaffold(
          appBar: EmptyAppBar(),
          body: WebView(
            initialUrl: homeUrl,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: navigationDelegate,
            onWebViewCreated: (c) => controller = c,
            onPageFinished: (url) {
              if (url.startsWith(homeUrl)) {
                controller.evaluateJavascript(js);
              }
            },
          ),
        ),
      ),
      onWillPop: () async {
        String url = await controller?.currentUrl();
        if (url != null && url != homeUrl) {
          controller.goBack();
          return false;
        }
      },
    );
  }
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _defaultElevation = 4.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final Brightness brightness =
        appBarTheme.brightness ?? themeData.primaryColorBrightness;
    final SystemUiOverlayStyle overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: appBarTheme.color ?? themeData.primaryColor,
          elevation: appBarTheme.elevation ?? _defaultElevation,
          child: Semantics(
            explicitChildNodes: true,
            child: Container(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
