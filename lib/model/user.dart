class User {
  String id;
  String name;
  String email;
  String password;
  bool isClient;
  String apiToken;
  String deviceToken;
  String imageUrl;
  bool assisSelected;
  //String phone;
  //String address;
  //String bio;
  //Media image;

//  String role;

  User();

  fromData(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    email = jsonMap['email'];
    apiToken = jsonMap['api_token'];
    deviceToken = jsonMap['device_token'];
    isClient = jsonMap["isclient"];
    imageUrl = jsonMap['media'];
  }

  Map toJSON() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["api_token"] = apiToken;
    map["device_token"] = deviceToken;
    map["isclient"] = isClient;
    map["media"] = imageUrl;
    return map;
  }
}
