class Environment {
  static const String baseUrl =
      'https://compulsory-brittne-siffrumm-ff72b09f.koyeb.app'; //no trailing slash please
  static const connectTimeout = 5000;
  static const receiveTimeout = 3000;

  static const headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const apiEndPoints = {
    'login': '/api/v1/login',
    'register': '/api/v1/register',
  };

  static const errorMessages = {'user_not_found': 'User not found'};
}
