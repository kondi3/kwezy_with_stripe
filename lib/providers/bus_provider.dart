import 'package:kwezy_with_stripe/data/bus_data.dart';
import 'package:kwezy_with_stripe/models/bus_model.dart';

final List<BusModel> busesAvailable = busAvailableJson
    .asMap()
    .map((index, value) =>
        MapEntry(index, BusModel.fromMap(busAvailableJson[index])))
    .values
    .toList();
