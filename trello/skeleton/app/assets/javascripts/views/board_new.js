TrelloClone.Views.BoardNew = Backbone.View.extend({
  template: JST['boards/new'],

  initialize: function(){

  },

  events: {
    'submit form': "createBoard"
  },

  render: function(){
    var content = this.template({ board: this.model });
    this.$el.html(content);
    return this;
  },

  createBoard: function(event){
    event.preventDefault();
    var formData = $(event.currentTarget).serializeJSON().board;
    this.model.save(formData, {
      success: function(){
        console.log("saved!");
        this.collection.add(this.model);
        Backbone.history.navigate("#/boards/" + this.model.id, { trigger: true });
      }.bind(this)
    });
  }
});
