import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  final int currentPage;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool hasNext;
  final bool hasPrevious;

  const AppPagination({
    super.key,
    required this.currentPage,
    this.onNext,
    this.onPrevious,
    this.hasNext = true,
    this.hasPrevious = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () async => hasPrevious ? onPrevious : null,
            icon: Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 16),
          Text('Página $currentPage'),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () async => hasNext ? onNext : null,
            icon: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
