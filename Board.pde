class Board {
	Piece[][] board = new Piece[8][8];
	// "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

	/* TODO */
	/* Move storage of piece positions from Piece object to Board object */

	void createBoard(String FEN) {
		String[] ranks = split(FEN, '/');

		for (int j = 0; j < ranks.length; j++) {
			for (int i = 0; i < ranks[j].length(); i++) {
				char piece = ranks[j].charAt(i);

				if (Character.isDigit(piece)) {
					board[i][j] = null;
				}
				else if (Character.isLowerCase(piece)) {
					board[i][j] = new Piece(i*tileSize + tileSize/2, j*tileSize + tileSize/2, false, Character.toUpperCase(piece));
				}
				else {
					board[i][j] = new Piece(i*tileSize + tileSize/2, j*tileSize + tileSize/2, true, piece);
				}
			}
		}
	}

	void move(int x, int y, int cx, int cy) {
		// pos and gridPos still stored in Piece object
		board[x][y].pos.move(cx*tileSize + tileSize/2, cy*tileSize + tileSize/2);
		board[x][y].gridPos.move(cx, cy);
		board[x][y].firstMove = false;

		board[cx][cy] = board[x][y];
		board[x][y] = null;
	}
}