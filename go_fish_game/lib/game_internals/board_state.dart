// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:go_fish_game/game_internals/playing_card.dart';

import 'player.dart';
import 'playing_area.dart';

class BoardState {
  final VoidCallback onWin;

  late final PlayingArea areaOne = PlayingArea(playerOne);

  late final PlayingArea areaTwo = PlayingArea(playerTwo);

  final PlayingArea areaDeck = PlayingArea(null);

  final Player playerOne = Player();

  final Player playerTwo = Player();

  late List<Player> players;

  BoardState({required this.onWin}) {
    players = [playerOne, playerTwo];
    for (Player p in players) {
      p.addListener(_handlePlayerChange);
    }
    for (int i = 0; i < 6; i++) {
      areaDeck.acceptCard(PlayingCard.random());
    }
  }

  List<PlayingArea> get areas => [areaOne, areaTwo, areaDeck];

  Player get currentPlayer => players.first;

  void dispose() {
    currentPlayer.removeListener(_handlePlayerChange);
    for (var a in areas) {
      a.dispose();
    }
  }

  void nextPlayer() {
    players = players.sublist(1)..add(players.first);
  }

  void _handlePlayerChange() {
    if (currentPlayer.hand.isEmpty || areaDeck.cards.isEmpty) {
      onWin();
    }
  }
}
