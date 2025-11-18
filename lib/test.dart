import 'package:nyoom/services/api_service.dart';

void testFunction() async {
  final data = await ApiService.busArrival("46971");
  print(data);
}