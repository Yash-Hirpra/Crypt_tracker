import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/crypto_detail_screen.dart';

void main() {
  runApp(CryptoTrackerApp());
}

class CryptoTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // System-based dark mode
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: CryptoListScreen(),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  List<dynamic> _cryptoData = [];
  List<dynamic> _filteredCryptoData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCryptoPrices();
    _setupAutoRefresh();
  }

  void _setupAutoRefresh() {
    Future.delayed(Duration(seconds: 30), () {
      if (mounted) {
        _fetchCryptoPrices();
        _setupAutoRefresh();
      }
    });
  }

  Future<void> _fetchCryptoPrices() async {
    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=true');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _cryptoData = json.decode(response.body);
          _filteredCryptoData = _cryptoData;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _filterCryptos(String query) {
    setState(() {
      _filteredCryptoData = _cryptoData
          .where((crypto) =>
              crypto['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto Price Tracker')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCryptos,
              decoration: InputDecoration(
                labelText: 'Search Cryptos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _cryptoData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredCryptoData.length,
                    itemBuilder: (context, index) {
                      final crypto = _filteredCryptoData[index];
                      return ListTile(
                        leading: Image.network(crypto['image'],
                            width: 40, height: 40),
                        title: Text(crypto['name']),
                        subtitle: Text(
                            'Price: \$${crypto['current_price'].toStringAsFixed(2)}'),
                        trailing: Text(
                          '${crypto['price_change_percentage_24h'].toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: crypto['price_change_percentage_24h'] >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CryptoDetailScreen(crypto: crypto),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
