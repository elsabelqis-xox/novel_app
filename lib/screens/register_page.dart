import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:library_book/screens/main_navigation_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String? _errorText;

  Future<void> _register() async {
    setState(() {
      _errorText = null;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorText = 'Semua field wajib diisi!');
      return;
    }
    if (!_emailController.text.contains('@')) {
      setState(() => _errorText = 'Email tidak valid!');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('email', _emailController.text.trim());
    await prefs.setString('password', _passwordController.text.trim());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil! Masuk ke aplikasi.')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator:
                    (value) => value!.length < 6 ? 'Minimal 6 karakter' : null,
              ),
              const SizedBox(height: 16),
              if (_errorText != null)
                Text(_errorText!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: _register, child: const Text('Daftar')),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigationPage(),
                    ),
                  );
                },
                child: const Text('Sudah punya akun? Lanjut ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
