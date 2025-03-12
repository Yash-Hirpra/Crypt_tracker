import 'package:flutter/material.dart';
import '../widgets/crypto_chart.dart';

class CryptoDetailScreen extends StatelessWidget {
  final dynamic crypto;

  CryptoDetailScreen({required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(crypto['name'])),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Image.network(crypto['image'], width: 50, height: 50),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crypto['name'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Price: \$${crypto['current_price']}'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CryptoChart(priceData: crypto['sparkline_in_7d']['price']),
            ),
          ),
        ],
      ),
    );
  }
}
