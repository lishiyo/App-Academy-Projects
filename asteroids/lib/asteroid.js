(function () {
  if(typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var Asteroid = Asteroids.Asteroid = function(hash,game) {

    Asteroids.MovingObject.call(this, {
      pos: hash.pos,
      color: Asteroid.COLOR,

      radius: Asteroid.RADIUS,
      vel: Asteroids.Util.randomVec(5)
    }, game);
  };

  Asteroid.COLOR = "black";
  // As

  Asteroids.Util.inherits(Asteroid, Asteroids.MovingObject);

  Asteroid.radius = function(maxX, maxY, numAst, fracAst) {
    var astArea = fracAst * (maxX * maxY) / numAst;
    var astRadius = Math.sqrt(astArea / Math.PI);
    return astRadius;
  };




  Asteroid.prototype.collideWith = function(otherObject) {
    if (otherObject instanceof Asteroids.Ship) {
      this.game.ship.relocate();
      this.game.remove(this);
    } else if (otherObject instanceof Asteroids.Bullet){
      this.game.remove(otherObject);
      this.game.remove(this);
    }

    // if (otherObject instanceof Asteroid) {
    //   this.vel[0] = -1 * this.vel[0];
    //   this.vel[1] = -1 * this.vel[1];
    //   otherObject.vel[0] = -1 * otherObject.vel[0];
    //   otherObject.vel[1] = -1 * otherObject.vel[1];
    //   if (Asteroids.Util.tooClose(this.pos,otherObject.pos, otherObject.radius + this.radius)) {
    //     this.move();
    //     otherObject.move();
    //   }
    // }

    if (otherObject instanceof Asteroid) {
      var avgVel = Asteroids.Util.avgVec(this.vel,otherObject.vel);
      var thisLen = Asteroids.Util.vecLength(this.vel);
      var otherLen = Asteroids.Util.vecLength(otherObject.vel);
      this.vel[0] = 2 * avgVel[0] - this.vel[0];
      this.vel[1] = 2 * avgVel[1] - this.vel[1];
      otherObject.vel[0] = 2 * avgVel[0] - this.vel[0];
      otherObject.vel[1] = 2 * avgVel[1] - this.vel[1];

      this.vel = Asteroids.Util.normVec(this.vel, thisLen);
      otherObject.vel = Asteroids.Util.normVec(otherObject.vel, otherLen);
      if (Asteroids.Util.tooClose(this.pos,otherObject.pos, otherObject.radius + this.radius)) {
        this.move();
        otherObject.move();
      }
    }
  };

  Asteroid.prototype.draw = function(ctx) {
    var imageObject = new Image();
    imageObject.src = 'images/asteroidv1.png';
    var width = 2 * this.radius;
    var height = 2 * this.radius;

    imageObject.onload = function () {
      ctx.drawImage(imageObject, this.pos[0] - this.radius, this.pos[1] - this.radius, width, height );
    }.bind(this);
  }



})();
