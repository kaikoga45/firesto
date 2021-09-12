import 'dart:io';

import 'package:firesto/common/constant.dart';
import 'package:firesto/common/styles.dart';
import 'package:firesto/data/api/api_service.dart';
import 'package:firesto/data/model/restaurant.dart';
import 'package:firesto/provider/database_provider.dart';
import 'package:firesto/provider/detail_restaurant_provider.dart';
import 'package:firesto/provider/preferences_provider.dart';
import 'package:firesto/widgets/display_info.dart';
import 'package:firesto/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

final FocusNode _focusNode = FocusNode();

class DetailPage extends StatefulWidget {
  static const String id = '/detail_page';

  final String restaurantId;

  const DetailPage({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    Provider.of<DetailRestaurantProvider>(context, listen: false)
        .fetchDetailRestaurant(id: widget.restaurantId);
    super.initState();
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Detail',
        ),
      ),
      child: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  SafeArea _buildBody(BuildContext context) {
    final TextTheme _textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Consumer<DetailRestaurantProvider>(
        builder: (BuildContext context,
            DetailRestaurantProvider detailRestaurantProvider, _) {
          if (detailRestaurantProvider.state == ResultState.loading) {
            return DisplayInfo(
              textTheme: _textTheme,
              lottiePath: 'assets/lottie/wait.json',
              title: 'Mohon Menunggu',
              description:
                  'Firesto sedang mempersiapkan informasi restoran untuk anda!',
            );
          } else if (detailRestaurantProvider.state == ResultState.hasData) {
            final DetailRestaurant data = detailRestaurantProvider.result;
            final bool isDarkTheme =
                Provider.of<PreferencesProvider>(context).isDarkTheme;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FadeInImage.assetNetwork(
                        imageErrorBuilder:
                            (BuildContext context, Object object, _) {
                          return const Placeholder(
                            fallbackHeight: 300,
                            fallbackWidth: double.infinity,
                            color: Colors.red,
                          );
                        },
                        placeholder: 'assets/placeholder/grey.png',
                        image: kUrlRestoPict + data.pictureId!,
                        fit: BoxFit.cover,
                        fadeInCurve: Curves.bounceIn,
                        fadeOutCurve: Curves.bounceOut,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        data.name ?? 'Null',
                        style: _textTheme.headline5,
                      ),
                      const Spacer(),
                      Material(
                        child: Consumer<DatabaseProvider>(
                          builder: (BuildContext context,
                              DatabaseProvider databaseProvider, _) {
                            return FutureBuilder<bool>(
                              future: databaseProvider.isFavorite(
                                  detailRestaurantProvider.result.id!),
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> isFavorite) {
                                if (isFavorite.hasData) {
                                  if (isFavorite.data!) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Ink(
                                        color: isDarkTheme
                                            ? kDarkPrimaryColor
                                            : kPrimaryColor,
                                        child: IconButton(
                                          onPressed: () {
                                            databaseProvider.removeFavorite(
                                              detailRestaurantProvider
                                                  .result.id!,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Ink(
                                        color: isDarkTheme
                                            ? kDarkPrimaryColor
                                            : kPrimaryColor,
                                        child: IconButton(
                                          onPressed: () {
                                            final DetailRestaurant detail =
                                                detailRestaurantProvider.result;
                                            databaseProvider.addFavorite(
                                              Restaurants(
                                                id: detail.id,
                                                pictureId: detail.pictureId!,
                                                name: detail.name,
                                                description: detail.description,
                                                city: detail.city,
                                                rating: detail.rating,
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.favorite_border,
                                            color: isDarkTheme
                                                ? kPrimaryColor
                                                : kDarkPrimaryColor,
                                          ),
                                        ),
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
                        ),
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
                            ? CupertinoIcons.location
                            : Icons.location_on,
                        color: isDarkTheme
                            ? kPrimaryColor.withOpacity(0.60)
                            : kDarkPrimaryColor.withOpacity(0.60),
                        size: 15,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        data.city ?? 'Null',
                        style: _textTheme.caption,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Platform.isIOS ? CupertinoIcons.star_fill : Icons.star,
                        color: const Color(0xFFEDB703).withOpacity(0.80),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '${data.rating ?? 'N/A'}',
                        style: _textTheme.overline,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AnimatedSize(
                    vsync: this,
                    duration: const Duration(milliseconds: 500),
                    child: ReadMoreText(
                      data.description ?? 'Null',
                      colorClickableText: Colors.pink,
                      trimLines: 5,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: _textTheme.bodyText1,
                      moreStyle: _textTheme.button,
                      lessStyle: _textTheme.button,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Ulasan',
                        style: _textTheme.subtitle1,
                      ),
                      Material(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Ink(
                            color:
                                isDarkTheme ? kDarkPrimaryColor : kPrimaryColor,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                showModalBottomSheet<void>(
                                  enableDrag: false,
                                  context: context,
                                  builder:
                                      (BuildContext contextModalBottomSheet) {
                                    return Container(
                                      height:
                                          MediaQuery.of(contextModalBottomSheet)
                                                  .size
                                                  .height *
                                              0.50,
                                      color: Colors.white,
                                      child: KeyboardActions(
                                        config: _buildConfig(
                                            contextModalBottomSheet),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    'Tambah Ulasan',
                                                    style: _textTheme.subtitle1,
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextField(
                                                    controller: _controller,
                                                    focusNode: _focusNode,
                                                    minLines: 1,
                                                    maxLines: 7,
                                                    cursorColor:
                                                        kSecondaryColor,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      fillColor: const Color(
                                                          0xFFf1f1f1),
                                                      filled: true,
                                                      hintText:
                                                          'Ulasan saya tentang restoran ini...',
                                                      hintStyle: textTheme
                                                          .subtitle1!
                                                          .apply(
                                                        color: const Color(
                                                          0xFFa6a6a6,
                                                        ),
                                                      ),
                                                      border:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize: const Size(
                                                      double.infinity,
                                                      50,
                                                    ),
                                                    primary: kDarkPrimaryColor,
                                                  ),
                                                  onPressed: () {
                                                    ApiService(http.Client())
                                                        .postRestaurantReview(
                                                            id: data.id!,
                                                            review: _controller
                                                                .text)
                                                        .then(
                                                      (_) {
                                                        Provider.of<DetailRestaurantProvider>(
                                                                context,
                                                                listen: false)
                                                            .fetchDetailRestaurant(
                                                                id: widget
                                                                    .restaurantId);
                                                        _controller.clear();
                                                        Navigator.pop(
                                                          contextModalBottomSheet,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    'Submit',
                                                    style: _textTheme.button!
                                                        .apply(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: SizedBox(
                                height: 42,
                                width: 42,
                                child: Icon(
                                  Icons.add,
                                  color: isDarkTheme
                                      ? kPrimaryColor
                                      : kDarkPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int item) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: data.customerReviews?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 200,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color(0xFF141921)
                                : kPrimaryColor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: kSecondaryColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data.customerReviews?[index].name ?? 'Null',
                                    style: _textTheme.subtitle2,
                                  ),
                                  Text(
                                    data.customerReviews?[index].review ??
                                        'Null',
                                    style: _textTheme.bodyText2,
                                    maxLines: 5,
                                  ),
                                ],
                              ),
                              Text(
                                data.customerReviews?[index].date ?? 'Null',
                                textAlign: TextAlign.right,
                                style: _textTheme.caption,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Menu Makanan',
                    style: _textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, _) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: data.menus?.foods?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 100,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color(0xFF141921)
                                : kPrimaryColor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: kSecondaryColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                data.menus?.foods?[index].name ?? 'Null',
                                style: _textTheme.subtitle2,
                              ),
                              Text(
                                '${index + 1}',
                                textAlign: TextAlign.right,
                                style: _textTheme.headline2!.apply(
                                  color: isDarkTheme
                                      ? kPrimaryColor.withOpacity(0.10)
                                      : kDarkPrimaryColor.withOpacity(0.10),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Menu Minuman',
                    style: _textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 137,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, _) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: data.menus?.drinks?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 100,
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkTheme
                                ? const Color(0xFF141921)
                                : kPrimaryColor,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: kSecondaryColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                data.menus?.drinks?[index].name ?? 'Null',
                                style: _textTheme.subtitle2,
                              ),
                              Text(
                                '${index + 1}',
                                textAlign: TextAlign.right,
                                style: _textTheme.headline2!.apply(
                                  color: isDarkTheme
                                      ? kPrimaryColor.withOpacity(0.10)
                                      : kDarkPrimaryColor.withOpacity(0.10),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (detailRestaurantProvider.state == ResultState.noData) {
            return DisplayInfo(
              textTheme: textTheme,
              lottiePath: 'assets/lottie/not-found.json',
              title: 'Maafkan Firesto :(',
              description:
                  'Firesto tidak bisa menemukan detail restorannya. Sebentar coba lagi!',
            );
          } else if (detailRestaurantProvider.state == ResultState.noInternet) {
            return DisplayInfo(
              textTheme: textTheme,
              lottiePath: 'assets/lottie/no-internet-connection.json',
              title: 'Ooops',
              description: detailRestaurantProvider.message,
            );
          } else if (detailRestaurantProvider.state == ResultState.error) {
            return DisplayInfo(
              textTheme: textTheme,
              lottiePath: 'assets/lottie/error.json',
              title: 'Error',
              description: detailRestaurantProvider.message,
            );
          } else {
            return DisplayInfo(
              textTheme: textTheme,
              lottiePath: 'assets/lottie/404.json',
              title: 'Halaman detail tidak ditemukan',
              description: 'Tolong kembali untuk mencoba lagi!',
            );
          }
        },
      ),
    );
  }
}

KeyboardActionsConfig _buildConfig(BuildContext context) {
  return KeyboardActionsConfig(
    actions: <KeyboardActionsItem>[
      KeyboardActionsItem(focusNode: _focusNode),
    ],
  );
}
