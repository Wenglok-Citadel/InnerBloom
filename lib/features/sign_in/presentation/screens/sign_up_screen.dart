import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inner_bloom_app/constants/strings.dart';
import 'package:inner_bloom_app/core/states/firebase_auth_service_cubit.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/screens/sign_in_screen.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/widgets/bottom_bar.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/widgets/close_icon.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/widgets/headline_text.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/widgets/illustration.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  static const Color _brandTeal = Color(0xFF7BAEA9);

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirebaseAuthServiceCubit, FirebaseAuthServiceState>(
      listener: (context, state) {
        if (state is FirebaseAuthServiceLoadingState) {
          setState(() => _isLoading = true);
        }

        if (state is FirebaseAuthServiceSuccessfulSignUpState) {
          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "A temporary password has been sent to your email.\nUse it to log in.",
              ),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
          );
        }

        if (state is FirebaseAuthServiceFailedState) {
          setState(() => _isLoading = false);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (_, __) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFDFEFC),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildContent(context),
              BottomBar("Already have an account? ", "Log in", () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CloseIcon(
            onTapCallback: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
          ),
          const SizedBox(height: 84),
          Illustration(),
          const SizedBox(height: 24),
          const HeadlineText(
            "Let's sign up - begin your journey to InnerBloom.",
          ),
          const SizedBox(height: 18),
          _buildFormCard(context),
          const SizedBox(height: 18),
          _buildOrDivider(),
          const SizedBox(height: 12),
          _buildSocialRow(),
          const SizedBox(height: 110),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _emailCtrl,
            hint: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildSignUpButton(context),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _brandTeal.withOpacity(0.9)),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onSignUpPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandTeal,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(emailIcon, width: 24, height: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Sign Up with Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _onSocialTap(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign in with $provider (not implemented)')),
    );
  }

  Future<void> _onSignUpPressed() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    context.read<FirebaseAuthServiceCubit>().signUpWithTempPassword(email);
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Or sign-up with',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon(
          _googleIcon(),
          'Google',
          onTap: () => _onSocialTap('Google'),
        ),
        const SizedBox(width: 20),
        _socialIcon(
          _facebookIcon(),
          'Facebook',
          onTap: () => _onSocialTap('Facebook'),
        ),
        const SizedBox(width: 20),
        _socialIcon(_appleIcon(), 'Apple', onTap: () => _onSocialTap('Apple')),
      ],
    );
  }

  Widget _socialIcon(Widget icon, String label, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
          ],
        ),
        child: icon,
      ),
    );
  }

  Widget _googleIcon() {
    return Image.asset(googleIcon, width: 22, height: 22);
  }

  Widget _facebookIcon() {
    return Image.asset(facebookIcon, width: 22, height: 22);
  }

  Widget _appleIcon() {
    return Image.asset(appleIcon, width: 20, height: 20);
  }
}
