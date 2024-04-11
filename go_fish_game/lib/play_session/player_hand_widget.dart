import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';
import '../game_internals/playing_card.dart';
import '../game_internals/board_state.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatefulWidget {
  const PlayerHandWidget({super.key});

  @override
  State<PlayerHandWidget> createState() => _PlayerHandWidgetState();
}

class _PlayerHandWidgetState extends State<PlayerHandWidget> {
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final boardState = context.watch<BoardState>();
    
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: PlayingCardWidget.height),
        child: ListenableBuilder(
          // Make sure we rebuild every time there's an update
          // to the player's hand.
          listenable: boardState.currentPlayer,
          builder: (context, child) {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ...boardState.currentPlayer.hand.map(
                  (card) => ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (boardState.currentPlayer.selectedCards[card] != null) {
                          boardState.currentPlayer.selectedCards[card] = !boardState.currentPlayer.selectedCards[card]!;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (boardState.currentPlayer.selectedCards[card] ?? false) ? Colors.green : Colors.white,
                      ),
                    child: PlayingCardWidget(
                      card,
                      player: boardState.currentPlayer,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
