import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/categories_news_model.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {
  bbcNews,
  aryNews,
  independent,
  reuters,
  cnn,
  alJazeera,
  cbsNews
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final dateFormat = DateFormat('MMMM dd, yyyy');
  FilterList? selectedMenu;
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesScreen()));
            },
            icon: Image.asset(
              'images/category_icon.png',
              height: 30,
              width: 30,
            )),
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              onSelected: (FilterList item) {
                if (FilterList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                } else if (FilterList.aryNews.name == item.name) {
                  name = 'ary-news';
                } else if (FilterList.alJazeera.name == item.name) {
                  name = 'al-jazeera-english';
                } else if (FilterList.cbsNews.name == item.name) {
                  name = 'cbs-news';
                }
                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (context) => <PopupMenuItem<FilterList>>[
                    const PopupMenuItem(
                        value: FilterList.bbcNews, child: Text('BBC News')),
                    const PopupMenuItem(
                        value: FilterList.aryNews, child: Text('Ary News')),
                    const PopupMenuItem(
                        value: FilterList.alJazeera,
                        child: Text('Al Jazeera English')),
                    const PopupMenuItem(
                        value: FilterList.cbsNews, child: Text('CBS News'))
                  ]),
        ],
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(
            height: height * .62,
            width: width,
            child: FutureBuilder(
                future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
                builder: (BuildContext context, snapchat) {
                  if (snapchat.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        color: Colors.orange,
                        size: 40,
                      ),
                    );
                  } else {
                    return SizedBox(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapchat.data!.articles!.length,
                          itemBuilder: (context, index) {
                            DateTime datetime = DateTime.parse(snapchat
                                .data!.articles![index].publishedAt
                                .toString());
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsDetailScreen(
                                            newsImg: snapchat.data!
                                                .articles![index].urlToImage!
                                                .toString(),
                                            newsTitle: snapchat
                                                .data!.articles![index].title
                                                .toString(),
                                            newsDate: snapchat.data!
                                                .articles![index].publishedAt
                                                .toString(),
                                            author: snapchat
                                                .data!.articles![index].author
                                                .toString(),
                                            description: snapchat.data!
                                                .articles![index].description
                                                .toString(),
                                            content:
                                                snapchat.data!.articles![index].content.toString(),
                                            source: snapchat.data!.articles![index].source!.name.toString())));
                              },
                              child: SizedBox(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * .02),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: snapchat
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          width: width * .965,
                                          height: height * 1,
                                          placeholder: (context, url) =>
                                              Container(
                                            child: spinKit2,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      child: SizedBox(
                                        height: height * 0.20,
                                        child: Card(
                                          elevation: 5,
                                          color: Colors.black12,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: width * 0.9,
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Text(
                                                  snapchat.data!
                                                      .articles![index].title
                                                      .toString(),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              // const Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                width: width * 0.9,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapchat
                                                          .data!
                                                          .articles![index]
                                                          .author
                                                          .toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    Text(
                                                      dateFormat
                                                          .format(datetime),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi('General'),
                builder: (BuildContext context, snapchat) {
                  if (snapchat.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        color: Colors.orange,
                        size: 40,
                      ),
                    );
                  } else {
                    return SizedBox(
                      child: ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapchat.data!.articles!.length,
                          itemBuilder: (context, index) {
                            DateTime datetime = DateTime.parse(snapchat
                                .data!.articles![index].publishedAt
                                .toString());
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: snapchat
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      width: width * .3,
                                      height: height * .18,
                                      placeholder: (context, url) => Container(
                                        child: spinKit2,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: height * .18,
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapchat.data!.articles![index].title
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapchat.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              dateFormat.format(datetime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 9,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            );
                          }),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.orange,
  size: 40,
);
