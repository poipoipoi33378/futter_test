import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Columnを使い縦に並べる
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // タイトル
              Text(
                'Photo App',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 16),
              // 入力フォーム（メールアドレス）
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 8),
              // 入力フォーム（パスワード）
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                // ボタン（ログイン）
                child: ElevatedButton(
                  onPressed: () => {},
                  child: Text('ログイン'),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                // ボタン（新規登録）
                child: ElevatedButton(
                  onPressed: () => {},
                  child: Text('新規登録'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
