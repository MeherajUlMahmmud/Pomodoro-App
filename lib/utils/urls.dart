class URLS {
  // static const String kBaseUrl = "http://192.168.0.108:8000/";
  // static const String kBaseUrl = "http://10.0.2.2:8000/api/";
  // static const String kBaseUrl = 'http://127.0.0.1:8000/api/';
  static const String kBaseUrl =
      'https://pomodoro-backend-8dpu.onrender.com/api/';

  // Auth
  static const String kAuthUrl = '${kBaseUrl}auth/';
  static const String kLoginUrl = '${kAuthUrl}login/';
  static const String kRegisterUrl = '${kAuthUrl}register/';
  static const String kRefreshTokenUrl = '${kAuthUrl}refresh/';

  // User
  static const String kUserUrl = '${kBaseUrl}user/';
}
