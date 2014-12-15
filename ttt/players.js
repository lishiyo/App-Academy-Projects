var readline = require("readline");
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var Player = function() {};

Player.prototype.endGame = function() {
  reader.close();
};

var Surrogate = function() {};
Surrogate.prototype = Player.prototype;

var HumanPlayer = function() {
  Player.call(this); // call super-constructor on the current HumanPlayer instance
}

HumanPlayer.prototype = new Surrogate();

HumanPlayer.prototype.promptMove = function(board, callback) {
  // reader.question => get pos
  var player = this;
  reader.question("Input your as array coordinate (EX: 0, 0):", function(userRes){
    try {
      var nextMovePos = userRes.split(",").map(function(el) {
        return parseInt(el);
      });
      // check if nextMovePos is valid
      var valid = nextMovePos.every(function(el) {
        return (el >= 0 && el <= 2);
      });

      if (valid) {
        callback(nextMovePos);
      } else {
        throw 'Invalid input! Enter only numbers between 0 and 2.'
      }

    } catch (e) {
      console.log(e);
      player.promptMove(board, callback);
    }

  });

}


var CompPlayer = function() {
  Player.call(this);
}

CompPlayer.prototype.promptMove = function(board, callback) {
  var dup = board.dup();
  var nextMove = (this.findWinningMove(dup) || this.randomMove(dup));
  callback(nextMove);
};

CompPlayer.prototype.findWinningMove = function (dup) {
  var mark = this.mark;
  for (i = 0; i < dup.grid.length; i++) {
    for (j = 0; j < dup.grid.length; j++) {
      if (dup.placeMark([i, j], mark)) {
        if (dup.won()) {
          return [i, j];
        }
      }
    }
  }
  return false;
};

CompPlayer.prototype.randomMove = function(dup) {
  var mark = this.mark;
  var move = function() {
    return Math.floor(Math.random() * 3);
  };
  var pos = [move(), move()];
  if (dup.empty(pos)) {
    return pos;
  } else {
    this.randomMove(dup);
  }
};

module.exports = {
  HumanPlayer: HumanPlayer,
  CompPlayer: CompPlayer

  
}
