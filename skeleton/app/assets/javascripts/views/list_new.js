TrelloClone.Views.ListNew = Backbone.View.extend({
  template: JST['lists/new'],

  initialize: function(opts){
    this.model.board = opts.board; // pass in board from router
  },

  events: {
    'submit form': "createList"
  },

  render: function(){
    var content = this.template({ list: this.model });
    this.$el.html(content);
    return this;
  },

  createList: function(event){
    event.preventDefault();
    var formData = $(event.currentTarget).serializeJSON().list;

    this.model.save(formData, {
      success: function(){
        console.log("saved!");
        // this.model.board.fetch();
        Backbone.history.navigate("#/boards/" + this.model.board.id, { trigger: true });
      }.bind(this)
    });
  }
});
