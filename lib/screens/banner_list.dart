import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/banner_provider.dart';
import 'banner_form.dart';

class BannerListScreen extends StatefulWidget {
  const BannerListScreen({super.key});
  @override
  _BannerListScreenState createState() => _BannerListScreenState();
}

class _BannerListScreenState extends State<BannerListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerProvider>().loadBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BannerProvider>();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Banners'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.add),
          onPressed: () async {
            final changed = await Navigator.push<bool>(
              context,
              CupertinoPageRoute(builder: (_) => BannerFormScreen()),
            );
            if (changed == true) provider.loadBanners();
          },
        ),
      ),
      child: provider.isLoading
          ? Center(child: CupertinoActivityIndicator())
          : ListView.builder(
              itemCount: provider.banners.length,
              itemBuilder: (_, i) {
                final b = provider.banners[i];
                return CupertinoListTile(
                  leading: CircleAvatar(
                    backgroundImage: MemoryImage(base64Decode(b.imageBase64)),
                  ),
                  title: Text(b.title),
                  subtitle: Text(b.bannerType),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(CupertinoIcons.pencil),
                        onPressed: () async {
                          final changed = await Navigator.push<bool>(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => BannerFormScreen(banner: b),
                            ),
                          );
                          if (changed == true) provider.loadBanners();
                        },
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(CupertinoIcons.delete),
                        onPressed: () async {
                          final confirm = await showCupertinoDialog<bool>(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: Text('Delete?'),
                              content: Text('Remove this banner?'),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text('Cancel'),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  child: Text('Delete'),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            provider.deleteBanner(b.id!);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
