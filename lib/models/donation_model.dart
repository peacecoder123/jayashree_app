import '../core/enums/status.dart';

class DonationModel {
  final String id;
  final String donorName;
  final String purpose;
  final double amount;
  final String paymentMode; // Cash, Online, Cheque
  final DateTime date;
  final bool is80GEligible;
  final bool receiptGenerated;

  const DonationModel({
    required this.id,
    required this.donorName,
    required this.purpose,
    required this.amount,
    required this.paymentMode,
    required this.date,
    required this.is80GEligible,
    required this.receiptGenerated,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) => DonationModel(
        id: json['id'] as String,
        donorName: json['donorName'] as String,
        purpose: json['purpose'] as String,
        amount: (json['amount'] as num).toDouble(),
        paymentMode: json['paymentMode'] as String,
        date: DateTime.parse(json['date'] as String),
        is80GEligible: json['is80GEligible'] as bool? ?? false,
        receiptGenerated: json['receiptGenerated'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'donorName': donorName,
        'purpose': purpose,
        'amount': amount,
        'paymentMode': paymentMode,
        'date': date.toIso8601String(),
        'is80GEligible': is80GEligible,
        'receiptGenerated': receiptGenerated,
      };

  DonationModel copyWith({
    String? id,
    String? donorName,
    String? purpose,
    double? amount,
    String? paymentMode,
    DateTime? date,
    bool? is80GEligible,
    bool? receiptGenerated,
  }) =>
      DonationModel(
        id: id ?? this.id,
        donorName: donorName ?? this.donorName,
        purpose: purpose ?? this.purpose,
        amount: amount ?? this.amount,
        paymentMode: paymentMode ?? this.paymentMode,
        date: date ?? this.date,
        is80GEligible: is80GEligible ?? this.is80GEligible,
        receiptGenerated: receiptGenerated ?? this.receiptGenerated,
      );

  DonationStatus get donationStatus =>
      receiptGenerated ? DonationStatus.receiptGenerated : DonationStatus.receiptPending;

  String get formattedAmount => '₹${amount.toStringAsFixed(0)}';
}
