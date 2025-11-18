// lib/pages/profile_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/session_service.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nimCtl = TextEditingController();
  final _session = SessionService();
  String? loggedUser;
  String? photoBase64;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.loadFromSession();
    final prefsUser = await _session.getLoggedUser();
    final nim = await _session.getNim();
    final photo = await _session.getProfilePhoto();
    setState(() {
      loggedUser = prefsUser;
      _nimCtl.text = nim ?? '';
      photoBase64 = photo;
      user = auth.currentUser;
    });
  }

  Future<void> _pick(bool camera) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: camera ? ImageSource.camera : ImageSource.gallery, maxWidth: 800, maxHeight: 800);
    if (x == null) return;
    final bytes = await x.readAsBytes();
    final b64 = base64Encode(bytes);
    await _session.saveProfilePhoto(b64);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.currentUser != null) {
      await auth.updateProfile(auth.currentUser!.username, photoBase64: b64);
    }
    setState(() { photoBase64 = b64; });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final username = auth.currentUser?.username ?? loggedUser ?? 'Guest';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(context: context, builder: (_) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Take photo'), onTap: () { Navigator.pop(context); _pick(true); }),
                        ListTile(leading: const Icon(Icons.photo), title: const Text('Choose from gallery'), onTap: () { Navigator.pop(context); _pick(false); }),
                      ],
                    ),
                  );
                });
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: photoBase64 != null ? MemoryImage(base64Decode(photoBase64!)) : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 12),
            Text('Username: $username'),
            const SizedBox(height: 12),
            TextField(controller: _nimCtl, decoration: const InputDecoration(labelText: 'NIM')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await _session.saveNim(_nimCtl.text.trim());
                final auth = Provider.of<AuthProvider>(context, listen: false);
                if (auth.currentUser != null) {
                  await auth.updateProfile(auth.currentUser!.username, nim: _nimCtl.text.trim());
                }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
              },
              child: const Text('Save NIM'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                await auth.logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
