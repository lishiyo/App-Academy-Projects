(function () {
  if(typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  var Game = Asteroids.Game = function() {
    this.numAsteroids = Game.NUM_ASTEROIDS;
    this.asteroids = [];
    this.bullets = [];
    this.particles = [];

    this.ship = new Asteroids.Ship(this);

    Asteroids.Asteroid.RADIUS = Asteroids.Asteroid.radius(Game.DIM_X, Game.DIM_Y, Game.NUM_ASTEROIDS, 0.10)
    this.addAsteroids();
  };

  Game.DIM_X = 1600;
  Game.DIM_Y = 850;
  Game.NUM_ASTEROIDS = 20;

  Game.randomPosition = function () {
    var pos = [Math.random() * Game.DIM_X, Math.random() * Game.DIM_Y];
    return pos;
  };

  Game.isOutOfBounds = function (pos) {
    return (pos[0] < 0 || pos[0] > Game.DIM_X) || (pos[1] < 0 || pos[1] > Game.DIM_Y);
  };

  Game.prototype.allObjects = function() {
    return [this.ship].concat(this.asteroids).concat(this.bullets).concat(this.particles);
  };

  Game.prototype.addAsteroids = function() {
    var locs = [];


    for ( var i = 0; i < this.numAsteroids; i++) {
      var valid = false;
      while (!valid) {
        var pos = Game.randomPosition();
        if (!Asteroids.Util.tooClosetoAny(pos,locs, Asteroids.Asteroid.RADIUS * 2)) {
          locs.push(pos);
          this.asteroids.push(new Asteroids.Asteroid({
            pos: pos
          }, this));
          valid = true;
        }
      }
    }
  };

  Game.prototype.add = function(obj) {
    if (obj instanceof Asteroid) {
      this.asteroids.push(obj);
    } else if (obj instanceof Bullet) {
      this.bullets.push(obj);
    }
  };

  Game.prototype.draw = function(ctx) {
    ctx.clearRect(0, 0, Game.DIM_X, Game.DIM_Y);

    this.allObjects().forEach( function (object) {
      object.draw(ctx);
    });
  };

  Game.prototype.moveObjects = function() {
      this.allObjects().forEach(function (object) {
        object.move();
      });
  };



  Game.prototype.checkCollisions = function() {
    var allObjs = this.allObjects();

    for (var i = 0; i < allObjs.length - 1; i++) {
      for (var j = i+1; j < allObjs.length; j++) {
        if (allObjs[i].isCollidedWith(allObjs[j])) {
          allObjs[j].collideWith(allObjs[i]);
        }
      }
    }
  };

  Game.prototype.step = function() {
    this.moveObjects();
    this.checkCollisions();
  };


  Game.prototype.remove = function(obj) {
    if (obj instanceof Asteroids.Asteroid) {
      for (var i = 0; i < this.asteroids.length; i++) {
        if (this.asteroids[i] === obj) {
            this.asteroids.splice(i, 1);
        }
      }
    } else if (obj instanceof Asteroids.Bullet) {
      for (var i = 0; i < this.bullets.length; i++) {
        if (this.bullets[i] === obj) {
            this.bullets.splice(i, 1);
        }
      }
    }

  };



})();
