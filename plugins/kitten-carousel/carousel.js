(function () {
  if (typeof Carousel === 'undefined'){
    window.Carousel = {};
  }

  $.Carousel = function (el) {
    this.$el = $(el);
    this.activeIndex = 0;
    this.$items = this.$el.find("img");
    this.transitioning = false;

    $('a.slide-left').on('click', this.slideLeft.bind(this)); // Next
    $('a.slide-right').on('click', this.slideRight.bind(this)); // Prev

  };

  $.Carousel.prototype.slide = function(dir) {
    if (this.transitioning) { return; }

    this.transitioning = true;
    var $oldCorgi = this.$items.eq(this.activeIndex);

    // grab nextCorgi
    var nextIndex = (this.activeIndex + dir + this.$items.length) % this.$items.length;
    var $newCorgi = this.$items.eq(nextIndex);

    if (dir===1) {
      var newDir = "left";
      var oldDir = "right";
    }  else {
      var newDir = "right";
      var oldDir = "left";
    }

    $oldCorgi.addClass(oldDir);
    $newCorgi.addClass(newDir).addClass("active");

    // trigger newCorgi's change to left: 0%
    setTimeout(function () {
      $newCorgi.removeClass(newDir);
    }, 0);

    // after oldCorgi finishes moving left/right, go back to 0% and set display:none
    $oldCorgi.one('transitionend', function(event){
      $oldCorgi.removeClass('active').removeClass(oldDir);
      this.transitioning = false;
    }.bind(this));

    this.activeIndex = nextIndex;

  }

  // Next => 1
  $.Carousel.prototype.slideLeft = function(){
    this.slide(1);
  }

  // Previous
  $.Carousel.prototype.slideRight = function(){
    this.slide(-1);
  }

})();
