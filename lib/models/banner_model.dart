class BannerModel {
  final int? id;
  String title;
  String description;
  String imageBase64;
  String? link;
  String? ctaText;
  String bannerType;
  bool isVisible;

  BannerModel({
    this.id,
    required this.title,
    required this.description,
    required this.imageBase64,
    this.link,
    this.ctaText,
    required this.bannerType,
    this.isVisible = true,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json['id'] as int?,
    title: json['title'] as String,
    description: json['description'] as String,
    imageBase64: json['imageBase64'] as String,
    link: json['link'] as String?,
    ctaText: json['ctaText'] as String?,
    bannerType: json['bannerType'] as String,
    isVisible: json['isVisible'] as bool,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
    'imageBase64': imageBase64,
    if (link != null) 'link': link,
    if (ctaText != null) 'ctaText': ctaText,
    'bannerType': bannerType,
    'isVisible': isVisible,
  };
}
