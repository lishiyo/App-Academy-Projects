JournalApp.Views.PostForm = Backbone.View.extend({
  template: JST['posts/form'],

  initialize: function(){

  },

  events: {
    "submit form": "submitPost"
  },

  render: function(){
    var content = this.template({ post: this.model });
    this.$el.html(content);
    return this;
  },

  submitPost: function(event){
    event.preventDefault();
    var $form = $(event.currentTarget);
    var formData = $form.serializeJSON().post;
    // wrap params assumes name is controller name
    this.model.save(formData, {
      success: function(){
        this.collection.add(this.model, { merge: true });
        Backbone.history.navigate("#", { trigger: true });
      }.bind(this),

      error: function(model, response){
        var $errors = this.$("ul.errors");
        $errors.empty();
        var respArr = $.parseJSON(response.responseText);
        respArr.forEach(function(error){
          $errors.append(error);
        });
      }.bind(this)
    })
  }

});
