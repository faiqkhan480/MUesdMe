import 'package:get/get.dart';

// SCREENS
import '../navigation/bottom_navigation.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/live_screen.dart';
import '../screens/picker_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_users_screen.dart';
import '../screens/settings_screen.dart';

// ROUTE NAMES
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
        name: AppRoutes.ROOT,
        // binding: RootBinding(),
        page: () => const BottomNavigation()
    ),
    GetPage(
        name: AppRoutes.FEEDS,
        // binding: CountriesBinding(),
        page: () => const FeedScreen()
    ),
    GetPage(
        name: AppRoutes.SEARCH,
        // binding: HomeBindings(),
        page: () => const SearchUserScreen()
    ),
    GetPage(
        name: AppRoutes.SETTINGS,
        page: () => const SettingScreen()
    ),
    GetPage(
        name: AppRoutes.PROFILE_EDIT,
        page: () => const EditProfileScreen()
    ),

    GetPage(
        name: AppRoutes.LIVE,
        page: () => const LiveScreen()
    ),
    GetPage(
        name: AppRoutes.PICKER,
        page: () => const EditorScreen()
    ),
    GetPage(
        name: AppRoutes.PROFILE,
        page: () => const ProfileScreen()
    )
  ];
}