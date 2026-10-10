import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.appState,
  });

  final MainAppState appState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text("asLowerCase: ${appState.palavraAtual.asLowerCase}"),
    );
  }
}