import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:term_project/model/book_model.dart';
import 'package:term_project/pages/BookDetailPage.dart';
import 'package:term_project/pages/onBoarding.dart';

import 'package:term_project/services/book_api.dart';
import 'package:term_project/widgets/firebase_services.dart';

import 'package:provider/provider.dart';

import '../Provider/TodoProvider.dart';
import '../widgets/BookGridViewWidget.dart';
import '../widgets/search.dart';

class BookPage extends StatefulWidget {
  static const routeName = '/bookList-page';
  BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  late Future<List<BookModel>> bookListFuture;
  late ScrollController scrollController;
  late ScrollController scrollController2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    scrollController2 = ScrollController();
    bookListFuture = BookApi.getBookData();
  }

  int current = 0;
  List<String> items = [
    'Fantasy',
    'Philosophy',
    'Psychology',
    'Horror',
    'Dystopian',
    'Biography',
    'Science Fiction',
    'Mystery',
    'Thriller',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.list,
          color: Color.fromARGB(255, 53, 83, 88),
        ),
        centerTitle: true,
        title: Text(
          "BookBud",
          style: GoogleFonts.bebasNeue(
              fontSize: 40, color: const Color.fromARGB(255, 53, 83, 88)),
        ),
        actions: [
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
              _firebaseServices.SignOut();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 53, 83, 88),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Color.fromARGB(255, 53, 83, 88),
              ),
              onPressed: () {
                showSearch(context: context, delegate: SearchBook());
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            // ignore: sort_child_properties_last
            child: Column(children: [
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: Text(
                      "Recommended You",
                      style: GoogleFonts.ubuntu(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: BookGridViewWidget(
                  controller: scrollController,
                  bookListFuture: BookApi.getDataBygenre(q: "horror"),
                  provider: provider,
                ),
              ),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(10, 53, 83, 88),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                current = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.all(5),
                              width: 80,
                              height: 45,
                              decoration: BoxDecoration(
                                color: current == index
                                    ? Colors.white70
                                    : Colors.white54,
                                borderRadius: current == index
                                    ? BorderRadius.circular(15)
                                    : BorderRadius.circular(10),
                                border: current == index
                                    ? Border.all(
                                        color: Color.fromARGB(255, 53, 83, 88),
                                        width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  items[index],
                                  style: GoogleFonts.laila(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).brightness !=
                                              Brightness.dark
                                          ? current == index
                                              ? Colors.black
                                              : Colors.grey[600]
                                          : current == index
                                              ? Colors.black
                                              : Colors.white70),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: current == index,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 53, 83, 88),
                                    shape: BoxShape.circle),
                              ))
                        ],
                      );
                    }),
              ),
              const SizedBox(
                height: 30,
              ),
              BookGridViewWidget(
                  controller: scrollController2,
                  provider: provider,
                  bookListFuture: BookApi.getDataBygenre(q: items[current])),
            ]),
            //color: Colors.white,
          ),
        ],
      )),
    );
  }
}
