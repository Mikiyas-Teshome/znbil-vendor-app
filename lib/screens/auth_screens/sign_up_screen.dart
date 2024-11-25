import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenbil_vendor_app/widgets/custom_text_form_field.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../repositories/dio_client.dart';
import '../../widgets/address_input.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_ein_input_field.dart';
import '../../widgets/custom_phone_text_field.dart';
import '../../widgets/error_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedBusinessType;
  final List<DropdownMenuItem<String>> _businessTypeItems = [
    const DropdownMenuItem(value: 'LLC', child: Text('LLC')),
    const DropdownMenuItem(
        value: 'SOLE_PROPRIETORSHIP', child: Text('SOLE PROPRIETORSHIP')),
    const DropdownMenuItem(value: 'CORPORATION', child: Text('CORPORATION')),
    const DropdownMenuItem(value: 'PARTNERSHIP', child: Text('PARTNERSHIP')),
    const DropdownMenuItem(value: 'NON_PROFIT', child: Text('NON_PROFIT')),
  ];
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
          if (state is AuthSignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Confirmation Email sent')),
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
                      children: [
                        SvgPicture.asset(
                          'assets/images/logo.svg',
                          height: 80.0,
                        ),
                        const SizedBox(height: 10),
                        Text("Welcome!",
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
                                controller: _firstNameController,
                                labelText: 'First Name',
                                prefixIcon: Icons.person_outlined,
                                validator: (value) => value!.isEmpty
                                    ? 'First name is required'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _lastNameController,
                                labelText: 'Last Name',
                                prefixIcon: Icons.person_outlined,
                                validator: (value) => value!.isEmpty
                                    ? 'Last name is required'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: "Email",
                                prefixIcon: Icons.mail_outline_rounded,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 20),
                              CustomPhoneTextFormField(
                                controller: _phoneController,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _businessNameController,
                                labelText: 'Business Name',
                                prefixIcon: Icons.business_outlined,
                                validator: (value) => value!.isEmpty
                                    ? 'Business name is required'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomDropdown<String>(
                                labelText: 'Business Type',
                                prefixIcon: Icons.business_outlined,
                                value: _selectedBusinessType,
                                items: _businessTypeItems,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBusinessType = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select your business type'
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              CustomEinInputField(
                                controller: _taxIdController,
                              ),
                              const SizedBox(height: 20),
                              AddressInputWidget(apiKey: ""),
                              const SizedBox(height: 20),
                              CustomTextField(
                                labelText: "Password",
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                controller: _passwordController,
                                validator: _validatePassword,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                validator: (value) =>
                                    value != _passwordController.text
                                        ? 'Passwords do not match'
                                        : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
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
                            'Sign Up',
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
                            text: 'Already have an account? ',
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
                                text: 'Sign In',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
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
