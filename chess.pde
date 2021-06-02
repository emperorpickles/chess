import java.awt.Point;

int tileSize = 80;
int framerate = 30;

ArrayList<Point> validMoves = new ArrayList<Point>();
String initialState = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR";

boolean moving = false;
Piece piece;
Board b = new Board();

//-----------------------------------------------

void setup() {
	frameRate(framerate);
	size(640, 640);

	b.createBoard(initialState);
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
	for (int x = 0; x < 8; x++) {
		for (int y = 0; y < 8; y++) {
			if (b.board[x][y] != null) {
				b.board[x][y].show();
			}
		}
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
					// b.board.remove(attacked);
				}
				b.move(piece.gridPos.x, piece.gridPos.y, x, y);
			}
			validMoves.clear();
		}
	}
	moving = !moving;
}

//-----------------------------------------------

Piece getPieceAt(int x, int y) {
	if (b.board[x][y] != null) {
		return b.board[x][y];
	}
	// if not a piece, return null
	return null;
}

//-----------------------------------------------

int toGrid(int x) {
	// helper function to convert grid coords to pixel coords
	int pos = x*tileSize + tileSize/2;
	return pos;
}