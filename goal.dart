class Goal {
  final String name;
  final double targetAmount;
  double currentAmount;

  Goal({
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
  });
}
