import 'package:flutter/material.dart';
import 'package:management/modules/customer/models/customer_model.dart';

class CustomerListItem extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onTap;

  const CustomerListItem({
    super.key,
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(customer.name![0].toUpperCase())),
      title: Text('${customer.code} - ${customer.name}'),
      subtitle: Text(customer.document!),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
