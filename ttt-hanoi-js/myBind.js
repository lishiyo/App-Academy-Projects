// fn.bind(myThis); => fn.apply(myThis)
Function.prototype.myBind = function(context) {
  var fn = this; // test()
  // myBind's arguments
  var bindArgs = Array.prototype.slice.apply(arguments, 1); // [arg1, arg2]
  return function () {
    // test's arguments
    var funcArgs = Array.prototype.slice.apply(arguments);  // [arg3]
    var allArgs = bindArgs.concat(funcArgs);
    return fn.apply(context, allArgs);
    // test.apply(this, [arg1, arg2, arg3]);
  };
};

var x = { name: "Connie" };

var test = function () {
  console.log("My name is: " + this.name);
};

var a = test.myBind(x, arg1, arg2)(arg3);
// arguments = { 0: arg1, 1: arg2, length: 2 }
// Array.prototype.slice.apply(arguments, 0) => [arg1, arg2]
