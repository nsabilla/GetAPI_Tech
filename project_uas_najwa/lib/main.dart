// import paket
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_uas_najwa/model.dart';

// method void sebagai titik masuk untuk aplikasi Flutter, lalu runApp() digunakan untuk menjalankan aplikasi Flutter dengan menginisialisasi MyApp
void main() => runApp(MyApp());

// class MyApp adalah class main 
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

// class HomePage adalah class yang mewakili class main
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState(); // class HomePageState adalah class yang memegang keadaan halaman dan mengatur perubahan-perubahan itu
}

class HomePageState extends State<HomePage> {
  List<dynamic> techData = [];
  int currentPage = 1;

// method initState merupakan method dalam class HomePageState yang dipanggil ketika halaman dipasang untuk pertama kalinya
  @override
  void initState() {
    super.initState();
    // method getData dipanggil untuk memperoleh data berita teknologi
    getData();
  }

// fetchdata digunakan untuk melakukan permintaan HTTP dan URL tertentu
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

  // method getData digunakan untuk memeproleh data berita dengan memanggil method fetchData()
  getData() async {
    List<News> news = await fetchData();
    // setelah data diperoleh, method setState dipanggil untuk memperbarui keadaan halaman dengan data yang diperoleh
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
                sliver: SliverList( // salah satu widget dalam CustomScrollView
                  delegate: SliverChildBuilderDelegate( // SliverChildBuilderDelegate digunakan untuk membangun daftar item sesuai dengan panjang techData. Setiap item menggunakan widget Card dan ListTile untuk menampilkan informasi berita
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
                      IconButton( // IconButton untuk tombol yang mengandung icon yang merespon sentuhan. Tombol ini digunakan untuk berpindah ke halam sebelumnya dengan mengurangi nomor halaman saat diklik
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
