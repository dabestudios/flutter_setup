import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NormalButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          double.infinity, // Hace que el botón ocupe todo el ancho disponible
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[800], // Fondo del botón
          foregroundColor: Colors.white, // Color
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
