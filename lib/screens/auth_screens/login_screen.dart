import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenbil_vendor_app/screens/auth_screens/sign_up_screen.dart';
import 'package:zenbil_vendor_app/widgets/custom_text_form_field.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/dio_client.dart';
import '../../widgets/error_dialog.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // Valid email
  }

  /// Function to validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null; // Valid password
  }

  @override
  Widget build(BuildContext context) {
    final dioClient = DioClient();
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Welcome ${state.vendorData.firstName} ${state.vendorData.lastName}!')),
            );
          } else if (state is AuthFailure) {
            _showError(context, message: state.error);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Login Failed: ${state.error}')),
            // );
          }
        },
        builder: (context, state) {
          // if (state is AuthLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset(
                          'assets/images/logo.svg',
                          height: 80.0,
                        ),
                        const SizedBox(height: 10),
                        Text("Welcome Back!",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                )),
                        const SizedBox(height: 30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                labelText: "Email",
                                prefixIcon: Icons.mail_outline_rounded,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: "Password",
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                controller: _passwordController,
                                validator: _validatePassword,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Forget Password?",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: Colors.amber[600],
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.amber,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    LoginRequested(
                                      _emailController.text,
                                      _passwordController.text,
                                    ),
                                  );
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).iconTheme.color,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  LoginRequested(
                                    _emailController.text,
                                    _passwordController.text,
                                  ),
                                );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/google_logo.svg',
                                height: 24.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Sign In with Google',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17.0,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        RichText(
                          text: TextSpan(
                            text: 'Didn\'t have an account? ',
                            style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.7)),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle the tap event here
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RepositoryProvider(
                                            create: (context) =>
                                                AuthRepository(dioClient),
                                            child: BlocProvider(
                                              create: (context) => AuthBloc(
                                                  RepositoryProvider.of<
                                                      AuthRepository>(context)),
                                              child: SignUpScreen(),
                                            ),
                                          ),
                                        ));
                                  },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                        Text(
                          "By continuing, you agree to our Terms and Privacy Policy.",
                          style: GoogleFonts.inter(
                            fontSize: 15.0,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                if (state is AuthLoading)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.8),
                    child: const SpinKitCircle(
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showError(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(
          title: 'Error',
          message: message,
        );
      },
    );
  }
}
