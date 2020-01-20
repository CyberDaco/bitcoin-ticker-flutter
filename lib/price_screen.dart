import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> cryptoPrices = {};
  bool loading = false;

  CupertinoPicker iOSPicker() {
    List<Center> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Center(
          child: Text(
            currency,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getData();
      },
      children: pickerItems,
      backgroundColor: Colors.lightBlue,
      looping: true,
    );
  }

  void getData() async {
    loading = true;
    try {
      var data = await CoinData().getCoinData(currency: selectedCurrency);
      loading = false;
      setState(() {
        cryptoPrices = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('🤑 Coin Ticker')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoCard(
                  crypto: 'BTC',
                  currency: selectedCurrency,
                  price: loading ? 'loading..' : cryptoPrices['BTC']),
              CryptoCard(
                  crypto: 'ETH',
                  currency: selectedCurrency,
                  price: loading ? 'loading..' : cryptoPrices['ETH']),
              CryptoCard(
                  crypto: 'LTC',
                  currency: selectedCurrency,
                  price: loading ? 'loading..' : cryptoPrices['LTC']),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iOSPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard(
      {@required this.price, @required this.currency, @required this.crypto});

  final String price;
  final String crypto;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $price $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
