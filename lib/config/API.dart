class API {
  //static const String HOST = "192.168.1.3:8000";
  static const String HOST = "admin.khadamatapk.com";
  static const String URL = "https://$HOST";
  static const String API_VERSION = "v1";
  static const String API_URL = "$URL/api/$API_VERSION";

  static const String PRIVACY_URL = "$API_URL/pages/privacy";
  static const String ABOUT_URL = "$API_URL/pages/about";
  static const String TERMS_URL = "$API_URL/pages/terms";
  static const String LOGIN_URL = "$API_URL/login";
  static const String UPDATE_ITEM_URL = "$API_URL/items/update/";
  static const String UNARCHIVE_ITEM_URL = "$API_URL/items/unarchive/";
  static const String ARCHIVE_ITEM_URL = "$API_URL/items/archive/";
  static const String PROFILE_ARCHIVED_ITEMS_URL = "$API_URL/profile/archived";
  static const String PHONE_LOGIN_URL = "$API_URL/login/phone";
  static const String LOGIN_GOOGLE_URL = "$API_URL/login/google";
  static const String LOGIN_FACEBOOK_URL = "$API_URL/login/facebook";
  static const String REGISTER_URL = "$API_URL/register";
  static const String ADD_POINTS_URL = "$API_URL/profile/add/points";
  static const String REGISTER_GOOGLE_URL = "$API_URL/register/google";
  //static const String REGISTER_FACEBOOK_URL = "$API_URL/register/facebook";
  static const String RESET_PASSWORD_URL = "$API_URL/reset-password";
  static const String CHANGE_PASSWORD_URL = "$API_URL/change-password";
  static const String CATEGORIES_URL = "$API_URL/categories";
  static const String SELECT_CATEGORIES_URL = "$API_URL/categories/select";
  static const String SELECT_SUBCATEGORIES_URL = "$API_URL/subcategories/select";
  static const String SELECT_SUBSUBCATEGORIES_URL = "$API_URL/subsubcategories/select";
  static const String SUBCATEGORIES_URL = "$API_URL/subcategories";
  static const String PHONE_VERIFIED_URL = "$API_URL/phone-verified";
  static const String SUBSUBCATEGORIES_URL = "$API_URL/subsubcategories";
  static const String ITEMS_URL = "$API_URL/items";
  static const String GET_ITEM_URL = "$API_URL/items/show/";
  static const String SEARCH_ITEMS_URL = "$API_URL/items/search";
  static const String USER_PROFILE_URL = "$API_URL/user/";
  static const String USER_ITEMS_URL = "$API_URL/user/items/";
  static const String SEARCH_CATEGORY_ITEMS_URL = "$API_URL/items/subsubcategory/search";
  static const String COIN_PACKS_URL = "$API_URL/coinPacks";
  static const String STOP_SPONSORED_ITEM_URL = "$API_URL/items/stop-sponsored";
  static const String START_SPONSORED_ITEM_URL = "$API_URL/items/start-sponsored";
  static const String ADD_ITEM_URL = "$API_URL/items";
  static const String DELETE_ITEM_URL = "$API_URL/profile/items/delete";
  static const String PROFILE_ITEMS_URL = "$API_URL/profile/items";
  static const String GET_USER_PHONE = "$API_URL/profile/phone";
  static const String CHECK_USER_URL = "$API_URL/profile/check";
  static const String UPDATE_PHOTO_URL = "$API_URL/profile/update/photo";
  static const String UPDATE_NAME_URL = "$API_URL/profile/update/name";
  static const String PROFILE_URL = "$API_URL/profile";
  static const String UPDATE_PROFILE_URL = "$API_URL/login";
  static const String VIEW_CATEGORY_URL = "$API_URL/categories";
  static const String VIEW_SUBCATEGORY_URL = "$API_URL/subcategories";
  static const String VIEW_SUBSUBCATEGORY_URL = "$API_URL/subsubcategories";
  static const String VIEW_SUBCATEGORY_SPONSORED_URL = "$API_URL/subcategories/sponsored";
  static const String VIEW_ITEM_URL = "$API_URL/items";
  static const String IMAGES_URL = "$URL/uploads/images";
  static const String VIDEOS_URL = "$URL/uploads/videos";


  static const String FILM_CATEGORIES_URL = "$API_URL/films/categories";
  static const String FILMS_URL = "$API_URL/films/get/";
  static const String SERIES_CATEGORIES_URL = "$API_URL/series/categories";
  static const String SERIES_URL = "$API_URL/series/get/";
  static const String SERIES_EPISODES_URL = "$API_URL/series/episodes/";

}