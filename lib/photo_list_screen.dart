import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => _onPageChanged(index),
        children: [
          PhotoGridView(),
          PhotoGridView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
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

class PhotoGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ダミー画像一覧
    final List<String> imageList = [
      'https://placehold.jp/400x300.png?text=0',
      'https://placehold.jp/400x300.png?text=1',
      'https://placehold.jp/400x300.png?text=2',
      'https://placehold.jp/400x300.png?text=3',
      'https://placehold.jp/400x300.png?text=4',
      'https://placehold.jp/400x300.png?text=5',
    ];

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
                onTap: () => {},
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
