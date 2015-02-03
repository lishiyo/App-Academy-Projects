$.Tabs = function (el) {
  this.$el = $(el);
  this.$contentTabs = $(this.$el.data("content-tabs"));
  this.$activeTab = this.$contentTabs.find(".active");

  this.$el.on('click', 'a', this.clickTab.bind(this));
  // this.$el.on('click', 'a', function(event) {
  //   this.clickTab(event);
  // }.bind(this));
 };


$.Tabs.prototype.clickTab = function (event) {
  event.preventDefault(); // prevent going to the link

  // remove active from both tab and a
  this.$activeTab.removeClass("active").addClass('transitioning');
  $('a.active').removeClass("active");


  var $currA = $(event.currentTarget);
  $currA.addClass('active');
  // get new active tab



  this.$activeTab.one('transitionend', function(event){
    this.$activeTab.removeClass('transitioning');
    
      var currTabId = $currA.attr('href');
      var $currTab = this.$contentTabs.find(currTabId);
      $currTab.addClass('transitioning');

    this.$activeTab = $currTab;
    this.$activeTab.addClass('active');

    setTimeout(function(){
      this.$activeTab.removeClass('transitioning');
    }.bind(this),0);

  }.bind(this));

};


$.fn.tabs = function () {
  return this.each(function () {
    new $.Tabs(this);
  });
};
