class Comment {
  String id;
  String postid;
  String caption;
  String createTime;
  String userId;
  Comment();

  fromData(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    postid = jsonMap['postid'];
    caption = jsonMap['caption'];
    createTime = jsonMap['createTime'];
    userId = jsonMap['userId'];
  }

  Map toJSON() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["postid"] = postid;
    map["caption"] = caption;
    map["createTime"] = createTime;
    map["userId"] = userId;
    return map;
  }
}
