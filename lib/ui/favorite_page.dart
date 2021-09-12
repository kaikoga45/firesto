import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/common/styles.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:firesto/provider/database_provider.dart';
import 'package:firesto/provider/internet_connection_provider.dart';
import 'package:firesto/provider/preferences_provider.dart';
import 'package:firesto/ui/detail_page.dart';
import 'package:firesto/widgets/display_info.dart';
import 'package:firesto/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  Widget androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
      ),
      body: _buildBody(context),
    );
  }

  Widget iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Favorit'),
      ),
      child: _buildBody(context),
    );
  }

  SafeArea _buildBody(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Consumer<DatabaseProvider>(builder:
            (BuildContext context, DatabaseProvider databaseProvider, _) {
          if (databaseProvider.state == ResultState.loading) {
            return DisplayInfo(
              textTheme: textTheme,
              lottiePath: 'assets/lottie/wait.json',
              title: 'Mohon Menunggu',
              description:
                  'Firesto sedang mempersiapkan daftar favorit restoran anda!',
            );
          } else if (databaseProvider.state == ResultState.hasData) {
            return Consumer<InternetConnectionProvider>(
              builder: (BuildContext context,
                  InternetConnectionProvider internetConnectionProvider, _) {
                if (internetConnectionProvider.state == ResultState.loading) {
                  return DisplayInfo(
                    textTheme: textTheme,
                    lottiePath: 'assets/lottie/wait-check-internet.json',
                    title: 'Mohon Menunggu',
                    description:
                        'Firesto sedang memeriksa koneksi internet anda!',
                  );
                } else if (internetConnectionProvider.state ==
                    ResultState.hasInternet) {
                  final bool isDarkTheme =
                      Provider.of<PreferencesProvider>(context).isDarkTheme;
                  return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final Restaurants restaurant =
                          databaseProvider.favorite[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, DetailPage.id,
                              arguments: restaurant.id);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          kSecondaryColor.withOpacity(0.5),
                                          BlendMode.srcOver,
                                        ),
                                        child: SizedBox(
                                          width: 90,
                                          height: 90,
                                          child: FadeInImage.assetNetwork(
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
                                            fadeInCurve: Curves.bounceIn,
                                            fadeOutCurve: Curves.bounceOut,
                                          ),
                                        ),
                                      ),
                                    ),
                                    _buildFavoriteButton(
                                      databaseProvider,
                                      restaurant,
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
                                                  ? CupertinoIcons.location
                                                  : Icons.location_on,
                                              color: isDarkTheme
                                                  ? kPrimaryColor
                                                      .withOpacity(0.60)
                                                  : kDarkPrimaryColor
                                                      .withOpacity(0.60),
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              restaurant.city ?? 'Null',
                                              style: textTheme.caption,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Platform.isIOS
                                                  ? CupertinoIcons.star_fill
                                                  : Icons.star,
                                              color: const Color(0xFFEDB703)
                                                  .withOpacity(0.80),
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              '${restaurant.rating ?? 'N/A'}',
                                              style: textTheme.overline,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          restaurant.description ?? 'Null',
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
                    separatorBuilder: (BuildContext context, _) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: databaseProvider.favorite.length,
                  );
                } else if (internetConnectionProvider.state ==
                    ResultState.noInternet) {
                  return DisplayInfo(
                    textTheme: textTheme,
                    lottiePath: 'assets/lottie/no-internet-connection.json',
                    title: 'Ooops',
                    description: internetConnectionProvider.message,
                  );
                } else {
                  return DisplayInfo(
                    textTheme: textTheme,
                    lottiePath: 'assets/lottie/error.json',
                    title: 'Error',
                    description: internetConnectionProvider.message,
                  );
                }
              },
            );
          } else if (databaseProvider.state == ResultState.noData) {
            return DisplayInfo(
              textTheme: textTheme,
              lottiePath: 'assets/lottie/empty-favorites.json',
              title: 'Belum Ada Favorit',
              description:
                  'Yuk mulai menjelajahi berbagai restoran yang firesto sediakan',
            );
          } else if (databaseProvider.state == ResultState.error) {
            return DisplayInfo(
              textTheme: textTheme,
              lottiePath: 'assets/lottie/error.json',
              title: 'Error',
              description: databaseProvider.message,
            );
          } else {
            return DisplayInfo(
              textTheme: textTheme,
              lottiePath: 'assets/lottie/404.json',
              title: 'Halaman favorit tidak ditemukan',
              description:
                  'Tolong tutup dan buka kembali firesto untuk mengatasi lagi!',
            );
          }
        }),
      ),
    );
  }

  FutureBuilder<bool> _buildFavoriteButton(
      DatabaseProvider databaseProvider, Restaurants restaurant) {
    return FutureBuilder<bool>(
      future: databaseProvider.isFavorite(restaurant.id!),
      builder: (BuildContext context, AsyncSnapshot<bool> isFavorite) {
        if (isFavorite.hasData) {
          if (isFavorite.data!) {
            return IconButton(
              onPressed: () {
                databaseProvider.removeFavorite(
                  restaurant.id!,
                );
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
            );
          } else {
            return IconButton(
              onPressed: () {
                databaseProvider.addFavorite(
                  restaurant,
                );
              },
              icon: const Icon(
                Icons.favorite_border,
                color: kPrimaryColor,
              ),
            );
          }
        } else {
          return const Padding(
            padding: EdgeInsets.only(
              left: 5,
              top: 5,
            ),
            child: SizedBox(
              height: 10,
              width: 10,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: androidBuilder,
      iosBuilder: iosBuilder,
    );
  }
}
