import 'dart:math';
import 'package:flutter/material.dart';

/// Widget kartu 3D yang bisa di-tilt kanan-kiri & atas-bawah
/// seperti efek iPhone / Apple Wallet card.
class TiltCard3D extends StatefulWidget {
  final Widget child;
  final double maxTiltDeg;
  final Duration returnDuration;

  const TiltCard3D({
    super.key,
    required this.child,
    this.maxTiltDeg = 25.0,
    this.returnDuration = const Duration(milliseconds: 450),
  });

  @override
  State<TiltCard3D> createState() => _TiltCard3DState();
}

class _TiltCard3DState extends State<TiltCard3D>
    with SingleTickerProviderStateMixin {
  double _rotateX = 0;
  double _rotateY = 0;
  double _shimmerX = 0.5;
  double _shimmerY = 0.5;
  bool _isHovering = false;

  late AnimationController _returnCtrl;
  late Animation<double> _rotXAnim;
  late Animation<double> _rotYAnim;

  @override
  void initState() {
    super.initState();
    _returnCtrl = AnimationController(
      vsync: this,
      duration: widget.returnDuration,
    );
  }

  @override
  void dispose() {
    _returnCtrl.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    _returnCtrl.stop();
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;

    final localPos = details.localPosition;
    final relX = (localPos.dx / w).clamp(0.0, 1.0);
    final relY = (localPos.dy / h).clamp(0.0, 1.0);

    final maxRad = widget.maxTiltDeg * pi / 180;
    setState(() {
      _rotateY = (relX - 0.5) * 2 * maxRad;
      _rotateX = -(relY - 0.5) * 2 * maxRad;
      _shimmerX = relX;
      _shimmerY = relY;
      _isHovering = true;
    });
  }

  void _onPanEnd(DragEndDetails _) => _snapBack();
  void _onPanCancel() => _snapBack();

  void _snapBack() {
    final startX = _rotateX;
    final startY = _rotateY;

    _rotXAnim = Tween<double>(
      begin: startX,
      end: 0,
    ).animate(CurvedAnimation(parent: _returnCtrl, curve: Curves.elasticOut));
    _rotYAnim = Tween<double>(
      begin: startY,
      end: 0,
    ).animate(CurvedAnimation(parent: _returnCtrl, curve: Curves.elasticOut));

    _returnCtrl.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _rotateX = 0;
          _rotateY = 0;
          _shimmerX = 0.5;
          _shimmerY = 0.5;
          _isHovering = false;
        });
      }
    });

    _rotXAnim.addListener(() {
      if (mounted) setState(() => _rotateX = _rotXAnim.value);
    });
    _rotYAnim.addListener(() {
      if (mounted) setState(() => _rotateY = _rotYAnim.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (d) => _onPanUpdate(d, constraints),
          onPanEnd: _onPanEnd,
          onPanCancel: _onPanCancel,
          child: AnimatedScale(
            scale: _isHovering ? 1.025 : 1.0,
            duration: const Duration(milliseconds: 120),
            alignment: Alignment.center,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rotateX)
                ..rotateY(_rotateY),
              child: Stack(
                children: [
                  widget.child,
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        opacity: _isHovering ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment(
                                  (_shimmerX - 0.5) * 2,
                                  (_shimmerY - 0.5) * 2,
                                ),
                                radius: 0.85,
                                colors: [
                                  Colors.white.withValues(alpha: 0.22),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
