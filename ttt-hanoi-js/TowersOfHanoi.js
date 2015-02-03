var readline = require("readline");

var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var HanoiGame = function (numDisc) {
  this.numDisc = numDisc || 3;
  var stacks = [[], [], []]; // [[1,2,3], [], []]
  for (var i = numDisc; i > 0; i--) {
    stacks[0] = stacks[0].concat(i);
  }
  this.stacks = stacks;
}

HanoiGame.prototype.isWon = function () {
  if (this.stacks[1].length === this.numDisc || this.stacks[2].length === this.numDisc) {
    return true;
  } else {
    return false;
  }
};

HanoiGame.prototype.isValidMove = function (startTowerIdx, endTowerIdx) {
  var s = this.stacks[startTowerIdx];
  var startDisc = s[s.length - 1];
  var e = this.stacks[endTowerIdx];
  var endDisc = e[e.length - 1];
  if (this.stacks[startTowerIdx].length === 0) {
    return false;
  } else if (e.length === 0 || endDisc > startDisc) {
    return true;
  } else if (endDisc < startDisc) {
    return false;
  }
};

HanoiGame.prototype.move = function (startTowerIdx, endTowerIdx) {
  if (this.isValidMove(startTowerIdx, endTowerIdx)) {
    this.stacks[endTowerIdx].push(this.stacks[startTowerIdx].pop());
    return true;
  } else {
    return false;
  }
};

HanoiGame.prototype.print = function() {
  console.log(JSON.stringify(this.stacks));
}

HanoiGame.prototype.promptMove = function(callback) {
  // print the stacks
  this.print();
  var game = this;
  // ask user where they want to move to and from
  reader.question("Where do you want to move from? (Give the index, EX: 1 for the first stack)", function(startRes) {
    secondQues(startRes);
  });

  var secondQues = function(startRes) {
    reader.question("Where do you want to move to?", function (endRes) {
    try { // begin

      var startTowerIdx = parseInt(startRes) - 1;
      var endTowerIdx = parseInt(endRes) - 1;

      var notInBounds = function(idx) {
        return (idx < 1 || idx > 3);
      };

      if ([startTowerIdx, endTowerIdx].some(notInBounds)) {
        throw("Invalid index");
      } else {
        // callback will be move()
        callback(startTowerIdx, endTowerIdx);
      }

    } catch (e) { // rescue
      console.log(e);
      game.promptMove(callback);
    } // ends catch
  }); // questions

  }
}

HanoiGame.prototype.run = function(completionCb) {
  this.promptMove(function(startTowerIdx, endTowerIdx){
    // bind this inside here to the game instance
    if (this.move(startTowerIdx, endTowerIdx)) {
      if (this.isWon()) {
        completionCb();
      } else { // call run again
        this.run(completionCb);
      }
    } else { // move failed
      console.log("Your move was invalid!");
      this.run(completionCb);
    }
  }.bind(this));
}

var game = new HanoiGame(3);

var completionCb = function() {
  this.print();
  console.log("You won!");
  reader.close();
}
game.run(completionCb.bind(game));










// blah
