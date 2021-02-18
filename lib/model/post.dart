class Post {
  String id;
  String userId;
  String postUrl;
  String caption;
  String createTime;

  Post();

  fromData(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    userId = jsonMap['userId'];
    postUrl = jsonMap['postUrl'];
    caption = jsonMap['caption'];
    createTime = jsonMap['createTime'];
  }

  Map toJSON() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["userId"] = userId;
    map["postUrl"] = postUrl;
    map["caption"] = caption;
    map["createTime"] = createTime;
    return map;
  }
}
