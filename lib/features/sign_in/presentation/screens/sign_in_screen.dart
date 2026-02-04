import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inner_bloom_app/core/states/firebase_auth_service_cubit.dart';

import 'package:inner_bloom_app/features/onboarding/presentation/screens/onboarding_page.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/screens/sign_up_screen.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/widgets/bottom_bar.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/widgets/close_icon.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/widgets/headline_text.dart';
import 'package:inner_bloom_app/features/sign_in/presentation/widgets/illustration.dart';
import 'package:inner_bloom_app/constants/strings.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GetIt getIt = GetIt.instance;

  bool _isFormValid = false;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;
  late final TextEditingController _pwdCtrl;
  bool _showPassword = false;

  static const Color _brandTeal = Color(0xFF7BAEA9);

  @override
  void initState() {
    super.initState();

    _emailCtrl = TextEditingController();
    _pwdCtrl = TextEditingController();

    _emailCtrl.addListener(_validateForm);
    _pwdCtrl.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailCtrl.removeListener(_validateForm);
    _pwdCtrl.removeListener(_validateForm);

    _emailCtrl.dispose();
    _pwdCtrl.dispose();

    super.dispose();
  }

  void _validateForm() {
    final email = _emailCtrl.text.trim();
    final pass = _pwdCtrl.text.trim();

    final valid =
        email.isNotEmpty &&
        pass.isNotEmpty &&
        _formKey.currentState!.validate();

    if (valid != _isFormValid) {
      setState(() => _isFormValid = valid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirebaseAuthServiceCubit, FirebaseAuthServiceState>(
      listener: (context, state) {
        if (state is FirebaseAuthServiceLoadingState) {}

        if (state is FirebaseAuthServiceFailedState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is FirebaseAuthServiceSuccessfulState) {
          Navigator.pop(context);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingPage()),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is FirebaseAuthServiceLoadingState;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFDFEFC),
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildContent(context, isLoading),
                BottomBar("Don't have an account? ", "Sign up", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignUpScreen()),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CloseIcon(onTapCallback: () => Navigator.pop(context)),
          const SizedBox(height: 24),
          Illustration(),
          const SizedBox(height: 24),
          HeadlineText(
            "Welcome back — let's continue your journey to InnerBloom.",
          ),
          const SizedBox(height: 18),
          _buildFormCard(context, isLoading),
          const SizedBox(height: 18),
          _buildOrDivider(),
          const SizedBox(height: 12),
          _buildSocialRow(context),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _emailCtrl,
            hint: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Please enter your email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 4),
          _buildTextField(
            controller: _pwdCtrl,
            hint: 'Password',
            obscureText: !_showPassword,
            suffix: IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _showPassword = !_showPassword),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your password';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildLoginButton(context, isLoading),
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
      obscureText: obscureText,
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
          borderSide: BorderSide(color: _brandTeal),
        ),
        suffixIcon: suffix,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, bool loading) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isFormValid
            ? () => context.read<FirebaseAuthServiceCubit>().signIn(
                _emailCtrl.text.trim(),
                _pwdCtrl.text.trim(),
              )
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandTeal,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: loading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Or connect with',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildSocialRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIcon(_googleIcon(), 'Google', onTap: () => {}),
        const SizedBox(width: 20),
        _socialIcon(_facebookIcon(), 'Facebook', onTap: () {}),
        const SizedBox(width: 20),
        _socialIcon(_appleIcon(), 'Apple', onTap: () {}),
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
    return Image.asset(appleIcon, fit: BoxFit.contain, width: 22, height: 22);
  }
}
