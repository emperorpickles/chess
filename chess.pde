import java.awt.Point;

int tileSize = 80;
int framerate = 30;

ArrayList<Piece> whitePieces = new ArrayList<Piece>();
ArrayList<Piece> blackPieces = new ArrayList<Piece>();
ArrayList<Point> validMoves = new ArrayList<Point>();
Point[][] grid = new Point[8][8];

boolean moving = false;
Piece piece;

//-----------------------------------------------

void setup() {
	frameRate(framerate);
	size(640, 640);

	for (int y = 0; y < 8; y++) {
		for (int x = 0; x < 8; x++) {
			grid[x][y] = new Point(toGrid(x), toGrid(y));
		}
	}
	createBoard();
}

//-----------------------------------------------

void draw() {
	background(120);

	// create board
	for (int x = 0; x < 8; x++) {
		for (int y = 0; y < 8; y++) {
			if ((x+y) % 2 == 0) {
				fill(200);
			} else {
				fill(100);
			}
			rect(x*tileSize, y*tileSize, tileSize, tileSize);
		}
	}
	// show pieces
	for (int i = 0; i < whitePieces.size(); i++) {
		whitePieces.get(i).show();
	}
	for (int i = 0; i < blackPieces.size(); i++) {
		blackPieces.get(i).show();
	}
	// show valid moves
	if (validMoves.size() > 0) {
		for (int i = 0; i < validMoves.size(); i++) {
			fill(80, 230, 90, 25);
			circle(toGrid(validMoves.get(i).x), toGrid(validMoves.get(i).y), 20);
		}
	}
}

//-----------------------------------------------

void mousePressed() {
	int x = floor(mouseX / tileSize);
	int y = floor(mouseY / tileSize);

	// starting move
	if (!moving) {
		piece = getPieceAt(x,y);
		if (piece == null) {
			return;
		} else {
			piece.possibleMoves(x,y);
		}
	}
	// ending move
	else {
		if (piece != null) {
			if (piece.canMove(x,y)) {
				Piece attacked = getPieceAt(x,y);
				if (attacked != null) {
					if (attacked.white) {
						whitePieces.remove(attacked);
					} else {
						blackPieces.remove(attacked);
					}
				}
				piece.move(x, y);
			}
			validMoves.clear();
		}
	}
	moving = !moving;
}

//-----------------------------------------------

Piece getPieceAt(int x, int y) {
	// check if piece is white
	for (int i = 0; i < whitePieces.size(); i++) {
		if (whitePieces.get(i).gridPos.x == x && whitePieces.get(i).gridPos.y == y) {
			return whitePieces.get(i);
		}
	}
	// check if piece is black
	for (int i = 0; i < blackPieces.size(); i++) {
		if (blackPieces.get(i).gridPos.x == x && blackPieces.get(i).gridPos.y == y) {
			return blackPieces.get(i);
		}
	}
	// if not a piece, return null
	return null;
}

//-----------------------------------------------

void createBoard() {
	// create pawns
	for (int i = 0; i < 8; i++) {
		whitePieces.add(new Pawn(grid[i][6].x, grid[i][6].y, true));
		blackPieces.add(new Pawn(grid[i][1].x, grid[i][1].y, false));
	}
	// white pieces
	whitePieces.add(new King(grid[4][7].x, grid[4][7].y, true));
	whitePieces.add(new Queen(grid[3][7].x, grid[3][7].y, true));
	whitePieces.add(new Bishop(grid[2][7].x, grid[2][7].y, true));
	whitePieces.add(new Bishop(grid[5][7].x, grid[5][7].y, true));
	whitePieces.add(new Knight(grid[1][7].x, grid[1][7].y, true));
	whitePieces.add(new Knight(grid[6][7].x, grid[6][7].y, true));
	whitePieces.add(new Rook(grid[0][7].x, grid[0][7].y, true));
	whitePieces.add(new Rook(grid[7][7].x, grid[7][7].y, true));
	// black pieces
	blackPieces.add(new King(grid[4][0].x, grid[4][0].y, false));
	blackPieces.add(new Queen(grid[3][0].x, grid[3][0].y, false));
	blackPieces.add(new Bishop(grid[2][0].x, grid[2][0].y, false));
	blackPieces.add(new Bishop(grid[5][0].x, grid[5][0].y, false));
	blackPieces.add(new Knight(grid[1][0].x, grid[1][0].y, false));
	blackPieces.add(new Knight(grid[6][0].x, grid[6][0].y, false));
	blackPieces.add(new Rook(grid[0][0].x, grid[0][0].y, false));
	blackPieces.add(new Rook(grid[7][0].x, grid[7][0].y, false));
}

int toGrid(int x) {
	// helper function to convert grid coords to pixel coords
	int pos = x*tileSize + tileSize/2;
	return pos;
}