import 'dart:developer';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:eden_test/features/auth/controllers/auth_controller.dart';
import 'package:eden_test/features/orders/models/order_status_model.dart';
import 'package:eden_test/secrets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = StateNotifierProvider<OrderController, OrderState>((ref) {
  return OrderController();
});

class OrderController extends StateNotifier<OrderState> {
  OrderController() : super(OrderState());

  ably.RealtimeChannel? channel;
  OrderStatusEnum? orderStatusEnum;

  Future<void> createAblyRealtimeInstance(WidgetRef ref) async {
    var clientOptions = ably.ClientOptions(
      key: ablyApiKey,
      clientId: ref.watch(authProvider).user!.user!.uid,
    );
    try {
      ably.Realtime realtime = ably.Realtime(options: clientOptions);
      channel = realtime.channels.get('order-status');
      await subscribeToOrderChannel();
      realtime.connection.on(ably.ConnectionEvent.connected).listen(
        (ably.ConnectionStateChange stateChange) async {
          log('Realtime connection state changed: ${stateChange.event}');
        },
      );
    } catch (error) {
      log('Error creating Ably Realtime Instance: $error');
      rethrow;
    }
  }

  Future<void> subscribeToOrderChannel() async {
    var messageStream = channel!.subscribe();
    messageStream.listen((ably.Message message) {
      orderStatusEnum = message.data == null
          ? null
          : OrderStatusEnum.values.firstWhere(
              (e) => message.data.toString().toLowerCase() == e.name.toLowerCase(),
              orElse: () => orderStatusEnum ?? OrderStatusEnum.ORDER_PLACED,
            );
      var timestamp = message.timestamp;
      state = state.copyWith(orderStatus: orderStatusEnum, timestamp: timestamp);
    });
  }

  int handleOrderStatus(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.ORDER_PLACED:
        return 0;
      case OrderStatusEnum.ORDER_ACCEPTED:
        return 1;
      case OrderStatusEnum.ORDER_PICK_UP_IN_PROGRESS:
        return 2;
      case OrderStatusEnum.ORDER_ON_THE_WAY_TO_CUSTOMER:
        return 3;
      case OrderStatusEnum.ORDER_ARRIVED:
        return 4;
      case OrderStatusEnum.ORDER_DELIVERED:
        return 5;
      default:
        log('Unknown Order Status');
        return 0;
    }
  }
}
