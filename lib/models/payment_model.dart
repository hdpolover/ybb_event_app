// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  String? id;
  String? participantId;
  String? programPaymentId;
  String? paymentMethodId;
  String? status;
  String? proofUrl;
  String? accountName;
  String? amount;
  dynamic sourceName;
  String? isActive;
  String? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  PaymentModel({
    this.id,
    this.participantId,
    this.programPaymentId,
    this.paymentMethodId,
    this.status,
    this.proofUrl,
    this.accountName,
    this.amount,
    this.sourceName,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        participantId: json["participant_id"],
        programPaymentId: json["program_payment_id"],
        paymentMethodId: json["payment_method_id"],
        status: json["status"],
        proofUrl: json["proof_url"],
        accountName: json["account_name"],
        amount: json["amount"],
        sourceName: json["source_name"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "participant_id": participantId,
        "program_payment_id": programPaymentId,
        "payment_method_id": paymentMethodId,
        "status": status,
        "proof_url": proofUrl,
        "account_name": accountName,
        "amount": amount,
        "source_name": sourceName,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
