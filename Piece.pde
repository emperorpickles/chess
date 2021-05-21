class Piece {
	Point pos;
	Point gridPos;
	boolean white;
	char type;
	boolean firstMove = true;
	Point[] diagonals = {new Point(1,1), new Point(-1,1), new Point(-1,-1), new Point(1,-1)};
	Point[] lines = {new Point(1,0), new Point(0,1), new Point(-1,0), new Point(0,-1)};

	Piece(int x, int y, boolean isWhite) {
		pos = new Point(x, y);
		gridPos = new Point(x/tileSize, y/tileSize);
		white = isWhite;
	}

	//-----------------------------------------------

	void show() {
		if (white) fill(255);
		else fill(60);
		circle(pos.x, pos.y, 40);

		textSize(30);
		fill(0);
		textAlign(CENTER, CENTER);
		text(type, pos.x, pos.y);
	}

	//-----------------------------------------------

	void move(int x, int y) {
		pos.move(x*tileSize + tileSize/2, y*tileSize + tileSize/2);
		gridPos.move(x, y);
		firstMove = false;
	}

	//-----------------------------------------------

	boolean inBounds(int x, int y) {
		if (x >= 0 && y >= 0 && x < 8 && y < 8) {
			return true;
		} else {
			return false;
		}
	}

	boolean canMove(int x, int y) {
		if (inBounds(x, y)) {
			return true;
		}
		return false;
	}

	void possibleMoves(int x, int y) {
		// find diagonals
		if (type == 'B' || type == 'Q') {
			for (int i = 0; i < 4; i++) {
				for (int j = 1; j < 8; j++) {
					Point move = new Point(x+(diagonals[i].x*j),y+(diagonals[i].y*j));
					if (!inBounds(move.x, move.y)) {
						break;
					}
					Piece piece = getPieceAt(move.x, move.y);
					if (piece == null) {
						validMoves.add(move);
					}
					else if (piece != null) {
						if (piece.white != white) {
							validMoves.add(move);
						}
						break;
					}
				}	
			}
		}
		// find straight lines
		if (type == 'R' || type == 'Q') {
			for (int i = 0; i < 4; i++) {
				for (int j = 1; j < 8; j++) {
					Point move = new Point(x+(lines[i].x*j),y+(lines[i].y*j));
					if (!inBounds(move.x, move.y)) {
						break;
					}
					Piece piece = getPieceAt(move.x, move.y);
					if (piece == null) {
						validMoves.add(move);
					}
					else if (piece != null) {
						if (piece.white != white) {
							validMoves.add(move);
						}
						break;
					}
				}	
			}
		}
		// knight moves
		if (type == 'N') {
			for (int i = -2; i <= 2; i++) {
				for (int j = -2; j <= 2; j++) {
					if ((abs(i)+abs(j)) % 2 == 1 && abs(i)+abs(j) != 1) {
						Point move = new Point(x+i,y+j);
						if (!inBounds(move.x, move.y)) {
							continue;
						}
						Piece piece = getPieceAt(move.x, move.y);
						if (piece == null) {
							validMoves.add(move);
						}
						else if (piece != null) {
							if (piece.white != white) {
								validMoves.add(move);
							}
							continue;
						}
					}
				}
			}
		}
		// king moves
		if (type == 'K') {
			for (int i = -1; i <= 1; i++) {
				for (int j = -1; j <= 1; j++) {
					Point move = new Point(x+i,y+j);
					if (!inBounds(move.x, move.y)) {
						continue;
					}
					Piece piece = getPieceAt(move.x, move.y);
					if (piece == null) {
						validMoves.add(move);
					}
					else if (piece != null) {
						if (piece.white != white) {
							validMoves.add(move);
						}
						continue;
					}
				}
			}
		}
		// pawn moves
		if (type == 'P') {
			for (int i = -1; i <= 1; i++) {
				Point move = new Point(x+i, y);
				// can only move forward
				if (white) {
					move.translate(0, -1);
				} else {
					move.translate(0, 1);
				}
				// can't leave the board
				if (!inBounds(move.x, move.y)) {
					continue;
				}
				Piece piece = getPieceAt(move.x, move.y);
				// move double on first move
				if (firstMove && white && getPieceAt(x,y-2) == null) {
					validMoves.add(new Point(x,y-2));
				}
				if (firstMove && !white && getPieceAt(x,y+2) == null) {
					validMoves.add(new Point(x,y+2));
				}
				// move forward into empty square
				if (move.x == x && piece == null) {
					validMoves.add(move);
				}
				// take on diagonals
				if (move.x != x && piece != null) {
					if (piece.white != white) {
						validMoves.add(move);
					}
				}
			}
		}
	}
}

