import 'package:flutter/material.dart';

const appStoreIdentifier = '1532641266';
const googlePlayIdentifier = 'sofy.vibrator.app';
const feedbackEmail = 'sofy1.app@gmail.com';

// const Fonts.ProximaNova = 'Proxima Nova';
// const Fonts.Kalam = 'Kalam';
// const Fonts.Exo2 = 'Exo 2';
// const Fonts.GilroyBold = 'Gilroy Bold';
// const Fonts.Gilroy = 'Gilroy';
// const Fonts.MontserratSemi = 'Montserrat Semi';
// const Fonts.MontserratBold = 'Montserrat Bold';
// const Fonts.Montserrat = 'Montserrat';
class Fonts {
  static const HindGuntur = 'Hind Guntur';
  static const HindGunturBold = 'Hind Guntur Bold';
  static const HindGunturSemiBold = 'Hind Guntur SemiBold';
  static const Roboto = 'Roboto';
  static const RobotoBold = 'Roboto Bold';
  static const Allerta = 'Allerta';
  static const AllertaRegular = 'Allerta';
  static const ProximaNova = 'Proxima Nova';
  static const Kalam = 'Kalam';
  static const Exo2 = 'Exo 2';
  static const GilroyBold = 'Gilroy Bold';
  static const Gilroy1 = 'Gilroy1';
  static const Gilroy = 'Gilroy';
  static const MontserratSemi = 'Montserrat Semi';
  static const MontserratBold = 'Montserrat Bold';
  static const Montserrat = 'Montserrat';
  static const AbhayaLibreExtraBold = 'Abhaya Libre ExtraBold';
  static const Exo2Bold = 'Exo 2 Bold';
  static const SFProMedium = 'SF Pro Medium';
  static const SFProBold = 'SF Pro Bold';
}

const kUrlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
const List<double> kInitSpeedValues = [
  4,
  3.9,
  3.8,
  3.7,
  3.6,
  3.5,
  3.4,
  3.3,
  3.2,
  3.1,
  3,
  2.9,
  2.8,
  2.7,
  2.6,
  2.5,
  2.4,
  2.3,
  2.2,
  2.1,
  2,
  1.9,
  1.8,
  1.7,
  1.6,
  1.5,
  1.4,
  1.3,
  1.2,
  1.1,
  1,
  0.9,
  0.8,
  0.7,
  0.6,
  0.5,
  0.4,
  0.3,
  0.2,
  0.1
];
const kSliderSpeedValue = 62;
const kSpeedValuesPosition = 30;
const kIsLoop = false;
const kVibrationPosition = 0;
const kCurrentPlayTime = 0;
const kDurationAllVibration = 0;
const kSpeedDurationDefault = 30;
const kSpeedDurationInterval = 30;

const int DEFAULT_VIBRATION_DURATION = 600;

const int ArticlesScreen_PAGE_INDEX = 0;
const int PlayerScreen_PAGE_INDEX = 1;
const int SettingsScreen_PAGE_INDEX = 2;
const int PlayListScreen_PAGE_INDEX = 4;
const int RecommendationScreen_PAGE_INDEX = 5;
const int MyPlaylistScreen_PAGE_INDEX = 3;

const DEFAULT_DURATION = const Duration(milliseconds: 100);
const DEFAULT_CURVE = Curves.linear;

const double MIN_DEPTH = -20.0;
const double MAX_DEPTH = 20.0;

const double MIN_INTENSITY = 0.0;
const double MAX_INTENSITY = 1.0;

const double MIN_CURVE = 0.0;
const double MAX_CURVE = 1.0;

const KEY_USER_TOKEN = "user_token";
const KEY_FAVORITES = "favorites";
const KEY_ADD_FAVOR = "favorite";
const KEY_FIRST_INIT = "first_init";
const KEY_SESSIONS = "sessions";

const KEY_USER_ID = "user_id";
const KEY_USER_NAME = "user_name";
const KEY_USER_MAIL = "user_mail";
const KEY_USER_PASS = "user_pass";
const KEY_USER_PHOTO = "user_photo";
const KEY_USER_AUTH_TOKEN = "user_auth_token";
const KEY_USER_AVA_NUMBER = "user_ava_number";
const KEY_USER_AVA_COLOR = "user_ava_color";

const KEY_ANON_AUTH_TOKEN = "anon_auth_token";
const KEY_ANON_NAME = "anon_name";

const KEY_DB_VERSION = "db_version";

const kProximaNovaTextStyle = TextStyle(
  height: 1.85,
  fontFamily: 'Proxima Nova',
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
);

bool isRateShowing = true;
int standardPlaylistId = 0;

const double kHorizButPadding = 15.0;
const double kMainScreenTopImageContHeight = 253.00;

const String kAppmetricaSdkApiKey = '88477e76-0ca3-4eb3-98fb-c271b8ef6051';
const String kAmplitudeFlutterApiKey = '1e7c869394652c8fe58b0857da11106d';
const String kTenjinFlutterApiKey = 'ESDVC9YTT4285BWUM2SWBBH8EAW5WJBY';

const String kQonversionSdkApiKey = 'BgkZ-H3cZBLerSqF6vhxb-xnVNfrb18S';
const String kCatSdkApiKey = 'omjpjHtHQsbODxoYFLqUCsLvZrMjlsOL';

const int kPageAnimDuration = 700;
const Curve kPageAnimateCurves = Curves.linear;

