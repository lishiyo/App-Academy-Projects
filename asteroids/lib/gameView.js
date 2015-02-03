(function () {
  if(typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var GameView = Asteroids.GameView = function (game, ctx) {
    this.game = game;
    this.ctx = ctx;
  };

  GameView.prototype.start = function () {
    var game = this.game;
    key('up', function () { game.ship.power([0,-1])});
    key('left', function () { game.ship.power([-1,0])});
    key('right', function () { game.ship.power([1,0])});
    key('down', function () { game.ship.power([0,1])});
    key('space', function() { game.ship.fireBullet(); } );

    setInterval( function () {
      this.game.step();
      this.game.draw(this.ctx);
    }.bind(this), 20);
  };

})();
