var dingbats = require('dingbats');
var TTTGame = require("./ttt");

// script
var h = new TTTGame.HumanPlayer();
var c = new TTTGame.CompPlayer();
var g = new TTTGame.Game(h, c);


var completionCb = function(mark) {
  console.log(mark + " won!");
};

g.run(completionCb);
