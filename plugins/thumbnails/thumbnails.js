(function(){

  if (typeof Thumbnails === "undefined") {
    window.Thumbnails = {};
  }

  $.Thumbnails = function(el){
    this.$el = $(el);
    this.$gutterImgs = this.$el.find("div.gutter-images");
    this.$activeImg = this.$gutterImgs.find('img').first();
    this.$activeDiv = this.$el.find("div.active");
    this.activate(this.$activeImg);
    this.gutterIndex = 0;
    this.$images = this.$gutterImgs.find('img');


    this.$gutterImgs.on('click', 'img', this.switchImg.bind(this));

    this.$gutterImgs.on('mouseover', 'img', function(event){
      this.activate($(event.currentTarget));
    }.bind(this));

    this.$gutterImgs.on('mouseout', 'img', function(event){
      this.activate(this.$activeImg);
    }.bind(this));

    this.$el.on('click', 'a.nav', function(event){
      var clickedA = $(event.currentTarget);
      if (clickedA.hasClass('left')){
        this.gutterIndex += 1;
      } else {
        this.gutterIndex -= 1;
      }

      this.fillGutterImages();
    }.bind(this));

    this.fillGutterImages();
  };

  $.Thumbnails.prototype.fillGutterImages = function () {
    this.$gutterImgs.empty(); // clears out everything in gutter

    for(var i = this.gutterIndex; i < this.gutterIndex + 5; i++){
      this.$gutterImgs.append(this.$images.eq(i));
    }

    this.gutterIndex = (this.gutterIndex + 5);

    if (this.gutterIndex > 20) {
      this.gutterIndex = 20 - this.gutterIndex;
    } else if (this.gutterIndex < 0) {
      this.gutterIndex *= -1;
    }


  };

  $.Thumbnails.prototype.switchImg = function(event) {
    var currImg = $(event.currentTarget);
    this.$activeImg = currImg;
    this.activate(this.$activeImg);
  };


  $.Thumbnails.prototype.activate = function ($image) {
    var imgClone = $image.clone();
    this.$activeDiv.empty();
    this.$activeDiv.append(imgClone);
  };
})();
