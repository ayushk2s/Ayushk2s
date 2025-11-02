import 'dart:math';

import 'package:flutter/material.dart';

class FlipSkillCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final double progress;

  const FlipSkillCard({
    super.key,
    required this.icon,
    required this.title,
    required this.progress,
  });

  @override
  State<FlipSkillCard> createState() => _FlipSkillCardState();
}

class _FlipSkillCardState extends State<FlipSkillCard>
    with TickerProviderStateMixin {

  AnimationController? _flipCtrl;
  AnimationController? _progCtrl;
  late Animation<double> _progAnim;

  bool _showingBack = false;
  double get target => widget.progress.clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();

    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _progCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _progAnim = Tween<double>(begin: 0, end: target).animate(
      CurvedAnimation(parent: _progCtrl!, curve: Curves.easeOut),
    );

    _flipCtrl!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _progCtrl!.forward(from: 0);
        setState(() => _showingBack = true);
      } else if (status == AnimationStatus.dismissed) {
        _progCtrl!.reset();
        setState(() => _showingBack = false);
      }
    });
  }

  @override
  void dispose() {
    _flipCtrl?.dispose();
    _progCtrl?.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_flipCtrl!.status == AnimationStatus.dismissed ||
        _flipCtrl!.status == AnimationStatus.reverse) {
      _flipCtrl!.forward();
    } else {
      _flipCtrl!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_flipCtrl == null) return const SizedBox();

    return GestureDetector(
      onTap: _onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,

        // ✅ Bring back hover flip
        onEnter: (_) {
          if (!_showingBack) _flipCtrl!.forward();
        },
        onExit: (_) {
          if (_showingBack) _flipCtrl!.reverse();
        },

        child: AnimatedBuilder(
          animation: _flipCtrl!,
          builder: (_, __) {
            final angle = _flipCtrl!.value * pi;
            final isBack = angle > (pi / 2);

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(angle),
              child: isBack
                  ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(pi),
                child: _buildBack(),
              )
                  : _buildFront(),
            );
          },
        ),
      ),
    );
  }


  Widget _buildFront() => Container(
    decoration: _cardGlow,
    child: Center(
      child: Icon(widget.icon, size: 38, color: Colors.cyanAccent),
    ),
  );

  Widget _buildBack() => AnimatedBuilder(
    animation: _progCtrl!,
    builder: (_, __) {
      final value = _progAnim.value;
      return Container(
        decoration: _cardGlow,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: Colors.white10,
              valueColor:
              const AlwaysStoppedAnimation(Colors.cyanAccent),
            ),
            const SizedBox(height: 6),
            Text('${(value * 100).round()}%',
                style:
                const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      );
    },
  );

  BoxDecoration get _cardGlow => BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    color: Colors.white.withOpacity(0.06),
    border: Border.all(
        color: Colors.cyanAccent.withOpacity(0.40), width: 1.2),
    boxShadow: [
      BoxShadow(
        color: Colors.cyanAccent.withOpacity(0.22),
        blurRadius: 12,
        spreadRadius: 2,
      )
    ],
  );
}
