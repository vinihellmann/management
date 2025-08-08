import 'package:management/core/models/base_list_provider.dart';
import 'package:management/modules/finance/models/finance_filters.dart';
import 'package:management/modules/finance/models/finance_model.dart';
import 'package:management/modules/finance/repositories/finance_repository.dart';

class FinanceListProvider
    extends BaseListProvider<FinanceModel, FinanceRepository, FinanceFilters> {
  FinanceListProvider(repository) : super(repository, FinanceFilters());
}
