class FirebaseUserInfo {
  String? userEmail;
  String? userName;
  String? userProfilePhotoUrl;

  FirebaseUserInfo({
    this.userEmail,
    this.userName,
    this.userProfilePhotoUrl,
  });

  // ignore: non_constant_identifier_names
  factory FirebaseUserInfo.Instance() {
    return FirebaseUserInfo(
      userEmail: "",
      userName: "",
      userProfilePhotoUrl: "",
    );
  }
}
