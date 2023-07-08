class News {
  final String thumb;
  final String title;
  final String desc;
  final String time;
  final String author;

  News(
      {required this.thumb,
      required this.title,
      required this.desc,
      required this.time,
      required this.author});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      thumb: json["thumb"] ?? "",
      title: json["title"] ?? "",
      desc: json["desc"] ?? "",
      time: json["time"] ?? "",
      author: json["author"] ?? "",
    );
  }
}