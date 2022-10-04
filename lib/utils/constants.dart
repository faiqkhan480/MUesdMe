class Constants {
  // BASE URL
  static const String LIVE_URL = "https://musedme.helpinglab.com:6868";
  static const String BASE_URL = LIVE_URL;
  static const String IMAGE_URL = "https://musedme.helpinglab.com:6969/assets/Uploads/profile/";
  static const String FEEDS_URL = "https://musedme.helpinglab.com:6969/Uploads/Files/";

  ///AUTHENTICATION URLS
  static const String LOGIN = "$BASE_URL/api/Users/AuthenticateUser";
  static const String REGISTER = "$BASE_URL/api/Users/SignUp";
  static const String USER_DETAILS = "$BASE_URL/api/Users/BindUserDetails";
  static const String UPDATE_USER = "$BASE_URL/api/Users/UpdateUser";
  static const String GET_RTM = "$BASE_URL/api/Agora/GetRTMToken";
  static const String GET_RTC = "$BASE_URL/api/Agora/GetRTCToken";


  // POSTS
  static const String FEEDS = "$BASE_URL/api/Feed/GetAllFeeds";
  static const String SERACH_USER = "$BASE_URL/api/Users/BindUserByName";
  static const String FOLLOW_USER = "$BASE_URL/api/Users/FollowUser";
  static const String UN_FOLLOW_USER = "$BASE_URL/api/Users/UnFollowUser";

  static const String fontFamily = "Larsseit";
  static const String dummyImage = "https://cdn.hswstatic.com/gif/play/0b7f4e9b-f59c-4024-9f06-b3dc12850ab7-1920-1080.jpg";
  static const String greenVector = "https://www.wallpapertip.com/wmimgs/188-1884481_green-blue.jpg";
  static const String coverImage = "https://www.history.com/.image/c_fit%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_620/MTY1MTc3MjE0MzExMDgxNTQ1/topic-golden-gate-bridge-gettyimages-177770941.jpg";
  static const String albumArt = "https://legiit-service.s3.amazonaws.com/a3444aabc35417cbb401fc4fbb7148ba/3b9307a4d28eebc3dfff71d319423997.jpg";

  // AGORA CREDENTIALS
  static const String testChanel = "demo";
  static const String appId = 'd7c60d2d306241c49386d0f998fffb4f';
  static const String rtcToken = '007eJxTYAjpnWBqzFj6fKtsAduCeO4aW6kzR8/Ok3pY1MDj92bBlW0KDCnmyWYGKUYpxgZmRiaGySaWxhZmKQZplpYWaWlpSSZp/XwayXwJmskBm4KZmBgYGViAGMRnApPMYJIFSqak5uYzMLAygAAAvtMg5g==';
  static const String rtmToken = '006d7c60d2d306241c49386d0f998fffb4fIAAmKhKpv+9q+LGr9zm6vqiLGO7ZKaK7DMEiQQgEXrR89cJBJDUAAAAAEABdcOmd72YpYwEA6APvZilj';
}