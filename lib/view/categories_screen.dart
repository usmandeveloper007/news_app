
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/categories_news_model.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'home_screen.dart';
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final dateFormat = DateFormat('MMMM dd, yyyy');
  String categoryName = 'general';

  List<String> categoryList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      categoryName = categoryList[index].toString();
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoryList[index] ? Colors.orange[300] : Colors.orange[200],
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(child: Text(categoryList[index].toString(),
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400),)),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
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
                          itemCount: snapchat.data!.articles!.length,
                          itemBuilder: (context, index) {
                            DateTime datetime = DateTime.parse(snapchat.data!
                                .articles![index].publishedAt.toString());
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: snapchat.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      width: width * .3,
                                      height: height * .18,
                                      placeholder: (context, url) =>
                                          Container(child: spinKit2,),
                                      errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.error, color: Colors.red,),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        height: height *.18,
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Column(
                                          children: [
                                            Text(snapchat.data!.articles![index].title.toString(),
                                            style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w700),),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapchat.data!.articles![index].source!.name.toString(),
                                                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.black54,),),
                                                Text(dateFormat.format(datetime),
                                                  style: GoogleFonts.poppins(fontSize: 9, color: Colors.black54,),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            );
                          }),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
