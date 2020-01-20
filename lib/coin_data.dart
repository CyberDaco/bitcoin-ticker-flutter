import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

String apiKey = 'N2I2OGUzMmQxZjVkNDQzNGI2ZTVlZTAwZmYzMjg5OTA';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData({@required currency}) async {
    const baseUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      String url = '$baseUrl/$crypto$currency';
      http.Response response =
          await http.get(url, headers: {'x-ba-key': '$apiKey'});
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['last'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print('ERR: Status Code of ${response.statusCode}');
      }
    }
    return cryptoPrices;
  }
}
