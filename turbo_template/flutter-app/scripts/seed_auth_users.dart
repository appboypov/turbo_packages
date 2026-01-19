import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final authPort = Platform.environment['AUTH_PORT'] ?? '9099';
  final host = '127.0.0.1:$authPort';

  final users = [
    {'email': 'appboy@apewpew.app', 'password': '123123123'},
  ];

  for (final user in users) {
    final email = user['email']!;
    final password = user['password']!;

    try {
      final client = HttpClient();
      final request = await client.postUrl(
        Uri.parse('http://$host/identitytoolkit.googleapis.com/v1/accounts:signUp?key=fake-api-key'),
      );
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }));

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        print('➕ Created user: $email');
      } else if (body.contains('EMAIL_EXISTS')) {
        print('✔ User exists: $email');
      } else {
        print('✖ Failed to create user $email: $body');
      }
      client.close();
    } catch (e) {
      print('✖ Error creating user $email: $e');
    }
  }

  print('✅ Auth emulator seeding complete.');
}
