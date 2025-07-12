import 'package:siffrum_sa/clients/api_client.dart';
import '../models/api_response.dart';
import '../models/random_user.dart';

class RandomUserService {
  Future<ApiResponse<RandomUser>> fetchRandomUser() {
    return ApiClient.get<RandomUser>(
      '/api',
      decoder: (json) {
        final results = (json['results'] as List).cast<Map<String, dynamic>>();
        return RandomUser.fromJson(results.first);
      },
    );
  }
}
