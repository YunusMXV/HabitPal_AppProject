import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsTile extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    Key? key,
    required this.color,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  _SettingsTileState createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  bool isLongPress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        // user's finger makes contact with the screen
        HapticFeedback.mediumImpact();
        setState(() {
          isLongPress = true;
        });
      },
      onTapUp: (_) {
        //  user's finger is lifted off the screen
        widget.onTap();
        setState(() {
          isLongPress = false;
        });
      },
      onTapCancel: () {
        // user moving their finger outside the interactive area or a system event interrupting the gesture
        setState(() {
          isLongPress = false;
        });
      },
      onLongPress: () {
        // user presses and holds on the interactive area for an extended period
        setState(() {
          isLongPress = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isLongPress ? Colors.grey.withOpacity(0.5) : Colors.transparent,
          // borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(
              widget.icon,
              color: widget.color,
              size: 25,
            ),
            const SizedBox(width: 15),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}