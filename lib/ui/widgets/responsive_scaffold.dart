import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.fab,
  });

  final String title;
  final Widget body;
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    final padding = isMobile
        ? const EdgeInsets.all(12)
        : isTablet
            ? const EdgeInsets.all(20)
            : const EdgeInsets.symmetric(horizontal: 48, vertical: 24);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: fab,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isMobile ? width : 1200),
          child: Padding(padding: padding, child: body),
        ),
      ),
    );
  }
}
