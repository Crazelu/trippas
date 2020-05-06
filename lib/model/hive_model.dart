import 'package:hive/hive.dart';
part 'hive_model.g.dart';

@HiveType()
class Trippas {
  @HiveField(0)
  String departure;
  @HiveField(1)
  String departureDate;
  @HiveField(2)
  String departureTime;
  @HiveField(3)
  String destination;
  @HiveField(4)
  String destinationDate;
  @HiveField(5)
  String destinationTime;
  @HiveField(6)
  String tripType;
  @HiveField(7)
  String name;

  Trippas(
      this.departure,
      this.departureDate,
      this.departureTime,
      this.destination,
      this.destinationDate,
      this.destinationTime,
      this.tripType,
      [this.name]);
}
