class News { // deklarasi class: class 'News' memiliki lima properti bertipe string
  // properti 
  final String thumb; // kata kunci bertipe string memiliki informasi thumb
  final String title; // kata kunci bertipe string memiliki informasi title
  final String desc; // kata kunci bertipe string memiliki informasi desc
  final String time; // kata kunci bertipe string memiliki informasi time
  final String author; // // kata kunci bertipe string memiliki informasi author

  News( // konstruktor 'News'
      // di dalam ini merupakan argumen untuk menginisialisasi properti diatas
      {required this.thumb,
      required this.title,
      required this.desc,
      required this.time,
      required this.author});

  factory News.fromJson(Map<String, dynamic> json) { // 'fromJson' untuk membuat objek News dari data yang diberikan dalam bentuk JSON
  // Metode ini mengambil argumen berupa Map<String, dynamic> json yang berisi data JSON yang akan diubah menjadi objek News
    return News(
      thumb: json["thumb"] ?? "",
      title: json["title"] ?? "",
      desc: json["desc"] ?? "",
      time: json["time"] ?? "",
      author: json["author"] ?? "",
    );
  }
}