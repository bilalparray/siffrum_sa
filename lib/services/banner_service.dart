import 'package:dio/dio.dart';
import '../models/banner_model.dart';
import '../constants/environment.dart';

class BannerService {
  final Dio _dio;
  // Use endpoint from Environment
  final String _endpoint = Environment.apiEndPoints['banner']!;

  BannerService(this._dio) {
    print('✅ BannerService created with endpoint: $_endpoint');
  }

  /// Fetch all banners
  Future<List<BannerModel>> fetchBanners() async {
    final res = await _dio.get('$_endpoint/getall');
    if (res.statusCode != 200) {
      throw Exception(res.data['errorData']);
    }
    return (res.data['successData'] as List)
        .map((json) => BannerModel.fromJson(json))
        .toList();
  }

  /// Create a new banner
  Future<BannerModel> createBanner(BannerModel banner) async {
    final body = {
      'reqData': {
        'title': banner.title,
        'description': banner.description,
        'imageBase64': banner.imageBase64,
        'link': banner.link,
        'ctaText': banner.ctaText,
        'bannerType': banner.bannerType,
        'isVisible': banner.isVisible,
      },
    };
    final res = await _dio.post('$_endpoint/create', data: body);
    return BannerModel.fromJson(res.data['successData']);
  }

  /// Update an existing banner
  Future<BannerModel> updateBanner(int id, BannerModel banner) async {
    final body = {
      'reqData': {
        'title': banner.title,
        'description': banner.description,
        'imageBase64': banner.imageBase64,
        'link': banner.link,
        'ctaText': banner.ctaText,
        'bannerType': banner.bannerType,
        'isVisible': banner.isVisible,
      },
    };
    final res = await _dio.put('$_endpoint/update/$id', data: body);
    return BannerModel.fromJson(res.data['successData']);
  }

  /// Delete a banner by ID

  Future<void> deleteBanner(int id) async {
    final url = '$_endpoint/delete/$id';
    print('🗑️ DELETE URL: $url');
    await _dio.delete(url);
  }
}
