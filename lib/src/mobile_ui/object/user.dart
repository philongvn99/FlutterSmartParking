class UserInfo {
  String email;
  String username;
  String phone;
  String pass;
  String token;
  String license;

  UserInfo(this.email, this.username, this.phone,
      {this.pass = '', this.token = '', this.license = ''});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserInfo(user['email'], user['username'], user['phone'],
        token: json['accessToken'], license: user['carPlateNumber']);
  }
}
