import 'package:get/get.dart';
import 'package:musedme/screens/auth/login_screen.dart';
import 'package:musedme/screens/auth/register_screen.dart';

// SCREENS
import '../bindings/profile_binding.dart';
import '../bindings/root_bindings.dart';
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
import 'auth_gard.dart';

class AppPages {
  static var list = [
    GetPage(
        name: AppRoutes.ROOT,
        binding: RootBinding(),
        // middlewares: [
        //   AuthGuard(),
        // ],
        page: () => const BottomNavigation()
    ),
    GetPage(
        name: AppRoutes.LOGIN,
        // middlewares: [
        //   AuthGuard(),
        // ],
        page: () => const LoginScreen()
    ),
    GetPage(
        name: AppRoutes.REGISTER,
        // middlewares: [
        //   AuthGuard(),
        // ],
        page: () => const RegisterScreen()
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
        binding: ProfileBinding(),
        page: () => const ProfileScreen()
    )
  ];
}