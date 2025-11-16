class UserModel {
  final String? id;
  final String email;
  final String password;

  UserModel({
    this.id,
    required this.email, 
    required this.password,
    });

  toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}
