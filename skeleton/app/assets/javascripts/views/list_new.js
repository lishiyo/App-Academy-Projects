TrelloClone.Views.ListNew = Backbone.View.extend({
  template: JST['lists/new'],

  initialize: function(opts){
    // this.model.board = opts.board;
  },

  events: {
    'submit form': "createList",
    'click .close-form': "closeForm"
  },

  render: function(){
    var content = this.template({ list: this.model });
    this.$el.html(content);
    return this;
  },

  createList: function(event){
    event.preventDefault();
    var $form = $(event.currentTarget)
    var formData = $form.serializeJSON().list;

    this.model.save(formData, {
      success: function(){
        // this.model.board.fetch();
        this.model.board.lists().add(this.model);
        $form.remove();
        Backbone.history.navigate("#/boards/" + this.model.board.id, { trigger: true });
      }.bind(this)
    });
  },

  closeForm: function(event) {
    event.preventDefault();
    var $form = $(event.currentTarget)
    $form.remove();
  }
});
