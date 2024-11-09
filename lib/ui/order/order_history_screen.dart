// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:nike/common/utils.dart';
// import 'package:nike/data/repo/cart_repository.dart';
// import 'package:nike/data/repo/order_repository.dart';
// import 'package:nike/ui/order/bloc/order_history_bloc.dart';
// import 'package:nike/ui/order/order_history_details.dart';
// import 'package:nike/ui/widgets/image.dart';

// class OrderHistoryScreen extends StatelessWidget {
//   const OrderHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final dividerColor = Theme.of(context).dividerColor.withOpacity(0.1);
//     return BlocProvider(
//       create: (context) {
//         final bloc = OrderHistoryBloc(orderRepository, cartRepository);
//         bloc.add(OrderHistoryStarted());
//         return bloc;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('سوابق سفارش'),
//         ),
//         body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
//           builder: (context, state) {
//             if (state is OrderhistorySuccess) {
//               return ListView.builder(
//                   itemCount: state.orders.length,
//                   physics: const BouncingScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//                       decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.surface,
//                           boxShadow: [
//                             BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 10)
//                           ],
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(width: 1, color: dividerColor)),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 56,
//                             padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('شناسه سفارش :'),
//                                 Text(state.orders[index].id.toString()),
//                               ],
//                             ),
//                           ),
//                           Divider(height: 1, color: dividerColor),
//                           Container(
//                             height: 56,
//                             padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('مبلغ :'),
//                                 Text(
//                                     state.orders[index].payable.withPriceLabel),
//                               ],
//                             ),
//                           ),
//                           Divider(height: 1, color: dividerColor),
//                           Container(
//                             height: 56,
//                             padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('وضعیت پرداخت :'),
//                                 Text(state.orders[index].paymentStatus ==
//                                         'waiting'
//                                     ? 'در حال انتظار'
//                                     : 'پرداخت شده'),
//                               ],
//                             ),
//                           ),
//                           Divider(height: 1, color: dividerColor),
//                           Container(
//                             height: 56,
//                             padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('تاریخ :'),
//                                 Text(state.orders[index].date),
//                               ],
//                             ),
//                           ),
//                           Divider(height: 1, color: dividerColor),
//                           SizedBox(
//                             height: 132,
//                             child: ListView.builder(
//                                 itemCount: state.orders[index].items.length,
//                                 scrollDirection: Axis.horizontal,
//                                 physics: const BouncingScrollPhysics(),
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     height: 100,
//                                     width: 132,
//                                     padding:
//                                         const EdgeInsets.fromLTRB(6, 12, 6, 12),
//                                     child: ImageLoadingService(
//                                         borderRadius: BorderRadius.circular(8),
//                                         imageUrl: state.orders[index]
//                                             .items[index].imageUrl),
//                                   );
//                                 }),
//                           ),
//                           Divider(height: 1, color: dividerColor),
//                           Container(
//                             height: 56,
//                             padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   OrderHistoryDetails(
//                                                     items: state
//                                                         .orders[index].items,
//                                                     orders: state.orders[index],
//                                                   )));
//                                     },
//                                     child: const Text('مشاهده جزییات')),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   });
//             } else if (state is OrderHistoryLoading) {
//               return const Center(
//                 child: CupertinoActivityIndicator(),
//               );
//             } else if (state is OrderHistoryError) {
//               return Center(
//                 child: Text(state.exception.message),
//               );
//             } else {
//               throw Exception('state is not supported');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/repo/order_repository.dart';

import 'package:nike/ui/order/bloc/order_history_bloc.dart';
import 'package:nike/ui/order/order_history_details.dart';
import 'package:nike/ui/widgets/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor.withOpacity(0.1);
    return BlocProvider(
      create: (context) {
        final bloc = OrderHistoryBloc(
          orderRepository,
        );
        bloc.add(OrderHistoryStarted());
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سوابق سفارش'),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderhistorySuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderHistoryBloc>().add(OrderHistoryStarted());
                },
                child: ListView.builder(
                  itemCount: state.orders.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: dividerColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 56,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('شناسه سفارش :'),
                                Text(state.orders[index].id.toString()),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: dividerColor),
                          Container(
                            height: 56,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('مبلغ :'),
                                Text(
                                    state.orders[index].payable.withPriceLabel),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: dividerColor),
                          Container(
                            height: 56,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('وضعیت پرداخت :'),
                                Text(state.orders[index].paymentStatus ==
                                        'waiting'
                                    ? 'در حال انتظار'
                                    : 'پرداخت شده'),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: dividerColor),
                          Container(
                            height: 56,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('تاریخ :'),
                                Text(state.orders[index].date),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: dividerColor),
                          SizedBox(
                            height: 132,
                            child: ListView.builder(
                              itemCount: state.orders[index].items.length,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, itemIndex) {
                                return Container(
                                  height: 100,
                                  width: 132,
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 12, 6, 12),
                                  child: ImageLoadingService(
                                    borderRadius: BorderRadius.circular(8),
                                    imageUrl: state.orders[index]
                                        .items[itemIndex].imageUrl,
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(height: 1, color: dividerColor),
                          Container(
                            height: 56,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderHistoryDetails(
                                          items: state.orders[index].items,
                                          orders: state.orders[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('مشاهده جزییات'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (state is OrderHistoryLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is OrderHistoryError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      ),
    );
  }
}
