class PagedReqEntry {
  PagedReqEntry({
    this.pageNum = 1,
    this.pageSize = 10,
  });

  int pageNum; //页码
  int pageSize; //分页大小
  ///业务参数
  Map<String, dynamic>? getParam() {
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pageNum'] = pageNum;
    data['pageSize'] = pageSize;
    if (getParam() != null) {
      data['param'] = getParam();
    }
    return data;
  }
}
