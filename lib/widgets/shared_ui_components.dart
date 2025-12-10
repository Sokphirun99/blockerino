import 'package:flutter/material.dart';
import '../config/app_config.dart';

/// Shared gradient background used across all game screens
class GameGradientBackground extends StatelessWidget {
  final Widget child;
  
  const GameGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a2e), Color(0xFF0f0f1e)],
        ),
      ),
      child: child,
    );
  }
}

/// Shared coin display widget
class CoinDisplay extends StatelessWidget {
  final int coins;
  final double fontSize;
  final double iconSize;
  
  const CoinDisplay({
    super.key,
    required this.coins,
    this.fontSize = 24,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConfig.accentColor, AppConfig.coinGradientEnd],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppConfig.accentColor.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🪙', style: TextStyle(fontSize: iconSize)),
          const SizedBox(width: 8),
          Text(
            '$coins',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared reward display for story mode and challenges
class RewardDisplay extends StatelessWidget {
  final int coins;
  
  const RewardDisplay({
    super.key,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🪙', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 4),
        Text(
          '+$coins',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFffd700),
          ),
        ),
      ],
    );
  }
}

/// Standardized primary action button
class PrimaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  
  const PrimaryActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppConfig.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Shared SnackBar helper
class SharedSnackBars {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showNotEnoughCoins(BuildContext context) {
    showError(context, 'Not enough coins!');
  }

  static void showPowerUpUsed(BuildContext context, String powerUpName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$powerUpName used! Buy more in the Store.'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
