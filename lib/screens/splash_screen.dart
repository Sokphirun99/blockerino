import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../services/mission_service.dart';
import '../services/streak_service.dart';
import 'main_menu_screen.dart';

/// Debug print helper - only prints in debug mode
void _log(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

/// Modern splash screen with animated logo that builds up from blocks
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _buildController;
  late AnimationController _pulseController;
  late AnimationController _spinnerController;
  late AnimationController _fadeController;

  // Animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<double> _titleSlide;

  // Loading state
  bool _isLoading = true;
  final String _loadingText = 'Loading';
  int _dotCount = 0;

  // App version
  static const String _appVersion = '1.0.0';

  // Logo grid blocks (3x3 grid that builds up)
  final List<_LogoBlock> _logoBlocks = [];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _generateLogoBlocks();
    _startLoadingAnimation();
    _initializeApp();
  }

  void _initAnimations() {
    // Build up animation for logo blocks (staggered)
    _buildController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Pulse/breathe effect for logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Spinner rotation
    _spinnerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    // Fade in/out controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buildController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Logo opacity
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buildController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Title animations
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buildController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _buildController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    // Start build animation
    _buildController.forward();
    _fadeController.forward();
  }

  void _generateLogoBlocks() {
    // 3x3 grid of blocks for logo (matching game theme colors)
    final colors = [
      const Color(0xFF4ECDC4), // Teal (Classic)
      const Color(0xFFFF6B6B), // Coral/Red (Chaos)
      const Color(0xFF9B59B6), // Purple
      const Color(0xFFFF6B6B), // Coral/Red
      const Color(0xFFFFE66D), // Yellow (Block Quest)
      const Color(0xFF4ECDC4), // Teal
      const Color(0xFF9B59B6), // Purple
      const Color(0xFFFFE66D), // Yellow
      const Color(0xFFFF6B6B), // Coral/Red
    ];

    for (int i = 0; i < 9; i++) {
      final row = i ~/ 3;
      final col = i % 3;
      _logoBlocks.add(_LogoBlock(
        row: row,
        col: col,
        color: colors[i],
        delay: (row + col) * 0.1, // Staggered delay
      ));
    }
  }

  void _startLoadingAnimation() {
    // Animate loading dots
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted && _isLoading) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
        return true;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _buildController.dispose();
    _pulseController.dispose();
    _spinnerController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize services
      try {
        await SoundService().initialize();
      } catch (e) {
        _log('Audio init error (non-fatal): $e');
      }

      try {
        final missionService = MissionService();
        await missionService.getDailyMissions();
      } catch (e) {
        _log('Mission service error (non-fatal): $e');
      }

      try {
        final streakService = StreakService();
        streakService.getStreak();
      } catch (e) {
        _log('Streak service error (non-fatal): $e');
      }

      // Minimum display time for splash
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        setState(() => _isLoading = false);
        await Future.delayed(const Duration(milliseconds: 300));
        _navigateToMain();
      }
    } catch (e) {
      _log('Error during initialization: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToMain();
      }
    }
  }

  void _navigateToMain() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainMenuScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D1B4E), // Purple dark (matches main menu)
              Color(0xFF1A0F2E), // Darker purple
              Color(0xFF0D0714), // Almost black
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _buildController,
              _pulseController,
              _fadeController,
            ]),
            builder: (context, child) {
              return Column(
                children: [
                  const Spacer(flex: 3),

                  // Animated Logo
                  _buildAnimatedLogo(),

                  const SizedBox(height: 32),

                  // Game Title
                  _buildTitle(),

                  const Spacer(flex: 2),

                  // Loading Spinner
                  _buildLoadingSpinner(),

                  const Spacer(flex: 2),

                  // Version & Studio
                  _buildFooter(),

                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    final pulseValue = 1.0 + (_pulseController.value * 0.08);

    return Opacity(
      opacity: _logoOpacity.value,
      child: Transform.scale(
        scale: _logoScale.value * pulseValue,
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9B59B6).withValues(alpha: 0.4 * _pulseController.value),
                blurRadius: 30 + (15 * _pulseController.value),
                spreadRadius: 5 + (5 * _pulseController.value),
              ),
              BoxShadow(
                color: const Color(0xFFFFE66D).withValues(alpha: 0.2 * _pulseController.value),
                blurRadius: 50 + (20 * _pulseController.value),
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              color: const Color(0xFF1A0F2E),
              padding: const EdgeInsets.all(12),
              child: _buildBlockGrid(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final block = _logoBlocks[index];
        final blockProgress = (_buildController.value - block.delay).clamp(0.0, 1.0) / 0.3;
        final scale = Curves.elasticOut.transform(blockProgress.clamp(0.0, 1.0));

        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              color: block.color,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: block.color.withValues(alpha: 0.5),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Opacity(
      opacity: _titleOpacity.value,
      child: Transform.translate(
        offset: Offset(0, _titleSlide.value),
        child: Column(
          children: [
            // Main title (matches main menu style - white/yellow)
            const Text(
              'BLOCKERINO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: Color(0xFFFFE66D),
                    offset: Offset(0, 0),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle (matches main menu tagline style)
            Text(
              '8x8 grid, break lines!',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSpinner() {
    if (!_isLoading) {
      return const SizedBox(height: 60);
    }

    return SizedBox(
      height: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom spinner (purple to match theme)
          SizedBox(
            width: 28,
            height: 28,
            child: AnimatedBuilder(
              animation: _spinnerController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SpinnerPainter(
                    progress: _spinnerController.value,
                    color: const Color(0xFFFFE66D), // Yellow accent
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Loading text with dots
          Text(
            '$_loadingText${'.' * _dotCount}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Opacity(
      opacity: _titleOpacity.value,
      child: Column(
        children: [
          // Studio branding
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'KR STUDIO',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Version number
          Text(
            'v$_appVersion',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo block data
class _LogoBlock {
  final int row;
  final int col;
  final Color color;
  final double delay;

  _LogoBlock({
    required this.row,
    required this.col,
    required this.color,
    required this.delay,
  });
}

/// Custom spinner painter
class _SpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _SpinnerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Background circle
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, bgPaint);

    // Spinning arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final startAngle = progress * 2 * pi;
    const sweepAngle = pi * 0.8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
