import 'dart:developer';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:eden_test/features/auth/controllers/auth_controller.dart';
import 'package:eden_test/features/orders/models/order_status_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = StateNotifierProvider<OrderController, OrderState>((ref) {
  return OrderController();
});

class OrderController extends StateNotifier<OrderState> {
  OrderController() : super(OrderState());

  ably.RealtimeChannel? channel;

  Future<void> createAblyRealtimeInstance(WidgetRef ref) async {
    var clientOptions = ably.ClientOptions(
      key: 'oiDOrA.HnDEIw:_vcQQwIA8iy1HEPQVKTenBUnaC6LUY7VvueQ7993uZs',
      clientId: ref.watch(authProvider).user!.user!.uid,
    );
    try {
      ably.Realtime realtime = ably.Realtime(options: clientOptions);
      channel = realtime.channels.get('order-status');
      await subscribeToChannel();
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

  Future<void> subscribeToChannel() async {
    var messageStream = channel!.subscribe();
    messageStream.listen((ably.Message message) {
      var orderStatusEnum =
          OrderStatusEnum.values.firstWhere((e) => message.name!.toLowerCase() == e.name.toLowerCase());
      var timestamp = message.timestamp;
      state = state.copyWith(orderStatus: orderStatusEnum, timestamp: timestamp);
    });
  }

  int handleOrderStatus(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.orderPlaced:
        log('Order Placed');
        return 0;
      case OrderStatusEnum.orderAccepted:
        log('Order Accepted');
        return 1;
      case OrderStatusEnum.orderPickUpInProgress:
        log('Pick Up In Progress');
        return 2;
      case OrderStatusEnum.orderOnTheWayToCustomer:
        log('On the Way to Customer');
        return 3;
      case OrderStatusEnum.orderArrived:
        log('Order Arrived');
        return 4;
      case OrderStatusEnum.orderDelivered:
        log('Order Delivered');
        return 5;
      default:
        log('Unknown Order Status');
        return 0;
    }
  }

  // curl -X POST https://realtime.ably.io/channels/order-status/messages -u "oiDOrA.HnDEIw:_vcQQwIA8iy1HEPQVKTenBUnaC6LUY7VvueQ7993uZs" -H "Content-Type: application/json"  --data '{ "name": "xpendingnnnn" }'
}
