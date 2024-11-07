import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finance_digest/constants/app_colors.dart';
import 'package:finance_digest/constants/app_fonts.dart';
import 'package:finance_digest/constants/app_text.dart';
import 'package:finance_digest/services/database_service.dart';
import 'package:finance_digest/utils/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/news.dart';
import '../../../models/user.dart';
import '../../../utils/api.dart';
import '../../../utils/widgets/custom_loader.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = false;
  bool _isError = false;
  late List<News> newsList;
  var format = DateFormat('dd MMMM yyyy');
  late User user;

  @override
  void initState() {
    getUserData();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CustomLoader()
        : Scaffold(
            backgroundColor: AppColors.colorBlack,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.colorBlack,
              elevation: 0,
              title: Text('Hey ${user.firstName}', style: const TextStyle(fontFamily: AppFonts.fontBold, fontSize: AppFonts.textSizeLarge, color: AppColors.colorWhite)),
            ),
            body: _isError
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(AppText.apiError, style: TextStyle(fontFamily: AppFonts.fontMedium, color: AppColors.colorWhite, fontSize: AppFonts.textSizeMedium)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: newsList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      News article = newsList[index];

                      return GestureDetector(
                        onTap: () => launch(Uri.parse(newsList[index].url)),
                        child: buildArticle(article),
                      );
                    }),
          );
  }

  // getting the news list from api
  void getData() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    Network().getData('category=general').then((response) {
      newsList = List<News>.from(jsonDecode(response.body).map((article) => News.fromJson(article)));
      setState(() {
        _isLoading = false;
        _isError = false;
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
        _isError = true;
        newsList = [];
      });
      showToast(msg: error.toString(), backGroundColor: AppColors.errorColor);
    });
  }

  // viewing the news article
  void launch(Uri uri) async {
    try {
      bool canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } else {
        showToast(msg: 'Unable to open the article. Please try again later.', backGroundColor: AppColors.errorColor);
      }
    } catch (e) {
      log('Error launching URL: $e');
      showToast(msg: 'An error occurred while trying to open the article.', backGroundColor: AppColors.errorColor);
    }
  }

  // getting the user data from db to display the welcome message
  getUserData() async {
    const storage = FlutterSecureStorage();
    var userId = await storage.read(key: 'userId');
    DatabaseService db = DatabaseService();

    var value = await db.getUser(int.parse(userId!));
    user = User.fromJson(value?[0]);
  }

  buildArticle(News article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildArticleImage(article.image),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Row(children: [buildArticleSource(article.source!), const Spacer(), buildArticleDate(article.datetime)]),
                const SizedBox(height: 6),
                buildArticleHeadline(article.headline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildArticleImage(String image) {
    return SizedBox(
      width: 90,
      height: 90,
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(color: AppColors.colorWhite, image: DecorationImage(image: imageProvider, fit: BoxFit.fill))),
        placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: AppColors.buttonColor)),
        errorWidget: (context, url, error) => const Icon(Icons.error, size: 24, color: AppColors.errorColor),
      ),
    );
  }

  buildArticleSource(Source source) {
    return Text(source.name.toUpperCase().replaceAll('_', ' '), style: const TextStyle(fontSize: 11, fontFamily: AppFonts.fontMedium, color: AppColors.textGrey));
  }

  buildArticleDate(int date) {
    return Text(format.format(DateTime.fromMillisecondsSinceEpoch(date * 1000)).toUpperCase(), style: const TextStyle(fontSize: 11, fontFamily: AppFonts.fontMedium, color: AppColors.textGrey));
  }

  buildArticleHeadline(String headline) {
    return Text(headline, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: AppFonts.fontBold, color: AppColors.colorWhite, fontSize: AppFonts.textSizeMedium));
  }
}
