import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/banner_model.dart';
import '../providers/banner_provider.dart';

class BannerFormScreen extends StatefulWidget {
  final BannerModel? banner;
  BannerFormScreen({this.banner});

  @override
  _BannerFormScreenState createState() => _BannerFormScreenState();
}

class _BannerFormScreenState extends State<BannerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late BannerModel _b;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _b = widget.banner != null
        ? BannerModel(
            id: widget.banner!.id,
            title: widget.banner!.title,
            description: widget.banner!.description,
            imageBase64: widget.banner!.imageBase64,
            link: widget.banner!.link,
            ctaText: widget.banner!.ctaText,
            bannerType: widget.banner!.bannerType,
            isVisible: widget.banner!.isVisible,
          )
        : BannerModel(
            title: '',
            description: '',
            imageBase64: '',
            bannerType: 'Slider',
          );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _b.imageBase64 = base64Encode(bytes);
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final prov = context.read<BannerProvider>();
    if (_b.id != null) {
      await prov.updateBanner(_b);
    } else {
      await prov.addBanner(_b);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.banner == null ? 'Add Banner' : 'Edit Banner'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CupertinoTextFormFieldRow(
                  placeholder: 'Title',
                  initialValue: _b.title,
                  onChanged: (v) => _b.title = v,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                CupertinoTextFormFieldRow(
                  placeholder: 'Description',
                  initialValue: _b.description,
                  onChanged: (v) => _b.description = v,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 12),
                CupertinoButton(
                  onPressed: _pickImage,

                  child: Text(
                    _b.imageBase64.isEmpty ? 'Pick Image' : 'Change Image',
                  ),
                ),
                if (_b.imageBase64.isNotEmpty)
                  Image.memory(base64Decode(_b.imageBase64), height: 120),
                SizedBox(height: 12),
                CupertinoFormRow(
                  prefix: Text('Type'),
                  child: CupertinoSegmentedControl<String>(
                    groupValue: _b.bannerType,
                    children: {
                      for (var t in [
                        'Slider',
                        'ShortAdd',
                        'LongAdd',
                        'Sales',
                        'Voucher',
                      ])
                        t: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(t),
                        ),
                    },
                    onValueChanged: (v) => setState(() => _b.bannerType = v),
                  ),
                ),
                CupertinoSwitch(
                  key: Key('isVisible'),
                  value: _b.isVisible,
                  onChanged: (v) => setState(() => _b.isVisible = v),
                ),
                SizedBox(height: 24),
                CupertinoButton.filled(
                  onPressed: _submitting ? null : _submit,

                  child: _submitting
                      ? CupertinoActivityIndicator()
                      : Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
