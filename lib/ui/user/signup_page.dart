import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/ui/widgets/google_logo.dart';
import 'package:wristcheck/ui/widgets/watch_formfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerifyController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordVerifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              WatchFormField(
                fieldTitle: 'Email',
                hintText: 'Enter your email',
                icon: const FaIcon(FontAwesomeIcons.user),
                controller: _emailController,
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
              const SizedBox(height: 12.0),
              WatchFormField(
                fieldTitle: 'Verify Password',
                hintText: 'Verify your password',
                icon: const FaIcon(FontAwesomeIcons.key),
                controller: _passwordVerifyController,
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
                  child: Text('Create Account', style: TextStyle(
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
                        "or sign-up with",
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
            ],
          ),
        ),
      ),
    );
  }
}
