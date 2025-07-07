import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/modules/customer/models/customer_model.dart';
import 'package:management/modules/customer/pages/customer_list_page.dart';

class CustomerSelectPage extends StatelessWidget {
  const CustomerSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomerListPage(
      onSelect: (CustomerModel selected) {
        context.pop(selected);
      },
    );
  }
}
