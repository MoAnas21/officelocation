import 'package:flutter/material.dart';

const linkToMac = {
  "AC:23:3F:7A:78:D9":
      "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/mega-sale-color-splash-discount-promo-shop-ad-design-template-058c110edec5a0553002f74d981a55da_screen.jpg?ts=1567082668",
  "AC:23:3F:F6:70:00":
      "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/splash-colors-sale-ad-template-design-984cfabe7205e1657120571ecb2f5d4a_screen.jpg?ts=1569820087",
  "AC:23:3F:6F:B8:09":
      "https://as2.ftcdn.net/v2/jpg/02/02/17/69/1000_F_202176931_DMcJSueW4KClkQ2qsnSJ8MuJ7lBhMF5P.jpg"
};

const def =
    "https://as2.ftcdn.net/v2/jpg/02/02/17/69/1000_F_202176931_DMcJSueW4KClkQ2qsnSJ8MuJ7lBhMF5P.jpg";

class Advert extends StatelessWidget {
  final String macAd;
  const Advert({required this.macAd, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Image.network(linkToMac[macAd] ?? def),
      ),
    );
  }
}
