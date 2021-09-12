import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/common/styles.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:firesto/provider/preferences_provider.dart';
import 'package:firesto/provider/search_restaurant_provider.dart';
import 'package:firesto/ui/detail_page.dart';
import 'package:firesto/widgets/display_info.dart';
import 'package:firesto/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const String id = '/search_page';

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Pencarian',
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Pencarian',
        ),
      ),
      child: _buildBody(context),
    );
  }

  SafeArea _buildBody(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDarkTheme =
        Provider.of<PreferencesProvider>(context).isDarkTheme;
    return SafeArea(
      child: Material(
        color: isDarkTheme ? kDarkPrimaryColor : kPrimaryColor,
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  cursorColor: kSecondaryColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    fillColor: isDarkTheme
                        ? const Color(0xFF141921)
                        : const Color(0xFFf1f1f1),
                    filled: true,
                    prefixIcon: Icon(
                      Platform.isIOS
                          ? CupertinoIcons.search
                          : Icons.search_outlined,
                      color: const Color(0xFFa6a6a6),
                    ),
                    hintText: 'Saya ingin mencari restoran...',
                    hintStyle: textTheme.subtitle1!.apply(
                      color: const Color(0xFFa6a6a6),
                    ),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (String query) {
                    Provider.of<SearchRestaurantProvider>(context,
                            listen: false)
                        .fetchSearchRestaurant(query);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<SearchRestaurantProvider>(
                  builder:
                      (BuildContext context, SearchRestaurantProvider data, _) {
                    if (data.state == ResultState.loading) {
                      return DisplayInfo(
                        textTheme: textTheme,
                        lottiePath: 'assets/lottie/search-loading.json',
                        title: 'Tolong Menunggu',
                        description:
                            'Firesto sedang mencari restoran yang anda inginkan!',
                      );
                    } else if (data.state == ResultState.hasData) {
                      final List<Restaurants>? listRestaurant =
                          data.result.restaurants;
                      return Expanded(
                        child: SizedBox(
                          child: ListView.separated(
                            separatorBuilder: (BuildContext context, _) {
                              return const SizedBox(
                                height: 5,
                              );
                            },
                            itemCount: listRestaurant?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              final Restaurants restaurant =
                                  listRestaurant![index];
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    DetailPage.id,
                                    arguments: restaurant.id,
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  kSecondaryColor
                                                      .withOpacity(0.5),
                                                  BlendMode.srcOver,
                                                ),
                                                child: SizedBox(
                                                  width: 90,
                                                  height: 90,
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    fit: BoxFit.cover,
                                                    imageErrorBuilder:
                                                        (BuildContext context,
                                                            Object object,
                                                            StackTrace? _) {
                                                      return const Placeholder(
                                                        fallbackHeight: 90,
                                                        fallbackWidth: 90,
                                                        color: Colors.red,
                                                      );
                                                    },
                                                    placeholder:
                                                        'assets/placeholder/grey.png',
                                                    image: kUrlRestoPict +
                                                        restaurant.pictureId,
                                                    fadeInCurve:
                                                        Curves.bounceIn,
                                                    fadeOutCurve:
                                                        Curves.bounceOut,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10,
                                                top: 5,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Platform.isIOS
                                                        ? CupertinoIcons
                                                            .star_fill
                                                        : Icons.star,
                                                    color:
                                                        const Color(0xFFEDB703)
                                                            .withOpacity(0.80),
                                                    size: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    "${restaurant.rating ?? 'N/A'}",
                                                    style: textTheme.overline!
                                                        .apply(
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  restaurant.name ?? 'Null',
                                                  style: textTheme.subtitle1,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Platform.isIOS
                                                          ? CupertinoIcons
                                                              .location
                                                          : Icons.location_on,
                                                      size: 20,
                                                      color: kSecondaryColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      restaurant.city ?? 'Null',
                                                      style:
                                                          textTheme.bodyText1,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  restaurant.description ??
                                                      'Null',
                                                  style: textTheme.bodyText2,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.justify,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (data.state == ResultState.noData) {
                      return DisplayInfo(
                        textTheme: textTheme,
                        lottiePath: 'assets/lottie/not-found.json',
                        title: 'Maafkan Kami',
                        description:
                            'Firesto tidak menemukan restoran yang anda inginkan!',
                      );
                    } else if (data.state == ResultState.noInternet) {
                      return DisplayInfo(
                        textTheme: textTheme,
                        lottiePath: 'assets/lottie/no-internet-connection.json',
                        title: 'Ooops',
                        description: data.message,
                      );
                    } else if (data.state == ResultState.error) {
                      return DisplayInfo(
                        textTheme: textTheme,
                        lottiePath: 'assets/lottie/error.json',
                        title: 'Error',
                        description: data.message,
                      );
                    } else if (data.state == ResultState.standBy) {
                      return DisplayInfo(
                        textTheme: textTheme,
                        lottiePath: 'assets/lottie/search-standby.json',
                        title: 'Apa yang kamu ingin carikan?',
                        description:
                            'Cari restoran favorit Anda atau temukan hasil serupa di area dekat anda.',
                      );
                    } else {
                      return DisplayInfo(
                        textTheme: textTheme,
                        lottiePath: 'assets/lottie/404.json',
                        title: 'Halaman pencarian tidak ditemukan',
                        description: 'Tolong kembali untuk mencoba lagi!',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
