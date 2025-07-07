enum SaleStatusEnum {
  open,
  awaitingPayment,
  confirmed,
  sent,
  canceled,
  completed,
}

extension SaleStatusEnumExtension on SaleStatusEnum {
  String get label {
    switch (this) {
      case SaleStatusEnum.open:
        return 'Em Aberto';
      case SaleStatusEnum.awaitingPayment:
        return 'Aguardando pagamento';
      case SaleStatusEnum.confirmed:
        return 'Confirmada';
      case SaleStatusEnum.sent:
        return 'Enviada';
      case SaleStatusEnum.canceled:
        return 'Cancelada';
      case SaleStatusEnum.completed:
        return 'Concluída';
    }
  }
}
