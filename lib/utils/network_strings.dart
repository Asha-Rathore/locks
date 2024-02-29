import 'package:locks_hybrid/utils/enums.dart';

class NetworkStrings {
  ////////////////////// API BASE URL //////////////////////////////////
  // Binate CPanel Api Base Url
  static const String API_BASE_URL =
      "https://server1.appsstaging.com/3559/locks/public/api/";

  // Binate Network Image Url
  static const String NETWORK_IMAGE_BASE_URL =
      "https://server1.appsstaging.com/3559/locks/public/storage/";

  //Sports Db Api Key
  static const String SPORTS_DB_API_KEY = "60130162";

  //Sports Db Api Base Url
  static const String SPORTS_DB_API_BASE_URL =
      "https://www.thesportsdb.com/api/v1/json/$SPORTS_DB_API_KEY/";

  //Sports Db Live Event Api Base Url
  static const String SPORTS_DB_LIVE_EVENTS_API_BASE_URL =
      "https://www.thesportsdb.com/api/v2/json/$SPORTS_DB_API_KEY/";

  //News Api Base Url
  static const String NEWS_API_BASE_URL =
      "http://site.api.espn.com/apis/site/v2/sports/";


  //Standings Api Base Url
  static const String STANDINGS_API_BASE_URL =
      "https://api.sportsdata.io/";



  ////////////////////// Network Image Base Url ///////////////////////////////////
  //Technado CPanel Image URL
  // static const String NETWORK_IMAGE_BASE_URL =
  //     "https://server.appsstaging.com/1461/stock_leo/public";

  /////// API HEADER TEXT ////////////////////////
  static const String ACCEPT = 'application/json';

  ////// API STATUS CODE/////////////
  static const int SUCCESS_CODE = 200;
  static const int UNAUTHORIZED_CODE = 401;
  static const int CARD_ERROR_CODE = 402;
  static const int BAD_REQUEST_CODE = 400;
  static const int FORBIDDEN_CODE = 403;

  /////////// API MESSAGES /////////////////
  static const int API_SUCCESS_STATUS = 1;
  static const int EMAIL_UNVERIFIED = 0;
  static const int EMAIL_VERIFIED = 1;
  static const int PROFILE_INCOMPLETED = 0;
  static const int PROFILE_COMPLETED = 1;
  static const int ASSESSMENT_INCOMPLETED = 0;
  static const int ASSESSMENT_COMPLETED = 1;

  ///////////////// API MAIN ENDPOINTS
  //static const String AUTH_ENDPOINT = "auth";

  ////////////////////// API ENDPOINTS  ////////////////////////

  // Binate API ENDPOINTS
  static const String LOGIN_ENDPOINT = "login";
  static const String SOCIAL_LOGIN_ENDPOINT = "social-login";
  static const String VERIFY_OTP_ENDPOINT = "verification";
  static const String RESEND_OTP_ENDPOINT = "resend-otp";
  static const String COMPLETE_PROFILE_ENDPOINT = "complete-profile";
  static const String LOGOUT_ENDPOINT = "logout";
  static const String DELETE_ACCOUNT_ENDPOINT = "delete-account";
  static const String CONTENT_ENDPOINT = "content";
  static const String NOTIFICATION_ENABLE_ENDPOINT = "enable-notifications";
  static const String LEAGUES_ENDPOINT = "leagues";
  static const String NOTIFICATION_ENDPOINT = "notifications";

  // Sports Db API ENDPOINTS
  static const String LEAGUES_DETAIL_ENDPOINT = "lookupleague.php";
  static const String SEASON_ENDPOINT = "search_all_seasons.php";
  static const String TEAMS_ENDPOINT = "search_all_teams.php";
  static const String TEAMS_DETAIL_ENDPOINT = "lookupteam.php";
  static const String TEAM_MEMBERS_ENDPOINT = "lookup_all_players.php";
  static const String LEAGUE_UPCOMING_EVENTS_ENDPOINT = "eventsnextleague.php";
  static const String LEAGUE_LATEST_RESULT_EVENTS_ENDPOINT =
      "eventspastleague.php";
  static const String TEAM_UPCOMING_EVENTS_ENDPOINT = "eventsnext.php";
  static const String TEAM_LATEST_RESULT_EVENTS_ENDPOINT = "eventslast.php";
  static const String SEASON_EVENTS_ENDPOINT = "eventsseason.php";
  static const String CAREER_HONOURS_ENDPOINT = "lookuphonours.php";
  static const String CAREER_MILESTONES_ENDPOINT = "lookupmilestones.php";
  static const String FORMER_TEAM_ENDPOINT = "lookupformerteams.php";

