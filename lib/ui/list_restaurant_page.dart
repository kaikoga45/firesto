import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/common/styles.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:firesto/provider/database_provider.dart';
import 'package:firesto/provider/list_restaurant_provider.dart';
import 'package:firesto/ui/detail_page.dart';
import 'package:firesto/ui/search_page.dart';
import 'package:firesto/widgets/display_info.dart';
import 'package:firesto/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ListRestaurantPage extends StatelessWidget {
  const ListRestaurantPage({
    Key? key,
  }) : super(key: key);

  Widget androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/profile/kai.jpg'),
          ),
        ),
        title: const Text('Hi, Kai!'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.id);
              },
              icon: const Icon(Icons.search_outlined),
            ),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/profile/kai.jpg'),
          ),
        ),
        middle: const Text('Hi, Kai!'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.id);
            },
            icon: const Icon(Icons.search_outlined),
          ),
        ),
      ),
      child: _buildBody(context),
    );
  }

  SafeArea _buildBody(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Firesto',
              style: textTheme.headline2,
            ),
            Text(
              'Temukan restoran terdekat anda!',
              style: textTheme.subtitle1,
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<ListRestaurantProvider>(builder: (BuildContext context,
                ListRestaurantProvider lisRestaurantProvider, _) {
              if (lisRestaurantProvider.state == ResultState.loading) {
                return DisplayInfo(
                  textTheme: textTheme,
                  lottiePath: 'assets/lottie/wait.json',
                  title: 'Mohon Menunggu',
                  description:
                      'Firesto sedang mempersiapkan daftar restoran untuk anda!',
                );
              } else if (lisRestaurantProvider.state == ResultState.hasData) {
                return Expanded(
                  child: SizedBox(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount: lisRestaurantProvider.result.count,
                      itemBuilder: (BuildContext context, int index) {
                        final Restaurants restaurant =
                            lisRestaurantProvider.result.restaurants![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              DetailPage.id,
                              arguments: restaurant.id ?? '',
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    kSecondaryColor.withOpacity(0.5),
                                    BlendMode.srcOver,
                                  ),
                                  child: FadeInImage.assetNetwork(
                                    imageErrorBuilder: (BuildContext context,
                                        Object object, _) {
                                      return const Placeholder(
                                        fallbackHeight: 150,
                                        fallbackWidth: 80,
                                        color: Colors.red,
                                      );
                                    },
                                    placeholder: 'assets/placeholder/grey.png',
                                    image: kUrlRestoPict + restaurant.pictureId,
                                    fadeInCurve: Curves.bounceIn,
                                    fadeOutCurve: Curves.bounceOut,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: _buildFavoriteButton(restaurant),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
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
                                              "${restaurant.rating ?? 'N/A'}",
                                              style: textTheme.overline!.apply(
                                                color: kPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          restaurant.name ?? 'Null',
                                          style: textTheme.subtitle2!.apply(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Platform.isIOS
                                                  ? CupertinoIcons.location
                                                  : Icons.location_on,
                                              color: kPrimaryColor
                                                  .withOpacity(0.60),
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              restaurant.city ?? 'Null',
                                              style: textTheme.caption!
                                                  .apply(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      staggeredTileBuilder: (int index) =>
                          const StaggeredTile.fit(1),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                    ),
                  ),
                );
              } else if (lisRestaurantProvider.state == ResultState.noData) {
                return DisplayInfo(
                  textTheme: textTheme,
                  lottiePath: 'assets/lottie/not-found.json',
                  title: 'Maafkan Firesto :(',
                  description:
                      'Firesto tidak memiliki daftar restoran untuk ditampilkan!',
                );
              } else if (lisRestaurantProvider.state ==
                  ResultState.noInternet) {
                return DisplayInfo(
                  textTheme: textTheme,
                  lottiePath: 'assets/lottie/no-internet-connection.json',
                  title: 'Ooops',
                  description: lisRestaurantProvider.message,
                );
              } else if (lisRestaurantProvider.state == ResultState.error) {
                return DisplayInfo(
                  textTheme: textTheme,
                  lottiePath: 'assets/lottie/error.json',
                  title: 'Error',
                  description: lisRestaurantProvider.message,
                );
              } else {
                return DisplayInfo(
                  textTheme: textTheme,
                  lottiePath: 'assets/lottie/404.json',
                  title: 'Halaman beranda tidak ditemukan',
                  description:
                      'Tolong tutup dan buka kembali firesto untuk mengatasi lagi!',
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Consumer<DatabaseProvider> _buildFavoriteButton(Restaurants restaurant) {
    return Consumer<DatabaseProvider>(
      builder: (BuildContext context, DatabaseProvider databaseProvider, _) {
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
