abstract class BasePageRespEntry {
  BasePageRespEntry();

  BasePageRespEntry.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}

abstract class PagedList<T extends BasePageRespEntry> {
  PagedList({
    this.items,
    this.pageInfo,
  });

  List<T>? items;
  PageInfo? pageInfo;

  bool get hasMore =>
      (pageInfo?.current ?? 0) * (pageInfo?.pageSize ?? 0) <
      (pageInfo?.total ?? 0);

  PagedList.fromJson(Map<String, dynamic> json) {
    pageInfo =
        json["page_info"] == null ? null : PageInfo.fromJson(json["page_info"]);
    if (json['list'] != null) {
      items = [];
      json['list'].forEach((v) {
        items?.add(mapItem(v));
      });
    } else {
      items = [];
    }
  }

  T mapItem(dynamic value);

  Map<String, dynamic> toJson() => {
        "page_info": pageInfo?.toJson(),
        "data": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class PageInfo {
  PageInfo({
    this.current = 0,
    this.pageSize = 0,
    this.total = 0,
  });

  int current;
  int pageSize;
  int total;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        current: json["current"],
        pageSize: json["pageSize"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current": current,
        "pageSize": pageSize,
        "total": total,
      };
}
