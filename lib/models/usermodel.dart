class UserModel {
  String uid;
  String email;
  String name;
  String phonenumber;
  String address;
  int follower;
  int following;
  String imageurl;

  UserModel(
      {this.uid,
      this.name,
      this.email,
      this.phonenumber,
      this.address,
      this.follower,
      this.following,
      this.imageurl});
  UserModel.fromData(Map<String, dynamic> data)
      : name = data['name'],
        address = data['address'],
        email = data['email'],
        phonenumber = data['phonenumber'],
        follower = data['follower'],
        following = data['following'],
        imageurl = data['imageurl'];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phonenumber': phonenumber,
      'address': address,
      'follower': follower,
      'following': following,
      'imageurl': imageurl,
    };
  }
}
