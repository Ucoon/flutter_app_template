class PagedReqEntry {
  PagedReqEntry({
    this.current = 1,
    this.pageSize = 20,
  });

  int current;
  int pageSize;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['current'] = current;
    data['pageSize'] = pageSize;
    return data;
  }
}
