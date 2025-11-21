import 'package:hive/hive.dart';
import 'package:nyoom/classes/data_models/bus_arrival.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 1)
class Bookmark {
  @HiveField(0)
  final String busService;

  @HiveField(1)
  final String busStopCode;

  @HiveField(2)
  final String roadName;

  @HiveField(3)
  final String busStopName;

  Bookmark({
    required this.busService,
    required this.busStopCode,
    required this.roadName,
    required this.busStopName,
  });

  factory Bookmark.fromBusDataModels(BusStop busStop, BusService busService) {
    return Bookmark(
      busService: busService.busService,
      busStopCode: busStop.busStopCode,
      roadName: busStop.roadName,
      busStopName: busStop.busStopName,
    );
  }
}

class BookmarkAT extends Bookmark {
  final BusArrivalService busArrivalService;

  BookmarkAT({
    required this.busArrivalService,
    required super.busService,
    required super.busStopCode,
    required super.roadName,
    required super.busStopName,
  });

  factory BookmarkAT.fromBookmark(
    Bookmark bookmark,
    BusArrivalService busArrivalService,
  ) {
    return BookmarkAT(
      busArrivalService: busArrivalService,
      busService: bookmark.busService,
      busStopCode: bookmark.busStopCode,
      roadName: bookmark.roadName,
      busStopName: bookmark.busStopName,
    );
  }
}
