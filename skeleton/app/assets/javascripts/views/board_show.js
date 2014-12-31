TrelloClone.Views.BoardShow = Backbone.CompositeView.extend({

  template: JST['boards/show'],

  initialize: function(){
    this.listenTo(this.model, 'sync', this.render);

    this.listenTo(this.model.lists(), 'sync', this.render);

    this.listenTo(this.model.lists(), 'addNewList', this.addListSubview);

    this.model.lists().each(function(list){
      this.addListSubview(list);
    }.bind(this));

  },

  events: {
    'click .open-list-form': "openListForm"
  },

  addListSubview: function(list) {
    listSubview = new TrelloClone.Views.ListShow({
      model: list
    });

    this.addSubview("ul.all-lists", listSubview);
  },

  openListForm: function(event) {
    event.preventDefault();
    var list = new TrelloClone.Models.List({ board: this.model });
    var listFormView = new TrelloClone.Views.ListNew({
      model: list
    });
    var $div = $('<div>').addClass('new-list-view');
    $div.html(listFormView.render().$el);
    this.$el.prepend($div);
  },

  render: function(){
    var content = this.template({ board: this.model });
    this.$el.html(content);

    this.attachSubviews(); // renders lists

    return this;
  },

})
