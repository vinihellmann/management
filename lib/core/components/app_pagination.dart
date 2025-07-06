import 'package:flutter/material.dart';

class AppPagination extends StatelessWidget {
  final int currentPage;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool hasNext;
  final bool hasPrevious;
  final int totalPages;

  const AppPagination({
    super.key,
    required this.currentPage,
    this.onNext,
    this.onPrevious,
    this.hasNext = true,
    this.hasPrevious = true,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: 'Página Anterior',
            onPressed: hasPrevious ? onPrevious : null,
            icon: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 16),
          Text('Página $currentPage de $totalPages'),
          const SizedBox(width: 16),
          IconButton(
            tooltip: 'Próxima Página',
            onPressed: hasNext ? onNext : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
