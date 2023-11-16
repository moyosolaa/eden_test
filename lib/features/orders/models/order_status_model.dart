class OrderState {
  final bool loading;
  final OrderStatusEnum orderStatus;
  final DateTime? timestamp;

  OrderState({
    this.loading = false,
    this.orderStatus = OrderStatusEnum.orderPlaced,
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
  orderPlaced,
  orderAccepted,
  orderPickUpInProgress,
  orderOnTheWayToCustomer,
  orderArrived,
  orderDelivered,
}
