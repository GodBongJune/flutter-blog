class JoinReqDTO {
  String username;
  String password;
  String email;

  JoinReqDTO(
      {required this.username, required this.password, required this.email});
  Map<String, dynamic> toJson() =>
      {"username": username, "password": password, "email": email};
}

class LoginReqDTO {
  final String username;
  final String password;

  LoginReqDTO({required this.username, required this.password});

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
