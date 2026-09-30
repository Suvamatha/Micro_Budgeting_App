class Setting {
  final double initialBalance;
  final String currency;
  final DateTime trackingStartDate;
  final int calculateWindowDays;

  Setting({
    required this.initialBalance,
    required this.currency,
    required this.trackingStartDate,
    required this.calculateWindowDays,
  });
}