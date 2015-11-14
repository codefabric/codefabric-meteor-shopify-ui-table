
namespace 'CodeFabric.Shopify.UI', () ->

  Template.codefabricShopifyUITableHeader.events
    "change th.select input[type='checkbox']": (e, tpl) ->
      e.preventDefault()

      if e.target.checked
        @table.selectAll()
      else
        @table.deselectAll()