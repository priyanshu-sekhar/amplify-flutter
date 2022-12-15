// Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// ignore_for_file: diagnostic_describe_all_properties

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_authenticator_test/src/configs/email_config.dart';
import 'package:amplify_authenticator_test/src/finders/authenticated_app_finder.dart';
import 'package:amplify_authenticator_test/src/finders/authenticator_finder.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_test/amplify_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Authenticator Test App, using Amplify and Auth stubs.
class MockAuthenticatorApp extends StatefulWidget {
  const MockAuthenticatorApp({
    super.key,
    this.config = emailConfig,
    this.lightTheme,
    this.darkTheme,
    this.initialStep = AuthenticatorStep.signIn,
    this.authPlugin,
    this.child,
  });

  final String config;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final AuthenticatorStep initialStep;
  final AuthPluginInterface? authPlugin;
  final Widget? child;

  @override
  State<MockAuthenticatorApp> createState() => _MockAuthenticatorAppState();
}

class _MockAuthenticatorAppState extends State<MockAuthenticatorApp> {
  Future<void> _configureAmplify() async {
    try {
      Amplify = AmplifyStub();
      await Amplify.addPlugin(widget.authPlugin ?? AmplifyAuthCognitoStub());
      await Amplify.configure(widget.config);
    } on Exception catch (e) {
      safePrint(e);
    }
  }

  @override
  void initState() {
    _configureAmplify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      initialStep: widget.initialStep,
      key: authenticatorKey,
      child: widget.child ??
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: widget.lightTheme,
            darkTheme: widget.darkTheme,
            themeMode: ThemeMode.system,
            builder: Authenticator.builder(),
            home: const Scaffold(
              key: authenticatedAppKey,
              body: Center(
                child: SignOutButton(),
              ),
            ),
          ),
    );
  }
}