//-----------------------------------------------

class Pawn extends Piece {
	Pawn(int x, int y, boolean isWhite) {
		super(x, y, isWhite);
		type = 'P';
	}

	boolean canMove(int x, int y) {
		// can't take own pieces
		if (getPieceAt(x,y) != null) {
			if (getPieceAt(x,y).white == white) {
				return false;
			}
		}
		// test move against list of valid moves
		Point move = new Point(x,y);
		if (validMoves.size() > 0) {
			if (validMoves.contains(move)) {
				return true;
			}
		}
    return false;
  }
}

//-----------------------------------------------

class King extends Piece {
	King(int x, int y, boolean isWhite) {
		super(x, y, isWhite);
		type = 'K';
	}

	boolean canMove(int x, int y) {
		// can't take own pieces
		if (getPieceAt(x,y) != null) {
			if (getPieceAt(x,y).white == white) {
				return false;
			}
		}
		// test move against list of valid moves
		Point move = new Point(x,y);
		if (validMoves.size() > 0) {
			if (validMoves.contains(move)) {
				return true;
			}
		}
    return false;
  }
}

//-----------------------------------------------

class Queen extends Piece {
	Queen(int x, int y, boolean isWhite) {
		super(x, y, isWhite);
		type = 'Q';
	}

	boolean canMove(int x, int y) {
		// can't take own pieces
		if (getPieceAt(x,y) != null) {
			if (getPieceAt(x,y).white == white) {
				return false;
			}
		}
		// test move against list of valid moves
		Point move = new Point(x,y);
		if (validMoves.size() > 0) {
			if (validMoves.contains(move)) {
				return true;
			}
		}
		return false;
	}
}

//-----------------------------------------------

class Knight extends Piece {
	Knight(int x, int y, boolean isWhite) {
		super(x, y, isWhite);
		type = 'N';
	}

	boolean canMove(int x, int y) {
		// can't take own pieces
		if (getPieceAt(x,y) != null) {
			if (getPieceAt(x,y).white == white) {
				return false;
			}
		}
		// test move against list of valid moves
		Point move = new Point(x,y);
		if (validMoves.size() > 0) {
			if (validMoves.contains(move)) {
				return true;
			}
		}
		return false;
	}
}

//-----------------------------------------------

class Bishop extends Piece {
	Bishop(int x, int y, boolean isWhite) {
		super(x, y, isWhite);
		type = 'B';
	}

	boolean canMove(int x, int y) {
		if (getPieceAt(x,y) != null) {
			if (getPieceAt(x,y).white == white) {
				return false;
			}
		}
		Point move = new Point(x,y);
		if (validMoves.size() > 0) {
			if (validMoves.contains(move)) {
				return true;
			}
		}
		return false;
	}
}

//-----------------------------------------------

class Rook extends Piece {
	Rook(int x, int y, boolean isWhite) {
		super(x, y, isWhite);
		type = 'R';
	}

	boolean canMove(int x, int y) {
		if (getPieceAt(x,y) != null) {
			if (getPieceAt(x,y).white == white) {
				return false;
			}
		}
		Point move = new Point(x,y);
		if (validMoves.size() > 0) {
			if (validMoves.contains(move)) {
				return true;
			}
		}
		return false;
	}
}