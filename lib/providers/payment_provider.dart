import 'package:flutter/material.dart';
import 'package:ybb_event_app/models/payment_method_model.dart';
import 'package:ybb_event_app/models/payment_model.dart';
import 'package:ybb_event_app/models/program_payment_model.dart';

class PaymentProvider extends ChangeNotifier {
  List<PaymentMethodModel>? _paymentMethods;
  List<ProgramPaymentModel>? _programPayments;
  List<PaymentModel>? _payments;
  PaymentMethodModel? _selectedPaymentMethod;

  PaymentMethodModel? get selectedPaymentMethod => _selectedPaymentMethod;

  void setSelectedPaymentMethod(PaymentMethodModel paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
    notifyListeners();
  }

  void clearSelectedPaymentMethod() {
    _selectedPaymentMethod = null;
    notifyListeners();
  }

  List<PaymentModel>? get payments => _payments;

  void setPayments(List<PaymentModel> payments) {
    _payments = payments;
    notifyListeners();
  }

  void addPayment(PaymentModel payment) {
    _payments!.add(payment);
    notifyListeners();
  }

  void removePayment(PaymentModel payment) {
    _payments!.remove(payment);
    notifyListeners();
  }

  void clearPayments() {
    _payments = null;
    notifyListeners();
  }

  List<ProgramPaymentModel>? get programPayments => _programPayments;

  void setProgramPayments(List<ProgramPaymentModel> programPayments) {
    _programPayments = programPayments;
    notifyListeners();
  }

  void addProgramPayment(ProgramPaymentModel programPayment) {
    _programPayments!.add(programPayment);
    notifyListeners();
  }

  void removeProgramPayment(ProgramPaymentModel programPayment) {
    _programPayments!.remove(programPayment);
    notifyListeners();
  }

  void clearProgramPayments() {
    _programPayments = null;
    notifyListeners();
  }

  List<PaymentMethodModel>? get paymentMethods => _paymentMethods;

  void setPaymentMethods(List<PaymentMethodModel> paymentMethods) {
    _paymentMethods = paymentMethods;
    notifyListeners();
  }

  void addPaymentMethod(PaymentMethodModel paymentMethod) {
    _paymentMethods!.add(paymentMethod);
    notifyListeners();
  }

  void removePaymentMethod(PaymentMethodModel paymentMethod) {
    _paymentMethods!.remove(paymentMethod);
    notifyListeners();
  }

  void clearPaymentMethods() {
    _paymentMethods = null;
    notifyListeners();
  }
}
