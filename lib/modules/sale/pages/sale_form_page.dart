import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/core/components/app_button.dart';
import 'package:management/core/themes/app_text_styles.dart';
import 'package:management/modules/sale/components/sale_form_fields.dart';
import 'package:management/modules/sale/components/sale_form_items_tab.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SaleFormProvider>();
    final isEdit = provider.model != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Editar Venda' : 'Nova Venda',
          style: AppTextStyles.headlineMedium,
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerHeight: 0,
          tabs: const [
            Tab(text: 'Informações'),
            Tab(text: 'Itens'),
          ],
        ),
      ),
      body: Form(
        key: provider.formKey,
        child: TabBarView(
          controller: _tabController,
          children: [SaleFormFields(), SaleFormItemsTab()],
        ),
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
