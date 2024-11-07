import 'dart:convert';

class News {
  final Category category;
  final int datetime;
  final String headline;
  final int id;
  final String image;
  final String related;
  final Source? source;
  final String summary;
  final String url;

  News({
    required this.category,
    required this.datetime,
    required this.headline,
    required this.id,
    required this.image,
    required this.related,
    required this.source,
    required this.summary,
    required this.url,
  });

  factory News.fromRawJson(String str) => News.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory News.fromJson(Map<String, dynamic> json) => News(
        category: categoryValues.map[json["category"]]!,
        datetime: json["datetime"],
        headline: json["headline"],
        id: json["id"],
        image: json["image"],
        related: json["related"],
        source: sourceValues.map[json["source"]],
        summary: json["summary"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "category": categoryValues.reverse[category],
        "datetime": datetime,
        "headline": headline,
        "id": id,
        "image": image,
        "related": related,
        "source": sourceValues.reverse[source],
        "summary": summary,
        "url": url,
      };
}

enum Category { BUSINESS, TOP_NEWS }

final categoryValues = EnumValues({"business": Category.BUSINESS, "top news": Category.TOP_NEWS});

enum Source { CNBC, MARKET_WATCH }

final sourceValues = EnumValues({"CNBC": Source.CNBC, "MarketWatch": Source.MARKET_WATCH});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
