import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photoapp/photo_view_screen.dart';
import 'package:photoapp/sign_in_screen.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  late int _currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: _currentIndex,
      keepPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Photo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _onSignOut(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users/${user.uid}/photos')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final QuerySnapshot query = snapshot.data!;
          final List<String> imageList =
              query.docs.map((doc) => doc.get('imageURL') as String).toList();
          return PageView(
            controller: _controller,
            onPageChanged: (index) => _onPageChanged(index),
            children: [
              PhotoGridView(
                imageList: imageList,
                onTap: (imageURL) => _onTapPhoto(imageURL, imageList),
              ),
              PhotoGridView(
                imageList: [],
                onTap: (imageURL) => _onTapPhoto(imageURL, imageList),
              )
            ],
          );
        },
      ),
      // 画像追加用ボタン
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _onAddPhoto(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onTapBottomNavigationItem(index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'フォト',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'お気に入り',
          ),
        ],
      ),
    );
  }

  Future<void> _onSignOut() async {
    // ログアウト処理
    await FirebaseAuth.instance.signOut();

    // ログアウトに成功したらログイン画面に戻す
    //   現在の画面は不要になるのでpushReplacementを使う
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SignInScreen(),
      ),
    );
  }

  void _onTapPhoto(String imageURL, List<String> imageList) {
    // 最初に表示する画像のURLを指定して、画像詳細画面に切り替える
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoViewScreen(
          imageURL: imageURL,
          imageList: imageList,
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    // PageViewで表示されているWidgetの番号を更新
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTapBottomNavigationItem(int index) {
    // BottomNavigationBarで選択されたWidgetの番号を更新
    setState(() {
      _currentIndex = index;
    });
    // PageViewで表示されているWidgetの番号を更新
    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

Future<void> _onAddPhoto() async {
  // 画像ファイルを選択する
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result == null) {
    // ファイルが選択されなかった場合は何もしない
    print('No file selected.');
    return;
  }

  final User user = FirebaseAuth.instance.currentUser!;
  final int timestamp = DateTime.now().millisecondsSinceEpoch;
  final File file = File(result.files.single.path!);
  final String name = file.path.split('/').last;
  final String path = '${timestamp}_$name';
  print(path);
  final TaskSnapshot task = await FirebaseStorage.instance
      .ref()
      .child('users/${user.uid}/photos')
      .child(path)
      .putFile(file);
  final String imageURL = await task.ref.getDownloadURL();
  final String imagePath = task.ref.fullPath;
  final data = {
    'imageURL': imageURL,
    'imagePath': imagePath,
    'createdAt': Timestamp.now(),
  };
  print(imagePath);
  FirebaseFirestore.instance
      .collection('users/${user.uid}/photos')
      .doc()
      .set(data);
}

class PhotoGridView extends StatelessWidget {
  const PhotoGridView({
    Key? key,
    required this.imageList,
    required this.onTap,
  }) : super(key: key);

  final List<String> imageList;
  final void Function(String imageURL) onTap;

  @override
  Widget build(BuildContext context) {
    // GridViewを使いタイル状にWidgetを表示する
    return GridView.count(
      // 1行あたりに表示するWidgetの数
      crossAxisCount: 2,
      // Widget間のスペース（上下）
      mainAxisSpacing: 8,
      // Widget間のスペース（左右）
      crossAxisSpacing: 8,
      // 全体の余白
      padding: const EdgeInsets.all(8),
      // 画像一覧
      children: imageList.map((String imageURL) {
        // Stackを使いWidgetを前後に重ねる
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              // Widgetをタップ可能にする
              child: InkWell(
                onTap: () => onTap(imageURL),
                // URLを指定して画像を表示
                child: Image.network(
                  imageURL,
                  // 画像の表示の仕方を調整できる
                  //  比率は維持しつつ余白が出ないようにするので cover を指定
                  //  https://api.flutter.dev/flutter/painting/BoxFit-class.html
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 画像の上にお気に入りアイコンを重ねて表示
            //   Alignment.topRightを指定し右上部分にアイコンを表示
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => {},
                color: Colors.white,
                icon: Icon(Icons.favorite_border),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
