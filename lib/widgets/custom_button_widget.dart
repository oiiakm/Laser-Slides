import 'package:flutter/material.dart';
import 'package:laser_slides/utils/responsive.dart';

class CustomButtonWidget extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomButtonWidget({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CustomButtonWidget> createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget>
    with SingleTickerProviderStateMixin {
  late double buttonWidth;
  late double buttonHeight;
  late AnimationController _animationController;
  late Animation<Color?> _shiningColorAnimation;

  @override
  void initState() {
    super.initState();
    buttonWidth = ResponsiveUtils.calculateButtonWidth();
    buttonHeight = ResponsiveUtils.calculateButtonHeight();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    //shining effect by animating the button color
    _shiningColorAnimation = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          tween: ColorTween(begin: widget.backgroundColor, end: Colors.white),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.white, end: widget.backgroundColor),
          weight: 1,
        ),
      ],
    ).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            color: _shiningColorAnimation.value,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: ResponsiveUtils.calculateTextSize(),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
