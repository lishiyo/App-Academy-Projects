(function () {
  if(typeof Asteroids === "undefined") {
    window.Asteroids = {};
  }

  // hash = { pos: pos }
  var Particle = Asteroids.Particle = function(hash, game) {
    this.scale =  Asteroids.Util.randomFloat(Particle.MIN_SCALE, Particle.MAX_SCALE);

    Asteroids.MovingObject.call(this, {
      pos: hash.pos,
      vel: hash.vel,
      color: hash.color,
      radius: Asteroids.Util.randomFloat(Particle.MIN_RADIUS, Particle.MAX_RADIUS),
    }, game);
  };

  Particle.COLOR = 'red';
  Particle.MIN_RADIUS = 5;
  Particle.MAX_RADIUS = 10;
  Particle.MIN_SCALE = .9;
  Particle.MAX_SCALE = .99;
  Asteroids.Util.inherits(Particle, Asteroids.MovingObject);
  Particle.prototype.isWrappable = false;

  Particle.createExplosion = function(pos, color, game) {

    for (var angle=0; angle<360; angle+=9) {

      var speed = Asteroids.Util.randomFloat(1,60);


      var velX = Math.floor(speed * Math.cos(angle * Math.PI / 180));
      var velY = Math.floor(speed * Math.sin(angle * Math.PI / 180));
      var posDup = pos.slice();
      var particle = new Particle({pos: posDup, vel: [velX, velY], color: color}, game);
      console.log(particle.scale);

      game.particles.push(particle);

    }
  };


  Particle.prototype.draw = function(ctx) {

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

    this.radius = this.scale * this.radius;

  }


})();
