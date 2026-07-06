import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test ngrok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C48C),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const ApiTestPage(),
    );
  }
}

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({super.key});

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage>
    with SingleTickerProviderStateMixin {
  // Détection automatique du domaine actuel (localhost, IP LAN, ou ngrok)
  String get _apiUrl => '${Uri.base.origin}/api/bonjour/';
  // ──────────────────────────────────────────────

  String? _message;
  bool _loading = true;
  bool _success = false;
  String? _error;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _fetchBonjour();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchBonjour() async {
    setState(() {
      _loading = true;
      _error = null;
      _message = null;
      _success = false;
    });

    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _message = data['message'] as String?;
          _success = true;
          _loading = false;
        });
        _animController.forward(from: 0);
      } else {
        setState(() {
          _error = 'Erreur HTTP ${response.statusCode}';
          _success = false;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Connexion impossible :\n$e';
        _success = false;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1724),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1724),
        elevation: 0,
        title: const Text(
          'Test ngrok',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _buildBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchBonjour,
        backgroundColor: const Color(0xFF00C48C),
        tooltip: 'Réessayer',
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF00C48C),
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Connexion à l\'API…',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
      );
    }

    if (_error != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 80),
          const SizedBox(height: 24),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: _fetchBonjour,
            icon: const Icon(Icons.refresh, color: Color(0xFF00C48C)),
            label: const Text(
              'Réessayer',
              style: TextStyle(color: Color(0xFF00C48C)),
            ),
          ),
        ],
      );
    }

    // ✅ Succès
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icône Flutter de succès animée
        ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFF00E5A0), Color(0xFF00C48C)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C48C).withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 68,
            ),
          ),
        ),

        const SizedBox(height: 36),

        // Message de l'API
        FadeTransition(
          opacity: _fadeAnim,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2535),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00C48C).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              _message ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Badge API status
        FadeTransition(
          opacity: _fadeAnim,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00C48C).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF00C48C),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'API · 200 OK',
                  style: TextStyle(
                    color: Color(0xFF00C48C),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
