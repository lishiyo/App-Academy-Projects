JournalApp.Views.PostShow = Backbone.View.extend({
  template: JST['posts/show'],

  events: {
    "dblclick .clickable" : "editAttribute",
    "blur .clickable" : "saveAttribute"
  },

  initialize: function(){
    this.listenTo(this.model, 'sync invalid', this.render);
    this.listenTo(this.model, 'invalid', this.showErrors);
  },

  render: function(){
    var content = this.template({
      post: this.model
    });
    this.$el.html(content);

    return this;
  },

  editAttribute: function(event){
    event.preventDefault();
    var $attribute = $(event.currentTarget);
    var attributeText = $attribute.text(),
        attributeType = $attribute.data('type');

    var $inputBox = $("<input>").attr('type', attributeType);
    $inputBox.val(attributeText);
    $attribute.html($inputBox);
    $inputBox.focus();
  },

  saveAttribute: function(event){
    event.preventDefault();
    var $attribute = $(event.currentTarget).find('input');
    var newContent = $attribute.val().toString();
    var paramName = $(event.currentTarget).data("name");

    var params_hash = {};
    params_hash[paramName] = newContent;

    // doesn't work on error because it is set on client side before checking error
    // this.model.set(paramName, newContent);

    this.model.save(params_hash, {
      success: function(){

      }.bind(this),
      error: function(){
        this.model.fetch();
      }.bind(this)
    });
  },

  showErrors: function(model, error, options) {
    alert(error);
  }

});
