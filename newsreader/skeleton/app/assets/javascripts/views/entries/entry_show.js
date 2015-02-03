NewsReader.Views.EntryShow = Backbone.View.extend({
  tagName: 'li',
  template: JST['entries/entry'],

  render: function(){

    var htmlDesc = $.parseJSON(this.model.get('json'))["description"];

    var content = this.template({
      entry: this.model,
      entryDescription: htmlDesc
    });

    this.$el.html(content);
    return this;
  },

  leave: function(){
    this.remove();
  }

});
