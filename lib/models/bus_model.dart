import 'package:kwezy_with_stripe/models/seat_model.dart';

class BusModel {
  late String? from;
  String? to;
  String? timeOfDepature;
  double? cost;
  List<dynamic>? seats;

  BusModel({
    this.from,
    this.to,
    this.timeOfDepature,
    this.cost,
    this.seats,
  });

  BusModel.fromMap(Map<String, dynamic> map) {
    from = map['from'] as String?;
    to = map['to'] as String?;
    timeOfDepature = map['timeOfDepature'] as String?;
    cost = map['cost'] as double?;
    seats = map['seats'].map((seats) => SeatModel.fromMap(seats)).toList();
  }
}
