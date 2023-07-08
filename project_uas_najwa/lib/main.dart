import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_uas_najwa/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Media',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<dynamic> techData = [];
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future fetchData() async {
    final response = await http.get(Uri.parse(
        'https://the-lazy-media-api.vercel.app/api/tech?page=$currentPage'));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      List<News> news =
          parsed.map<News>((json) => News.fromJson(json)).toList();
      return news;
    } else {
      throw Exception('Failed to load data');
    }
  }

  getData() async {
    List<News> news = await fetchData();
    setState(() {
      techData = news;
    });
  }

  void changePage(int page) {
    setState(() {
      currentPage = page;
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News Media'),
          backgroundColor: Colors.purple[400],
        ),
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Image.network(
                  "https://akcdn.detik.net.id/community/media/visual/2023/01/18/ilustrasi-magang-kampus-merdeka-2_169.jpeg?w=700&q=90.jpg",
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              // )),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Card(
                          // color: Colors.amberAccent,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            title: Text(
                              techData[index].title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  techData[index].desc,
                                  maxLines: 10,
                                  // textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Author: ${techData[index].author}',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      ' - ${techData[index].time}',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ));
                    },
                    childCount: techData.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: currentPage > 1
                            ? () => {
                                  techData.clear(),
                                  changePage(currentPage - 1),
                                  Colors.transparent
                                }
                            : null,
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Previous',
                        // color: Colors.black,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      IconButton(
                        onPressed: () => {
                          techData.clear(),
                          changePage(currentPage + 1),
                          Colors.transparent
                        },
                        icon: const Icon(Icons.arrow_forward),
                        tooltip: 'Next',
                        // color: Colors.black,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
