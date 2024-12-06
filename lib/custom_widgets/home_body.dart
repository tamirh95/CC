import 'package:flutter/material.dart';
class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // Number of columns
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0, // Aspect ratio of each card
      children: List.generate(4, (index) { // Generate 4 cards as an example
        return Center(
          child: ServiceCard(index: index),
        );
      }),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final int index;

  const ServiceCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // Adds a subtle rounding to the corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 11.0,
            child: Image.asset('assets/service_${index}.jpg', fit: BoxFit.cover), // Replace with actual images
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Service Title $index', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 8.0),
                Text('Service Description', style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}