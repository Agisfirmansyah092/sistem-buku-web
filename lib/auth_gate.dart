import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_page.dart';
import 'login_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final StreamSubscription<AuthState> _subscription;
  bool _signedIn = Supabase.instance.client.auth.currentSession != null;

  @override
  void initState() {
    super.initState();
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (state) {
        if (!mounted) return;
        final signedIn = state.session != null;
        if (_signedIn != signedIn) setState(() => _signedIn = signedIn);
        if (!signedIn) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      onError: (Object error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sesi belum dapat diperbarui. Periksa koneksi internet.',
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _signedIn ? const DashboardPage() : const LoginPage();
}
