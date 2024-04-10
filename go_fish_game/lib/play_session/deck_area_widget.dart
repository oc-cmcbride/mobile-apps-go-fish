import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/board_state.dart';
import '../game_internals/playing_area.dart';
import '../game_internals/playing_card.dart';
import '../style/palette.dart';
import 'playing_card_widget.dart';

class DeckAreaWidget extends StatefulWidget {
  final PlayingArea area;

  final int deckStart = PlayingArea.maxCards;

  DeckAreaWidget(this.area, {super.key});

  @override
  State<DeckAreaWidget> createState() => _DeckAreaWidgetState();
}

class _DeckAreaWidgetState extends State<DeckAreaWidget> {
  bool isHighlighted = false;

  BoardState? boardState;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    boardState = context.watch<BoardState>();

    return LimitedBox(
      maxHeight: 120,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: DragTarget<PlayingCardDragData>(
          builder: (context, candidateData, rejectedData) => Material(
            color: isHighlighted ? palette.redPen : palette.backgroundMain,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: palette.accept,
              onTap: _onAreaTap,
              child: StreamBuilder(
                // Rebuild the card stack whenever the area changes
                // (either by a player action, or remotely).
                stream: widget.area.allChanges,
                builder: (context, child) => _CardStack(widget.area.cards),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onAreaTap() {
    PlayingCard? drawnCard = widget.area.removeLastCard();
    if (drawnCard != null) {
      boardState?.currentPlayer.addCard(drawnCard);
    }

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.huhsh);
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
    return false;
  }
}

class _CardStack extends StatelessWidget {
  static const int _maxCards = 1;

  static const _leftOffset = 0.0;

  static const _topOffset = 0.0;

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
