import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Formのkeyを指定する場合は<FormState>としてGlobalKeyを定義する
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
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
                validator: (String? value) {
                  if (value?.isEmpty == true) {
                    return 'メールアドレスを入力してください';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              // 入力フォーム（パスワード）
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (String? value) {
                  if (value?.isEmpty == true) {
                    return 'パスワードを入力してください';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                // ボタン（ログイン）
                child: ElevatedButton(
                  onPressed: () => _onSignIn(),
                  child: Text('ログイン'),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                // ボタン（新規登録）
                child: ElevatedButton(
                  onPressed: () => _onSignUp(),
                  child: Text('新規登録'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignIn() {
    if (_formKey.currentState?.validate() == false) {
      return;
    }
    // ログイン処理
  }

  void _onSignUp() {
    if (_formKey.currentState?.validate() == false) {
      return;
    }
    // 新規登録処理
  }
}
