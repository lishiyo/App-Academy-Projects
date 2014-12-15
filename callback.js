function Clock () {
  this.currentTime = null;
}

Clock.TICK = 5000;

Clock.prototype.printTime = function () {
  // Format the time in HH:MM:SS
  var hours = new Date(this.currentTime).getHours();
  var minutes = new Date(this.currentTime).getMinutes();
  var seconds = new Date(this.currentTime).getSeconds();
  console.log(hours + ":" + minutes + ":" + seconds);
};

Clock.prototype.run = function () {
  // 1. Set the currentTime.
  this.currentTime = new Date().getTime();
  // 2. Call printTime.
  this.printTime();
  // 3. Schedule the tick interval.
  setInterval(this._tick.bind(this), Clock.TICK);
};

Clock.prototype._tick = function () {
  // 1. Increment the currentTime.
  this.currentTime = this.currentTime + Clock.TICK;
  // 2. Call printTime.
  this.printTime();
};

var clock = new Clock();
clock.run();
