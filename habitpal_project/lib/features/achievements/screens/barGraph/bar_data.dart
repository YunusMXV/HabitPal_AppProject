import 'package:habitpal_project/features/achievements/screens/barGraph/individual_bar.dart';

class BarData {
  final double sunHabit;
  final double monHabit;
  final double tueHabit;
  final double wedHabit;
  final double thurHabit;
  final double friHabit;
  final double satHabit;

  BarData({
    required this.sunHabit,
    required this.monHabit,
    required this.tueHabit,
    required this.wedHabit,
    required this.thurHabit,
    required this.friHabit,
    required this.satHabit,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {

    barData = [
      // Sunday
      IndividualBar(x:0, y:sunHabit),
      // Monday
      IndividualBar(x:1, y:monHabit),
      // Tuesday
      IndividualBar(x:2, y:tueHabit),
      // Wednesday
      IndividualBar(x:3, y:wedHabit),
      // Thursday
      IndividualBar(x:4, y:thurHabit),
      // Friday
      IndividualBar(x:5, y:friHabit),
      // Saturday
      IndividualBar(x:6, y:satHabit),
    ];
  }
}