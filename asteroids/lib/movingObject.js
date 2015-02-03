(function () {
  if(typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var MovingObject = Asteroids.MovingObject = function (hash, game) {
    this.game = game;
    this.pos = hash.pos;
    this.vel = hash.vel;
    this.radius = hash.radius;
    this.color = hash.color;
  };

  MovingObject.prototype.isWrappable = true;

  MovingObject.prototype.draw = function (ctx) {
    ctx.fillStyle = this.color;
    ctx.beginPath();

    ctx.arc(
      this.pos[0],
      this.pos[1],
      this.radius,
      0,
      2* Math.PI,
      false
    );

    ctx.fill();
  };

  MovingObject.prototype.move = function (mult) {
    var mult = (mult || 1);
    this.pos[0] += (mult * this.vel[0]);
    this.pos[1] += (mult * this.vel[1]);
    
    if (Asteroids.Game.isOutOfBounds(this.pos)) {
      if (this.isWrappable) {
        this.pos = Asteroids.Util.wrap(this.pos);
      } else {
      this.game.remove(this);
      }
    }
  };



  MovingObject.prototype.isCollidedWith = function(otherObj) {
    var dx = (this.pos[0] - otherObj.pos[0]);
    var dy = this.pos[1] - otherObj.pos[1];
    var dist = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
    if (dist <= (this.radius + otherObj.radius)) {
      return true;
    } else {
      return false;
    }
  };



  MovingObject.prototype.collideWith = function(otherObject) {
    // throw "OH NO!";
  };


})();
