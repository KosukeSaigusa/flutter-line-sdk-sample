import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_line_sdk_sample/models/user_state/user_state.dart';
import 'package:flutter_line_sdk_sample/pages/home/home_page.dart';
import 'package:flutter_line_sdk_sample/pages/sign_in/sign_in_page.dart';
import 'package:flutter_line_sdk_sample/store/store.dart';
import 'package:flutter_line_sdk_sample/theme/theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LINE SDK Sample',
      theme: lightTheme.copyWith(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: darkTheme.copyWith(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: InitialWidget(),
    );
  }
}

/// アプリ起動時にはじめに生成されるウィジェット
class InitialWidget extends StatelessWidget {
  final store = Store();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: StreamBuilder<UserState>(
            stream: initStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SpinKitCircle(
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }
              final userState = snapshot.data!;
              if (userState.signedIn) {
                return HomePage();
              } else {
                return SignInPage();
              }
            },
          ),
        ),
      );

  Stream<UserState> initStream() async* {
    final signedIn = await store.signedIn;
    if (signedIn) {
      yield const UserState(signedIn: true);
    } else {
      yield const UserState(signedIn: false);
    }
  }
}
