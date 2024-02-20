
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String? newsImg, newsTitle, newsDate, author, description, content, source;
  NewsDetailScreen({super.key, required this.newsImg, required this.newsTitle, required this.newsDate, required this.author,
  required this.description, required this.content, required this.source});
  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final dateFormat = DateFormat('MMMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    DateTime dateTime = DateTime.parse(widget.newsDate!);
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: height*.45,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: CachedNetworkImage (imageUrl: widget.newsImg ?? '',
               fit: BoxFit.cover,
               placeholder: (context, url) => const Center( child: CircularProgressIndicator()),
               errorWidget: (context, error, url) => const Icon(Icons.error, color: Colors.red,),
              ),
            ),
          ),
          Container(
            height: height *.6,
            decoration: const BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),),
            margin: EdgeInsets.only(top: height*.37),
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: ListView(
              children: [
                // Text('News Title:', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),),
                Text(widget.newsTitle!, style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w700 ),),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(child: Text(widget.source!, style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w500 ),)),
                  ],
                ),
                const SizedBox(height: 10,),
                Text(widget.content!, style: GoogleFonts.poppins(fontSize: 15 ),),
                const SizedBox(height: 5,),
                Text(widget.description!, style: GoogleFonts.poppins(fontSize: 15 ),),
                const SizedBox(height: 5,),
                Text(dateFormat.format(dateTime), style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500 ),),
              ]
            ),
          )
        ],
      ),
    );
  }
}
