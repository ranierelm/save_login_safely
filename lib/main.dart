import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:store_login_credentials/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save login credentials',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isPasswordObscure = true;
  bool rememberMarked = false; //checkbox value

  // Create storage.
  final _storage = const FlutterSecureStorage();

  // Global key that uniquely identifies the Form widget
  final _formKey = GlobalKey<FormState>();

  // Controllers that will receive entered values.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Form validation and submission.
  _formSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (rememberMarked) {
        await _storage.write(key: "username", value: _usernameController.text);
        await _storage.write(key: "password", value: _passwordController.text);
      } else {
        _storage.deleteAll();
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  Future<void> _readStorage() async {
    _usernameController.text = await _storage.read(key: "username") ?? '';
    _passwordController.text = await _storage.read(key: "password") ?? '';
  }

  @override
  void initState() {
    _readStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save login credentials'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Welcome friend',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigoAccent,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    label: Text('Email or Username'),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Invalid email';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    label: const Text('Password'),
                    suffixIcon: IconButton(
                      splashRadius: 25.0,
                      onPressed: () => setState(
                          () => _isPasswordObscure = !_isPasswordObscure),
                      icon: Icon(
                        _isPasswordObscure
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
                  obscureText: _isPasswordObscure,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    } else if (value.length < 5) {
                      return 'Enter a longer password';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Remember login'),
                    value: rememberMarked,
                    onChanged: (value) {
                      setState(() {
                        rememberMarked = value!;
                      });
                    }),
                const SizedBox(height: 30),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _formSubmit,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Forgout password?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    children: [
                      TextSpan(
                        text: ' Sign Up',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
