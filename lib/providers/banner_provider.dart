import 'package:flutter/cupertino.dart';
import '../models/banner_model.dart';
import '../services/banner_service.dart';

class BannerProvider extends ChangeNotifier {
  final BannerService service;
  List<BannerModel> banners = [];
  bool isLoading = false;

  BannerProvider(this.service);

  Future<void> loadBanners() async {
    isLoading = true;
    notifyListeners();

    banners = await service.fetchBanners();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addBanner(BannerModel b) async {
    await service.createBanner(b);
    await loadBanners();
  }

  Future<void> updateBanner(BannerModel b) async {
    if (b.id != null) await service.updateBanner(b.id!, b);
    await loadBanners();
  }

  Future<void> deleteBanner(int id) async {
    await service.deleteBanner(id);
    await loadBanners();
  }
}
