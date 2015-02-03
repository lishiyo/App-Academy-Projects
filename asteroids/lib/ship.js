(function () {
  if(typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var Ship = Asteroids.Ship = function (game) {
    Asteroids.MovingObject.call(this, {
      pos: Asteroids.Game.randomPosition(),
      color: Ship.COLOR,
      radius: Ship.RADIUS,
      vel: [0,0]
    }, game)
  };

  Ship.RADIUS = 25;
  Ship.COLOR = 'blue';

  Asteroids.Util.inherits(Ship, Asteroids.MovingObject);

  Ship.prototype.relocate = function() {
      this.vel = [0,0];
      this.pos = Asteroids.Game.randomPosition();
  };

  Ship.prototype.power = function(impulse) {
    this.vel[0] += impulse[0];
    this.vel[1] += impulse[1];
  };

  Ship.prototype.fireBullet = function() {
    var posx = game.ship.pos[0] + Asteroids.Util.normVec(game.ship.vel, game.ship.radius)[0];
    var posy = game.ship.pos[1] + Asteroids.Util.normVec(game.ship.vel, game.ship.radius)[1];

    var bullet = new Asteroids.Bullet({pos: [posx,posy], vel: this.vel}, this.game);
    this.game.bullets.push(bullet);
  };

  Ship.prototype.draw = function(ctx) {
    var imageObject = new Image();
    imageObject.src = 'images/shipv1.png';
    var width = 2 * this.radius;
    var height = 2 * this.radius;

    imageObject.onload = function () {
      ctx.drawImage(imageObject, this.pos[0] - this.radius, this.pos[1] - this.radius, width, height );
    }.bind(this);
  }


})();
