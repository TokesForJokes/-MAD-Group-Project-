class Budget {
  final String category;
  final double limit;
  double spent;

  Budget({
    required this.category,
    required this.limit,
    this.spent = 0.0,
  });
}
