import 'package:flutter/material.dart';

class SongContainer extends StatelessWidget {
  final Widget? child;

  const SongContainer({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.cyanAccent,
            blurRadius: 15,
            offset: Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.cyanAccent,
            blurRadius: 15,
            offset: Offset(-4, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
