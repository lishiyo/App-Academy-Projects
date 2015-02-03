function Board () {
  this.grid = [[null, null, null], [null, null, null], [null, null, null]];
  this.marks = ["X", "O"];
  this.ALLSETS = this.allSets();
}


Board.prototype.allSets = function() {
  var diagonals = [[[0, 0], [1, 1], [2, 2]], [[0, 2], [1, 1], [2, 0]]],
      cols = [],
      rows = [];

  for (var j = 0; j < this.grid.length; j++) {
    var coli = [],
        rowi = [];

    for (var i = 0; i < this.grid.length; i++) {
      var innerPos = [i, j]; // down same columns
      var innerPosRow = [j, i];
      coli.push(innerPos); // one column
      rowi.push(innerPosRow); // one row
    }

    cols.push(coli);
    rows.push(rowi);
  }

  var allSets = diagonals.concat(cols).concat(rows);

  return allSets;
}


Board.prototype.won = function () {
  // check if this.winner === -1 => return false
  // else, return true
  if (this.winner() === -1) {
    return false;
  } else {
    return true;
  }
};

Board.prototype.winner = function() {
  // for each mark, loop through rows and diagonals
  // if diagonals.every(isThisMark) => return this mark
  // else, return -1
  var theMark = -1;
  var board = this;

  this.marks.forEach(function(mark){
    board.ALLSETS.forEach(function(set){
      var isAllMarks = set.every(function(pos){
        return (board.getPosVal(pos) === mark)
      });

      if (isAllMarks) {
        theMark = mark;
        return; // breaks out of board.ALLSETS loop
      }
    });
  });

  return theMark;

}; // winner();

Board.prototype.empty = function(pos) {
  // return true if this.grid[pos] === null
  return (this.getPosVal(pos) === null)
};

// this.grid[[1,1]] => this.grid[1][1]
Board.prototype.placeMark = function(pos, mark) {
  // if this.empty, place the mark on this.grid[pos]
  if (this.empty(pos)) {
    this.setPosVal(pos, mark);
    return true;
  } else {
    // console.log("Invalid move. BeepBoop");
    return false;
  }
};

// getter
Board.prototype.getPosVal = function(pos) {
  var x = pos[0],
      y = pos[1];
  return this.grid[x][y]; // return null
};

Board.prototype.setPosVal = function(pos, mark) {
  var x = pos[0],
      y = pos[1];
  this.grid[x][y] = mark;
};

Board.prototype.print = function () {
  for (var i = 0; i < this.grid.length; i++) {
    console.log(JSON.stringify(this.grid[i]) + "\n");
  }
};

Board.prototype.dup = function () {
  var duped = new Board();
  for (var i = 0; i < this.grid.length; i++) {
    for (var j = 0; j < this.grid.length; j++) {
      duped.grid[i][j] = this.grid[i][j];
    }
  }
  return duped;
};

module.exports = Board;
