import 'package:get/get.dart';
import 'package:musedme/screens/chat_screen.dart';
import 'package:musedme/screens/messages_screen.dart';

// SCREENS
import '../bindings/chat_bindings.dart';
import '../bindings/edit_profile_binding.dart';
import '../bindings/live_binding.dart';
import '../bindings/profile_binding.dart';
import '../bindings/search_binding.dart';
import '../bindings/root_bindings.dart';
import '../navigation/bottom_navigation.dart';
import '../navigation/profile_middle.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/live_screen.dart';
import '../screens/picker_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/search_users_screen.dart';
import '../screens/settings_screen.dart';

// ROUTE NAMES
import '../screens/profile/user_profile_screen.dart';
import 'app_routes.dart';

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
        binding: SearchBinding(),
        page: () => const SearchUserScreen()
    ),
    GetPage(
        name: AppRoutes.SETTINGS,
        page: () => const SettingScreen()
    ),
    GetPage(
        name: AppRoutes.PROFILE_EDIT,
        binding: EditProfileBinding(),
        page: () => const EditProfileScreen()
    ),

    GetPage(
        name: AppRoutes.LIVE,
        binding: LiveBinding(),
        page: () => const LiveScreen()
    ),
    GetPage(
        name: AppRoutes.PICKER,
        page: () => const EditorScreen()
    ),
    GetPage(
        name: AppRoutes.PROFILE,
        middlewares: [ProfileMiddle()],
        page: () => const ProfileScreen()
    ),
    GetPage(
        name: AppRoutes.USER_PROFILE,
        binding: ProfileBinding(),
        page: () => const UserProfileScreen()
    ),
    GetPage(
        name: AppRoutes.MESSAGES,
        // binding: MessagesBinding(),
        page: () => const MessagesScreen()
    ),
    GetPage(
        name: AppRoutes.CHAT,
        binding: ChatBinding(),
        page: () => const ChatScreen()
    ),
  ];
}