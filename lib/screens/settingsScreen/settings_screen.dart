import 'package:auto_flutter/screens/widgets/app_bar_subtitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось открыть ссылку: $url')),
      );
    }
  }

  void _rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(
        appStoreId: 'YOUR_APP_STORE_ID', 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Настройки',
        subtitle: 'Мои автомобили',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                _launchURL(context, 'https://your_privacy_policy_url.com');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Политика конфиденциальности',
                    style: AutoTextStyles.h3,
                  ),
                  SvgPicture.asset(
                    'assets/img/svg/chevron.forward.svg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            TextButton(
              onPressed: () {
                _launchURL(context, 'https://your_user_agreement_url.com');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Пользовательское соглашение',
                    style: AutoTextStyles.h3,
                  ),
                  SvgPicture.asset(
                    'assets/img/svg/chevron.forward.svg',
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Оценить приложение',
              onPressed: _rateApp,
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}