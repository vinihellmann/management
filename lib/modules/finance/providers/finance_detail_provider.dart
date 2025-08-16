import 'package:management/core/models/base_detail_provider.dart';
import 'package:management/modules/finance/models/finance_model.dart';
import 'package:management/modules/finance/repositories/finance_repository.dart';

class FinanceDetailProvider
    extends BaseDetailProvider<FinanceModel, FinanceRepository> {
  FinanceDetailProvider(super.repository);
}
