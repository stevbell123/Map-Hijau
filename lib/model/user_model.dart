class UserModel {
  final String username;
  final String email;
  final String password;
  final String? namaLengkap;
  final String? alamat;
  final String? jenisKelamin;
  final int level;
  final int poin;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    this.namaLengkap,
    this.alamat,
    this.jenisKelamin,
    this.level = 1,
    this.poin = 0,
  });

  UserModel copyWith({
    String? username,
    String? email,
    String? password,
    String? namaLengkap,
    String? alamat,
    String? jenisKelamin,
    int? level,
    int? poin,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      alamat: alamat ?? this.alamat,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      level: level ?? this.level,
      poin: poin ?? this.poin,
    );
  }
}