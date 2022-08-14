import 'package:flutter/material.dart';
import 'package:store_login_credentials/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('HOME PAGE'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyHomePage())),
          child: const Text(
            'LOGOUT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
