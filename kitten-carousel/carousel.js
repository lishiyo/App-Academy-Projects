(function () {
  if (typeof Carousel === 'undefined'){
    window.Carousel = {};
  }

  $.Carousel = function (el) {
    this.$el = $(el);
    this.activeIndex = 0;
    this.$items = this.$el.find("img");

    $('a.slide-left').on('click', this.slideLeft.bind(this)); // Next
    $('a.slide-right').on('click', this.slideRight.bind(this)); // Prev

  };

  $.Carousel.prototype.slide = function(dir) {
    var $oldCorgi = this.$items.eq(this.activeIndex);



    $oldCorgi.removeClass('active left right');

    var nextIndex = (this.activeIndex + dir + this.$items.length) % this.$items.length;
    var $newCorgi = this.$items.eq(nextIndex);

    var direction = (dir===1) ? "left" : "right"

    $newCorgi.addClass(direction).addClass("active");

    this.activeIndex = nextIndex;
    setTimeout(function () {
      $newCorgi.removeClass(direction);
    }, 0);
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
