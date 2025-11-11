import 'package:bbb/values/app_constants.dart';

extension NavigationThroughString on String {
  Future<dynamic> pushName() async {
    return AppConstants.navigationKey.currentState?.pushNamed(
      this,
    );
  }
}
