part of 'payment_receipt_bloc.dart';

sealed class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

final class PaymentReceiptLoading extends PaymentReceiptState {}

final class PaymentReceiptSuccess extends PaymentReceiptState {
  final PaymentReceiptData paymentReceiptData;

  const PaymentReceiptSuccess(this.paymentReceiptData);
  @override
  List<Object> get props => [paymentReceiptData];
}

final class PaymentReceiptError extends PaymentReceiptState {
  final AppException exception;
  const PaymentReceiptError(this.exception);
  @override
  List<Object> get props => [exception];
}
