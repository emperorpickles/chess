# Chess
Simple chess program written in Processing 3. Intended as a test platform for java development and simple AI creations.

## Design Ideas
### Board States
Seperate Board object/class to keep track of the current board state. This allows the Piece class to focus on only handling piece movement.

Board as 2D 8x8 array treated as a grid representing the board.

```
[ // empty board
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
]
```
```
[ // starting positions
	R	N	B	Q	K	B	N	R
	P	P	P	P	P	P	P	P
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	x	x	x	x	x	x	x	x
	P	P	P	P	P	P	P	P
	R	N	B	Q	K	B	N	R
]
```
Create the initial board state from a FEN string.

### FEN & PGN Game Import/Export



## Forsyth-Edwards Notation (FEN)
FEN is a standard notation used to describe a position from a chess game. This is accomplished by translating any chess position into a single line of text. A FEN sequence has six different fields, seperated by spaces and each describing an aspect of the position.

The **first field** contains the piece placements. It describes the content of each square, going from the eighth rank to the first rank and from the first file to the eighth for each rank.

Lowercase characters represent black pieces and uppercase represents white pieces. Empty squares use numbers from 1-8 representing the number of empty squares between pieces on that rank.

The following sequence represents the piece placement at the start of a game:
`rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR`

The **second field** contains which color moves next. This field is *always* lowercase, with "w" indicating it is White to move, while "b" indicates it is Black to move.

An example being White to make the first move of the game:
`rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w`

The **third field** contains the castling rights for each side. Uppercase letters come first for White's rights, followed by lowercase for Black's. The letter "k" indicates kingside castling is available, while "q" is used for queenside castling. A "-" is used to indicate that neither side may castle.

For example, the follow sequence shows that White may castle queenside and Black kingside:
`4k2r/6r1/8/8/8/8/3R4/R3K3 w Qk`

The **fourth field** is used for possible en passant targets. If a pawn has moved two squares immediately before the current position it is a possible target for an en passant capture. The square behind this pawn is stored in this field as algebraic notion, if no en passant targets exist the "-" character is used instead.

For example 1.e4 makes the pawn a theoretical en passant target:
`rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3`

The **fifth field** tracks the number of moves made by both players since the last pawn advance or piece capture, called the number of halfmoves. This number helps to enforce the 50-move draw rule. Once the counter reaches 100 (both players making 50 moves) the game ends in a draw.

Ex. The next move ends the game in a draw:
`8/5k2/3p4/1p1Pp2p/pP2Pp1P/P4P1K/8/8 b - - 99`

The **sixth field** shows the total number of completed turns in the game. The number is incremented by one every time that Black moves. Also called the number of fullmoves.

Example of a complete FEN string:
`8/5k2/3p4/1p1Pp2p/pP2Pp1P/P4P1K/8/8 b - - 99 50`

## Portable Game Notation (PGN)
PGN is a standard format for recording a game in a text file. Unlike FEN, PGN records a sequence of moves in a game and not just one particular position. Usually, PGN will contain the moves from one entire game, but it can also record just part of a game.

PGN also stores other information from the game such as: player names, place the game was played, time control, ratings, game results, etc. There are two sections inside a PGN, each with a different set of information.

The **first section** includes tag pairs which record the following details:
* Event: Name of the event or match
* Site: Location of the game
* Date: Date when the game was played
* Round: Specific round in which the game happened
* White: Name of the player with the white pieces
* Black: Name of the player with the black pieces
* Results: Outcome of the game

This section can also contain extra fields with more data about the game, such as elo ratings, specifics about how the game ended, etc.

The **second section** contains the movetext, which is the sequence of moves, comments, and the result of the game. Moves are recorded in algebraic notation and comments can be inserted after a ";" symbol or inside parentheses or curly brackets.

An example of movetext from a game could look like this:
```
1.e4 e6 2.d4 d5 3.e5 Ne7 4.Nf3 c5 5.c3 Qb6 6.Be3 Qxb2 7.Qa4+ Bd7
8.Qb3 Qxa1 9.Bc1 c4 10.Qa3 Qxb1 11.Qb2 Qe4+ 12.Be3 Nf5 13.Qxb7 Nxe3
14.fxe3 Ba4 15.Qxa8 Qxe3+ 16.Be2 Qxc3+ 17.Kf2 Qb2 18.Qxa7 Bd7
19.Re1 Be7 20.Kf1 O-O 21.Nd2 { 0-1 White resigns. } 0-1
```