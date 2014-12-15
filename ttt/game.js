var Board = require("./board.js");

// initialize this.player1 = "X"
var Game = function (player1, player2) {
  this.board = new Board();
  this.player1 = player1;
  this.player2 = player2;
  this.player1.mark = this.board.marks[0];
  this.player2.mark = this.board.marks[1];
  this.currPlayer = this.player1;
};

Game.prototype.run = function(completionCb) {

  var currPlayerMark = this.currPlayer.mark;
  var game = this;
  console.log("current player is: " + currPlayerMark);
  game.board.print();

  this.currPlayer.promptMove(this.board, function(nextMovePos) {
    // do our move with currPlayer as the mark
    if (game.board.placeMark(nextMovePos, currPlayerMark)) {
      // was a valid move and board moved
      // first, check if won now
      if (game.board.won()) {
        game.board.print();
        completionCb(game.board.winner()); // return the mark
        game.currPlayer.endGame();
      } else { // switch currPlayer and run again
        game.currPlayer = (game.currPlayer===game.player1) ? game.player2 : game.player1;
        game.run(completionCb);
      }
    } else { // was an invalid move
      console.log("Your move was invalid!");
      game.run(completionCb);
    }

  });

}

module.exports = Game;
