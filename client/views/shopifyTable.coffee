# client/views/shopifyTable.coffee

namespace 'CodeFabric.Shopify.UI', (ns) ->

  Template.codefabricShopifyUITable.helpers
    table: -> 
      if !@table
        @table = new ns.Table @collection, @settings
      return @table


  Template.codefabricShopifyUITable.events
    "click a.sort": (e, tpl) ->
      e.preventDefault()
      el = $(e.toElement)
      field = el.data('sort')
      @table.sort(field, el)