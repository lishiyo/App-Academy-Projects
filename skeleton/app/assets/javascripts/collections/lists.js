TrelloClone.Collections.Lists = Backbone.Collection.extend({

  url: 'api/lists',

  model: TrelloClone.Models.List,

  comparator: function(list) {
    return list.get('ord'); // ord represents rank
  }

})
