import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ProductLocationScreen extends StatefulWidget {
  const ProductLocationScreen({super.key});

  @override
  State<ProductLocationScreen> createState() => _ProductLocationScreenState();
}

class _ProductLocationScreenState extends State<ProductLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Track Your order'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TimelineTile(
              isFirst: true,
            ),
            TimelineTile(),
            TimelineTile(),
            TimelineTile(),
            TimelineTile(
              isLast: true,
            )
          ],
        ),
      )),
    );
  }
}