const String application_start = 'application_start';
const String onbording_screen_1_show = 'onbording_screen_1_show';
const String onbording_screen_2_show = 'onbording_screen_2_show';
const String onbording_screen_3_show = 'onbording_screen_3_show';
const String onbording_screen_4_show = 'onbording_screen_4_show';
const String onbording_screen_5_show = 'onbording_screen_5_show';
const String onbording_splash_show = 'onbording_splash_show';

const String onbording_subscription_splash_show = 'onboarding_splash_show';
const String onbording_subscription_splash_close_click = 'onboarding_splash_close_click';
const String subscription_splash_show = 'splash_show';
const String subscription_splash_close_click = 'splash_close';
const String subscription_purchase_y_click = 'purchase_y_';
const String subscription_purchase_m_click = 'purchase_w';
//const String subscription_purchased = 'subscription_purchased';

//const String subscription_month_purchased = 'subscription_month_purchased';
//const String subscription_year_purchased = 'subscription_year_purchased';

//const String subscription_fail = 'subscription_fail';
//const String subscription_restore_fail = 'restore_fail';

const String subscription_restore_click = 'restore';
//const String subscription_restored = 'restored';
const String main_screen_show = 'main_screen_show';
const String vibration_previous = 'vibration_previous';
const String playlist_current_click = 'current_playlist';
const String like_vibration = 'like_vibration';
const String playlist_current_screen_show = 'modes_screen_show';
//const String playlist_current_screen_close = 'modes_screen_close';
const String modes_screen_show = 'modes_screen_show';
//const String playlist_palette_click = 'playlist_palette_click';
//const String playlist_festival_click = 'playlist_festival_click';
//const String playlist_music_click = 'playlist_music_click';
//const String playlist_favourite_click = 'playlist_favourite_click';
//const String playlist_palette_screen_show = 'playlist_palette_screen_show';
//const String like_playlist = 'like_playlist';
//const String playlist_palette_screen_close = 'playlist_palette_screen_close';
//const String playlist_festilal_screen_show = 'playlist_festilal_screen_show';
//const String playlist_festival_screen_close = 'playlist_festival_screen_close';
//const String playlist_music_screen_show = 'playlist_music_screen_show';
//const String playlist_music_screen_close = 'playlist_music_screen_close';
//const String playlist_favourite_screen_show = 'playlist_favourite_screen_show';
//const String playlist_favourite_screen_close = 'playlist_favourite_screen_close';
const String settings_screen_show = 'settings_screen_show';
const String banner_show = 'banner_show';
const String banner_click = 'banner_click';
const String not_vibrating_click = 'not_vibrating_click';
const String rate_us_click = 'rate_us_click';
const String send_feedback_click = 'send_feedback_click';
const String share_click = 'share_click';

class EventsOfAnalytics {
  static const String article_show = 'article_show'; // показ статьи
  static const String share_article_click = 'share_article_click'; // поделиться статьей кнопка в правом верхнем углу
  static const String go_to_stories_click = 'go_to_stories_click'; // перейти к историям - кнопка на экране статьи
  static const String reply_click = 'reply_click'; //
  static const String send_stories = 'send_stories'; // ответ на историю (вопрос)
  static const String show_stories = 'show_stories';
  static const String articles_feedback = 'articles_feedback';
  static const String splash_show = 'splash_show';
  static const String show_articles_categories = 'show_articles_categories';
  static const String show_all_articles_categories = 'show_all_articles_categories';
  static const String comments_btn_click = 'comments_btn_click';
  static const String questions_btn_click = 'questions_btn_click';
  static const String comment_order_click = 'comment_order_click';
  static const String comment_dislike_click = 'comment_dislike_click';
  static const String comment_like_click = 'comment_like_click';
  static const String comment_send_reply_click = 'comment_send_reply_click';
  static const String article_readed = 'article_readed'; // статья пролистана до конца
  static const String vote_variant_selected = 'vote_selected'; // ВЫБРАН вариант ответа в голосовании
  static const String show_answer_story_screen = 'show_answer_story_screen'; // показан экран ответа на историю
  static const String cancel_answer_story_screen = 'cancel_answer_story_screen'; // на историю не стали отвечать на заходили на экран ответа
  static const String bottom_bar_click = 'bottom_bar_click'; // переход с вкладки на вкладку
  static const String show_create_account_screen = 'show_create_account_screen'; // показан экран создания аккаунта
  static const String show_sign_in_screen = 'show_sign_in_screen'; // показан экран входа
  static const String sign_in_click = 'sign_in_click'; // клик по кнопке входа
  static const String forgot_pass_click = 'forgot_pass_click'; // клик по кнопке входа
  static const String sign_up_click = 'sign_up_click'; // клик по кнопке входа
// плеер
  static const String vibration_pause = 'vibration_pause'; //  вибрации на паузу
  static const String vibration_play = 'vibration_play'; // вибрации на плей
  static const String vibration_next = 'vibration_next'; // следующая вибрация
  static const String locked_slider_click = 'locked_slider_click'; // клик по заблокированному слайдеру переключатля скорости
  static const String vibration_set_to_value = 'vibration_set_to_value'; // вибрация установлена на значение
  static const String vibration_mode = 'vibration_mode'; // выбран список вибраций с vibration_id


}

class Layout {
  static const height = 896;
  static const width = 416;
  static const multiplier = 100;
}

const String monthly_purchase_key = "Monthly access";
const String annual_purchase_key = "Annual access";

const List<int> equalizerValues = [59, 108, 80, 44, 35, 28, 17, 17, 35, 28, 17, 17, 24, 48, 35, 24, 20, 17, 17, 10];
