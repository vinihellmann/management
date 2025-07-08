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
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 12,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withAlpha(40),
                    child: Text(
                      customer.name?.substring(0, 1).toUpperCase() ?? '?',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${customer.code} - ${customer.name?.toUpperCase() ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: theme.hintColor, size: 20),
                ],
              ),
              Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      customer.document ?? '-',
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      customer.phone ?? '-',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (customer.email?.isNotEmpty == true)
                Text(
                  '${customer.email}',
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              if (customer.address?.isNotEmpty == true ||
                  customer.city?.isNotEmpty == true)
                Text(
                  '${customer.address ?? ''}, ${customer.number ?? ''} - ${customer.neighborhood ?? ''}, ${customer.city ?? ''}/${customer.state ?? ''}',
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),

              if (customer.complement?.isNotEmpty == true ||
                  customer.contact?.isNotEmpty == true)
                Text(
                  '${customer.complement ?? ''}${customer.complement != null && customer.contact != null ? ' - ' : ''}${customer.contact ?? ''}',
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.hintColor,
                    fontStyle: FontStyle.italic,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
