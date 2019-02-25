
class UserData{
  String name='default';
  String email='default';
  String major='default';
  String year='default';
  String uid='default';
  String imgurl='default';

  toJson () {
    return {
      "name":name,
      "email":email,
      "major":major,
      "year":year,
      "uid":uid,
      "imgurl":imgurl,
    };
  }

  fromJson(Map<String, dynamic> parsedJson) {
    return {
      name: parsedJson['name'],
      email: parsedJson['email'],
      major: parsedJson['major'],
      year: parsedJson['year'],
      uid: parsedJson['uid'],
      //fix
    };
  }

}