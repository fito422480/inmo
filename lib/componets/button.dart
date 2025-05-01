import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool? disabled;

  const MyButton(
      {super.key, required this.onTap, required this.text, this.disabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled == true
          ? null
          : onTap, // Si está deshabilitado, onPressed es null
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
