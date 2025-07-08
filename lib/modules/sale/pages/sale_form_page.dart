import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/themes/app_text_styles.dart';
import 'package:management/modules/sale/components/sale_form_fields.dart';
import 'package:management/modules/sale/components/sale_form_items_tab.dart';
import 'package:management/modules/sale/components/sale_form_summary_tab.dart';
import 'package:management/modules/sale/models/sale_model.dart';
import 'package:management/modules/sale/providers/sale_form_provider.dart';
import 'package:management/modules/sale/repositories/sale_repository.dart';
import 'package:provider/provider.dart';

class SaleFormPage extends StatelessWidget {
  final SaleModel? sale;

  const SaleFormPage({super.key, this.sale});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              SaleFormProvider(context.read<SaleRepository>())..loadData(sale),
        ),
      ],
      child: _SaleFormView(),
    );
  }
}

class _SaleFormView extends StatefulWidget {
  const _SaleFormView();

  @override
  State<_SaleFormView> createState() => _SaleFormViewState();
}

class _SaleFormViewState extends State<_SaleFormView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  int currentIndex = 0;

  final tabs = const [
    SaleFormFields(),
    SaleFormItemsTab(),
    SaleFormSummaryTab(),
  ];

  final labels = ['Dados', 'Itens', 'Resumo'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.read<SaleFormProvider>();
    final isEdit = provider.model != null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Text(
          isEdit ? 'Editar Venda' : 'Nova Venda',
          style: AppTextStyles.headlineMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: List.generate(labels.length, (index) {
                final isSelected = index == currentIndex;
            
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => currentIndex = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withAlpha(25)
                              : theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: Text(
                          labels[index],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Form(
              key: provider.formKey,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: tabs[currentIndex],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AppButton(
        type: AppButtonType.save,
        onPressed: () async {
          final success = await provider.save();
          if (success == true && context.mounted) {
            context.pop(true);
          }
        },
      ),
    );
  }
}
