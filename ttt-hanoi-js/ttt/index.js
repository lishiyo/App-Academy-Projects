var players = require('./players.js');

module.exports = {
  Board: require('./board'),
  Game: require('./game'),
  HumanPlayer: players.HumanPlayer,
  CompPlayer: players.CompPlayer
}
