import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/banner_model.dart';
import '../providers/banner_provider.dart';

class BannerFormScreen extends StatefulWidget {
  final BannerModel? banner;

  const BannerFormScreen({Key? key, this.banner}) : super(key: key);

  @override
  _BannerFormScreenState createState() => _BannerFormScreenState();
}

class _BannerFormScreenState extends State<BannerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkController;
  late TextEditingController _ctaController;
  String _bannerType = 'Slider';
  bool _isVisible = true;
  String _imageBase64 = '';
  bool _submitting = false;

  final List<String> _types = [
    'Slider',
    'Short Add',
    'Long Add',
    'Sales',
    'Voucher',
  ];

  @override
  void initState() {
    super.initState();
    final b = widget.banner;
    _titleController = TextEditingController(text: b?.title);
    _descriptionController = TextEditingController(text: b?.description);
    _linkController = TextEditingController(text: b?.link);
    _ctaController = TextEditingController(text: b?.ctaText);
    _bannerType = b?.bannerType ?? _bannerType;
    _isVisible = b?.isVisible ?? true;
    _imageBase64 = b?.imageBase64 ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _imageBase64 = base64Encode(bytes));
    }
  }

  void _showTypePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                backgroundColor: CupertinoColors.systemBackground.resolveFrom(
                  context,
                ),
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: _types.indexOf(_bannerType),
                ),
                onSelectedItemChanged: (i) => setState(() {
                  _bannerType = _types[i];
                }),
                children: _types.map((t) => Text(t)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final model = BannerModel(
      id: widget.banner?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      link: _linkController.text.trim(),
      ctaText: _ctaController.text.trim().isNotEmpty
          ? _ctaController.text.trim()
          : null,
      bannerType: _bannerType,
      isVisible: _isVisible,
      imageBase64: _imageBase64,
    );

    final provider = context.read<BannerProvider>();
    if (model.id != null) {
      await provider.updateBanner(model);
    } else {
      await provider.addBanner(model);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.banner == null ? 'Add Banner' : 'Edit Banner'),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Content Section
              const Text(
                'Content',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Title Field
              const Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              CupertinoTextFormFieldRow(
                controller: _titleController,
                placeholder: 'Enter banner title',
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              // Description Field
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              CupertinoTextFormFieldRow(
                controller: _descriptionController,
                placeholder: 'Enter a brief description',
                textInputAction: TextInputAction.next,
                maxLines: 2,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 12),
              // Image Picker
              const Text(
                'Image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _pickImage,
                child: Text(
                  _imageBase64.isEmpty ? 'Select Image' : 'Change Image',
                ),
              ),
              if (_imageBase64.isNotEmpty) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(_imageBase64),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ],

              const SizedBox(height: 24),
              // Settings Section
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Type Field
              const Text(
                'Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: _showTypePicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemBackground
                        .resolveFrom(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_bannerType),
                      const Icon(CupertinoIcons.chevron_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Visibility Switch
              const Text(
                'Visible',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              CupertinoSwitch(
                value: _isVisible,
                onChanged: (v) => setState(() => _isVisible = v),
              ),
              const SizedBox(height: 12),
              // Link Field
              const Text(
                'Link',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              CupertinoTextFormFieldRow(
                controller: _linkController,
                placeholder: 'https://example.com',
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // CTA Text Field
              const Text(
                'CTA Text',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              CupertinoTextFormFieldRow(
                controller: _ctaController,
                placeholder: 'e.g., Learn More',
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (_linkController.text.isNotEmpty &&
                      (v == null || v.trim().isEmpty)) {
                    return 'CTA required when link is provided';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: _submitting ? null : _submit,
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _submitting
                    ? const CupertinoActivityIndicator()
                    : Text(
                        widget.banner == null
                            ? 'Create Banner'
                            : 'Save Changes',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
