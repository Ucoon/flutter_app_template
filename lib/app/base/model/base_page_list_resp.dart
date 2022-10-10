abstract class BasePageRespEntry {
  BasePageRespEntry();

  BasePageRespEntry.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}

abstract class PagedList<T extends BasePageRespEntry> {
  PagedList({
    this.total = 0,
    this.size = 0,
    this.current = 0,
    this.pages = 0,
    this.items,
  });

  int total = 0;
  int size = 0;
  int current = 0;
  int pages = 0;
  List<T>? items;

  bool get hasMore => current * size < total;

  PagedList.fromJson(Map<String, dynamic> json) {
    total = json["total"] ?? 0;
    size = json["size"] ?? 0;
    current = json["current"] ?? 0;
    pages = json["pages"] ?? 0;
    items = [];
    if (json['records'] != null) {
      json['records'].forEach((v) {
        items!.add(mapItem(v));
      });
    }
  }

  T mapItem(dynamic value);

  Map<String, dynamic> toJson() => {
    "total": total,
    "size": size,
    "current": current,
    "pages": pages,
    "records": items == null
        ? null
        : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}
