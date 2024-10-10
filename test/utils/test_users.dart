import 'dart:math';

class TestUser {
  late String name;
  late String password;
  late String email;
  String? profileId;

  TestUser(String name, String randomId) {
    this.name = "${name}_$randomId";
    password = "${name}_$randomId";
    email = "${name.toLowerCase()}_$randomId@test.getbraincloud.com";
  }
}

String generateRandomString(int length) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random(DateTime.now().microsecond);
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}
