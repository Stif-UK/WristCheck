import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/widgets/google_logo.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Logging into WristTrack is optional - the app is 'local first' and all of your data is your own.\n"
                  "However logging in simplifies tracking Pro upgrades and syncronising data between devices."),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(child:
                    Text("Learn more",),
                  onPressed: (){},),
                ],
              ),
              const Divider(thickness: 2,),
              WatchFormField(
                fieldTitle: 'Username',
                hintText: 'Enter your username',
                icon: const FaIcon(FontAwesomeIcons.user),
                controller: _usernameController,
                enabled: true,
                maxLines: 1,
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 12.0),
              WatchFormField(
                fieldTitle: 'Password',
                hintText: 'Enter your password',
                icon: const FaIcon(FontAwesomeIcons.lock),
                controller: _passwordController,
                enabled: true,
                maxLines: 1,
                obscureText: true,
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const Home()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text('Login', style: TextStyle(
                    color: Colors.white,
                    fontSize: 25
                  ),),
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "or login with",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      iconSize: 30,
                      padding: EdgeInsets.zero,
                      icon: const GoogleLogo(size: 30),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      iconSize: 30,
                      padding: EdgeInsets.zero,
                      icon: FaIcon(
                        FontAwesomeIcons.apple,
                        size: 30,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    TextButton(
                      child: Text("Sign Up Here"),
                      onPressed: (){},
                    )
                    ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
