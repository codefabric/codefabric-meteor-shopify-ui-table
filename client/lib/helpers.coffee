
namespace 'CodeFabric.Shopify', (ns) ->

  Template.registerHelper 'optionSelected', (option, value) ->
    attrs = { }
    if option == value
      attrs.selected = "selected"
    return attrs