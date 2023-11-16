// ignore_for_file: constant_identifier_names

class OrderState {
  final bool loading;
  final OrderStatusEnum orderStatus;
  final DateTime? timestamp;

  OrderState({
    this.loading = false,
    this.orderStatus = OrderStatusEnum.ORDER_PLACED,
    this.timestamp,
  });

  OrderState copyWith({
    bool? loading,
    OrderStatusEnum? orderStatus,
    DateTime? timestamp,
  }) {
    return OrderState(
      loading: loading ?? this.loading,
      orderStatus: orderStatus ?? this.orderStatus,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

enum OrderStatusEnum {
  ORDER_PLACED,
  ORDER_ACCEPTED,
  ORDER_PICK_UP_IN_PROGRESS,
  ORDER_ON_THE_WAY_TO_CUSTOMER,
  ORDER_ARRIVED,
  ORDER_DELIVERED,
}
