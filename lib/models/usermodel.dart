class UserModel {
  String email;
  String password;
  String name;
  String phoneNumber;
  String address;
  int follower;
  int following;

  UserModel(name, email, password, phoneNumber, address, follower, following) {
    this.name = name;
    this.email = email;
    this.password = password;
    this.phoneNumber = phoneNumber;
    this.follower = follower;
    this.following = following;
    this.address = address;
  }
}
