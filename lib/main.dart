import 'package:arief_kiddocare_tech/provider/listing_prvd.dart';
import 'package:arief_kiddocare_tech/view/listing_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KindergartenProvider()),
      ],
      child: KindergartenApp(),
    ),
  );
}

class KindergartenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider State Management Demo',
      home: ListingScreen(),
    );
  }
}
