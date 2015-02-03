var readline = require('readline');

var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var addNumbers = function(sum, numsLeft, completionCb) {
  if (numsLeft > 0) {
    reader.question("Gimme a number: ", function(userRes) {
      var num = parseInt(userRes);
      sum += num;
      console.log("sum is now: " + sum);

      addNumbers(sum, (numsLeft-1), completionCb);
    }); // reader.question
  } else { // numsLeft === 0
    completionCb(sum);
    reader.close();
  }
}


var completionCb = function (sum) {
  console.log("Total Sum: " + sum);
}

addNumbers(0, 3, completionCb);