  //News ENDPOINTS
  static const String NFL_NEWS_ENDPOINT = "football/nfl/news";
  static const String MLB_NEWS_ENDPOINT = "baseball/mlb/news";
  static const String NHL_NEWS_ENDPOINT = "hockey/nhl/news";
  static const String NBA_NEWS_ENDPOINT = "basketball/nba/news";
  static const String MLS_NEWS_ENDPOINT = "soccer/usa.1/news";

  static Map<String, dynamic> NEWS_ENDPOINTS_LIST = {
    LeagueType.NBA.name: NBA_NEWS_ENDPOINT,
    LeagueType.NFL.name: NFL_NEWS_ENDPOINT,
    LeagueType.MLS.name: MLS_NEWS_ENDPOINT,
    LeagueType.MLB.name: MLB_NEWS_ENDPOINT,
    LeagueType.NHL.name: NHL_NEWS_ENDPOINT
  };

  static const String ERROR_NEWS_ENDPOINT = "football/nffl/news";

  // Sports Db LIVE SCORE ENDPOINT
  static const String LIVE_SCORE_ENDPOINT = "livescore.php";



  //Standings ENDPOINTS
  static const String NFL_STANDINGS_ENDPOINT = "v3/nfl/scores/json/Standings";
  static const String MLB_STANDINGS_ENDPOINT = "v3/mlb/scores/json/Standings";
  static const String NHL_STANDINGS_ENDPOINT = "v3/nhl/scores/json/Standings";
  static const String NBA_STANDINGS_ENDPOINT = "v3/nba/scores/json/Standings";
  static const String MLS_STANDINGS_ENDPOINT = "v4/soccer/scores/json/Standings/MLS";


  static Map<String, dynamic> STANDINGS_ENDPOINTS_LIST = {
    LeagueType.NBA.name: NBA_STANDINGS_ENDPOINT,
    LeagueType.NFL.name: NFL_STANDINGS_ENDPOINT,
    LeagueType.MLS.name: MLS_STANDINGS_ENDPOINT,
    LeagueType.MLB.name: MLB_STANDINGS_ENDPOINT,
    LeagueType.NHL.name: NHL_STANDINGS_ENDPOINT
  };


  static Map<String, dynamic> STANDINGS_API_KEYS_LIST = {
    LeagueType.NBA.name: "216d4e81379146aca918248c2232643d",
    LeagueType.NFL.name: "b985a9e1007444ef819cba30d5e88990",
    LeagueType.MLS.name: "146119a79fa548b69110cad1c2dc0a9c",
    LeagueType.MLB.name: "59505ca30d76409b8e75e6ba71868769",
    LeagueType.NHL.name: "7424d40de51f4e8abaf848268fa539a6"
  };


  ////////////////////// API ENDPOINTS  ////////////////////////

  /////////// API TOAST MESSAGES //////////////////
  static const String NO_INTERNET_CONNECTION = "No Internet Connection!";
  static const String SOMETHING_WENT_WRONG = "Something went wrong!";
  static const String NETWORK_ERROR = "Network error!";
  static const String INVALID_CARD_ERROR = "Invalid Card Details.";
  static const String INVALID_BANK_ACCOUNT_DETAILS_ERROR =
      "Invalid Bank Account Details.";

  //---------------- API SHOW ERROR MESSAGE -------------------//
  static const String DATA_NOT_FOUND_ERROR = "No data found.";

  ///////////////////// CONTENT QUERY PARAMETERS /////////////////
  static const String TERMS_AND_CONDITIONS_CONTENT_PARAMETER =
      "terms-and-conditions";
  static const String PRIVACY_POLICY_CONTENT_PARAMETER = "privacy-policy";

/////////////// SOCKET EMIT EVENTS ////////////////
//   static const String GET_MESSAGES_EVENT = "get_messages";
//   static const String SEND_MESSAGE_EVENT = "send_message";

/////////////// SOCKET RESPONSE KEYS ////////////////
// static const String GET_MESSAGES_KEY = "get_messages";
// static const String GET_MESSAGE_KEY = "get_message";
}
