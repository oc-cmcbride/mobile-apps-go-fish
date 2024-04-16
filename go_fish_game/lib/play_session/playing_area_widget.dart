import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/playing_area.dart';
import '../game_internals/playing_card.dart';
import '../game_internals/board_state.dart';
import '../style/palette.dart';
import 'playing_card_widget.dart';

class PlayingAreaWidget extends StatefulWidget {
  final PlayingArea area;

  const PlayingAreaWidget(this.area, {super.key});

  @override
  State<PlayingAreaWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {

  bool isHighlighted = false;

  BoardState? boardState;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    boardState = context.watch<BoardState>();

    return LimitedBox(
      maxHeight: 120,
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: DragTarget<PlayingCardDragData>(
          builder: (context, candidateData, rejectedData) => Material(
            color: isHighlighted ? palette.accept : palette.trueWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: palette.redPen,
              onTap: _onAreaTap,
              child: StreamBuilder(
                // Rebuild the card stack whenever the area changes
                // (either by a player action, or remotely).
                stream: widget.area.allChanges,
                builder: (context, child) => _CardStack(widget.area.cards),
              ),
            ),
          ),
          onWillAcceptWithDetails: _onDragWillAccept,
          onLeave: _onDragLeave,
          onAcceptWithDetails: _onDragAccept,
        ),
      ),
    );
  }

  void _onAreaTap() {
    if (boardState != null && boardState!.currentPlayer == widget.area.player) {
      final selectedCards = boardState!.currentPlayer.selectedCards;
      if (selectedCards.containsValue(true)) {
        // Make sure to only move 2 matching cards to the playing area 
        final removedCards = Map<PlayingCard, bool>.fromEntries(selectedCards.entries.where((element) => element.value));
        if (removedCards.length == 2 && removedCards.keys.first.value == removedCards.keys.last.value) {
          // Cards are selected; move them to the play area 
          removedCards.keys.forEach(widget.area.acceptCard);
          boardState!.currentPlayer.removeCards(removedCards.keys);
        }
        else {
          // Selected cards is not a pair of matching cards 
          // print("Not a pair of matching cards; not moving to playing area");
        }
      }
      else {
        // No cards are selected; discard cards from the area
        widget.area.removeFirstCard();
      }

      final audioController = context.read<AudioController>();
      audioController.playSfx(SfxType.huhsh);
    }
  }

  void _onDragAccept(DragTargetDetails<PlayingCardDragData> details) {
    widget.area.acceptCard(details.data.card);
    details.data.holder.removeCard(details.data.card);
    setState(() => isHighlighted = false);
  }

  void _onDragLeave(PlayingCardDragData? data) {
    setState(() => isHighlighted = false);
  }

  bool _onDragWillAccept(DragTargetDetails<PlayingCardDragData> details) {
    setState(() => isHighlighted = true);
    return true;
  }
}

class _CardStack extends StatelessWidget {
  static const int _maxCards = 2;

  static const _leftOffset = 10.0;

  static const _topOffset = 5.0;

  static const double _maxWidth =
      _maxCards * _leftOffset + PlayingCardWidget.width;

  static const _maxHeight = _maxCards * _topOffset + PlayingCardWidget.height;

  final List<PlayingCard> cards;

  const _CardStack(this.cards);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = max(0, cards.length - _maxCards);
                i < cards.length;
                i++)
              Positioned(
                top: i * _topOffset,
                left: i * _leftOffset,
                child: PlayingCardWidget(cards[i]),
              ),
          ],
        ),
      ),
    );
  }
}
