// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:go_fish_game/accounts/create_account_page.dart';
import 'package:go_fish_game/login_page/sign_in_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_internals/score.dart';
import 'login_page/landing_login.dart';
import 'main_menu/main_menu_screen.dart';
import 'play_session/play_session_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingLogin(key: Key('login')),
      routes: [
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: const ValueKey('play'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: const PlaySessionScreen(
              key: Key('level selection'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'won',
              redirect: (context, state) {
                if (state.extra == null) {
                  // Trying to navigate to a win screen without any data.
                  // Possibly by using the browser's back button.
                  return '/';
                }

                // Otherwise, do not redirect.
                return null;
              },
              pageBuilder: (context, state) {
                final map = state.extra! as Map<String, dynamic>;
                final scores = map['score'] as List<Score>;

                return buildMyTransition<void>(
                  key: const ValueKey('won'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: WinGameScreen(
                    scores: scores,
                    key: const Key('win game'),
                  ),
                );
              },
            )
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
        GoRoute(
          path: 'sign_in_page',
          builder: (context, state) =>
              const SignInPage(key: Key('sign in')),
        ),
        GoRoute(
          path: 'accounts',
          builder: (context, state) =>
              const CreateAccountPage(key: Key('create account')),
        ),
        GoRoute(
          path: 'main_menu',
          builder: (context, state) =>
              const MainMenuScreen(key: Key('main menu')),
        ),
      ],
    ),
  ],
);
