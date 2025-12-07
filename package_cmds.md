# Custom Hive Class
1. add @HiveType(typeId: x) to the custom class
2. @HiveField(0) to each variable
3. part 'filename.g.dart'; right under imports
4. dart run build_runner build
5. register adapter at initHive() in app_state.dart

# Update app icon
- dart run flutter_launcher_icons