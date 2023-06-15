import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  static const String id = '/price_screen';

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(
          currency,
          style: const TextStyle(color: Colors.lightBlue),
        ),
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton(
      iconEnabledColor: Colors.lightBlue,
      iconDisabledColor: Colors.lightBlue,
      dropdownColor: Colors.white,
      focusColor: Colors.lightBlue,
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(
        currency,
        style: const TextStyle(color: Color(0xff21EBA6)),
      ));
    }
    return CupertinoPicker(
      backgroundColor: Colors.transparent,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      debugPrint(e.toString());
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
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: isWaiting
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          isWaiting
              ? const Expanded(
                  child: Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Column(
                  children: [
                    CryptoCard(
                      cryptoCurrency: 'BTC',
                      value: coinValues['BTC']!,
                      selectedCurrency: selectedCurrency,
                    ),
                    CryptoCard(
                      cryptoCurrency: 'ETH',
                      value: coinValues['ETH']!,
                      selectedCurrency: selectedCurrency,
                    ),
                    CryptoCard(
                      cryptoCurrency: 'LTC',
                      value: coinValues['LTC']!,
                      selectedCurrency: selectedCurrency,
                    ),
                  ],
                ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0, top: 10.0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 2.0, color: Colors.lightBlue),
              ),
            ),
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      title: Text(
        '1 $cryptoCurrency = $value $selectedCurrency',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
