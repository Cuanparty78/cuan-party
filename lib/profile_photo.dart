import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

String? profileImageType(Uint8List bytes) {
  if (bytes.length < 12 || bytes.length > 2 * 1024 * 1024) return null;
  if (bytes[0] == 255 && bytes[1] == 216 && bytes[2] == 255) return 'jpeg';
  if (bytes[0] == 137 && String.fromCharCodes(bytes.sublist(1,4)) == 'PNG') return 'png';
  if (String.fromCharCodes(bytes.sublist(0,4)) == 'RIFF' && String.fromCharCodes(bytes.sublist(8,12)) == 'WEBP') return 'webp';
  return null;
}
bool validProfilePhotoUrl(String value) {
  final uri = Uri.tryParse(value);
  return value.length <= 2048 && uri?.scheme == 'https' && uri!.host.isNotEmpty && uri.userInfo.isEmpty;
}
Future<String> uploadProfilePhoto(String uid, Uint8List bytes) async {
  final type = profileImageType(bytes);
  if (type == null) throw StateError('Foto harus JPEG, PNG, atau WEBP, maksimal 2 MB.');
  final ref = FirebaseStorage.instance.ref('profiles/$uid/avatar_${DateTime.now().microsecondsSinceEpoch}.$type');
  await ref.putData(bytes, SettableMetadata(contentType: 'image/$type', cacheControl: 'public,max-age=31536000'));
  return ref.getDownloadURL();
}

class ProfilePhotoPicker extends StatefulWidget {
  const ProfilePhotoPicker({super.key, required this.url, required this.onBytes, required this.onUrl, this.googleUrl, this.busy = false, this.pickGallery});
  final String url;
  final String? googleUrl;
  final bool busy;
  final ValueChanged<Uint8List?> onBytes;
  final ValueChanged<String> onUrl;
  final Future<Uint8List?> Function()? pickGallery;
  @override
  State<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}
class _ProfilePhotoPickerState extends State<ProfilePhotoPicker> {
  Uint8List? preview;
  String? error;
  bool picking = false;
  Future<void> gallery() async {
    if (widget.busy || picking) return;
    setState(() { picking = true; error = null; });
    try {
      Uint8List? bytes;
      if (widget.pickGallery != null) { bytes = await widget.pickGallery!(); }
      else {
        final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 75, requestFullMetadata: false);
        bytes = await file?.readAsBytes();
      }
      if (!mounted || bytes == null) return;
      if (profileImageType(bytes) == null) throw StateError('Pilih foto JPEG, PNG atau WEBP, maksimal 2 MB.');
      setState(() => preview = bytes);
      widget.onBytes(bytes);
    } catch (_) { if (mounted) setState(() => error = 'Foto tidak dapat dipilih. Gunakan JPEG, PNG, atau WEBP maksimal 2 MB.'); }
    finally { if (mounted) setState(() => picking = false); }
  }
  void useUrl(String url) {
    setState(() { preview = null; error = null; }); widget.onBytes(null); widget.onUrl(url);
  }
  Future<void> editUrl() async {
    final input = TextEditingController(text: widget.url);
    final value = await showDialog<String>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Link foto profil'), content: TextField(controller: input, keyboardType: TextInputType.url, decoration: const InputDecoration(hintText: 'https://…')),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
        TextButton(onPressed: () { if (validProfilePhotoUrl(input.text.trim())) Navigator.pop(dialogContext, input.text.trim()); }, child: const Text('Pakai Foto'))],
    ));
    input.dispose();
    if (mounted && value != null) useUrl(value);
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    InkWell(onTap: widget.busy ? null : gallery, borderRadius: BorderRadius.circular(60), child: CircleAvatar(
      radius: 54, backgroundColor: const Color(0xFFE7CD91),
      backgroundImage: preview != null ? MemoryImage(preview!) as ImageProvider<Object> : validProfilePhotoUrl(widget.url) ? NetworkImage(widget.url) : null,
      child: preview == null && !validProfilePhotoUrl(widget.url) ? const Icon(Icons.add_a_photo_rounded, color: Color(0xFF684724), size: 36) : null,
    )), const SizedBox(height: 10),
    Wrap(spacing: 8, children: [
      OutlinedButton.icon(onPressed: widget.busy || picking ? null : gallery, icon: const Icon(Icons.photo_library_outlined), label: Text(picking ? 'Membuka…' : 'Pilih Foto')),
      OutlinedButton(onPressed: widget.busy ? null : editUrl, child: const Text('Link Foto')),
      if (validProfilePhotoUrl(widget.googleUrl ?? '')) OutlinedButton(onPressed: widget.busy ? null : () => useUrl(widget.googleUrl!), child: const Text('Foto Google')),
    ]),
    const Text('Foto berubah setelah Simpan. Upload galeri memerlukan Storage aktif.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF684724))),
    if (error != null) Text(error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
  ]);
}
