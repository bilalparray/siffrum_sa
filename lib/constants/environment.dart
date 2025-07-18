class Environment {
  // static const String baseUrl =
  //     'https://compulsory-brittne-siffrumm-ff72b09f.koyeb.app'; //no trailing slash please
  static const String baseUrl = 'http://192.168.29.101:3000';
  static const connectTimeout = 5000;
  static const receiveTimeout = 30000;

  static const headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const apiEndPoints = {
    'login': '/api/v1/login',
    'register': '/api/v1/register',
    'banner': '/api/v1/banner',
  };

  static const errorMessages = {'user_not_found': 'User not found'};
}
