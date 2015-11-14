# client/views/shopifyItemAdd.coffee

namespace 'CodeFabric.Shopify.UI', () ->

  Template.codefabricShopifyUITableItemAdd.helpers
    addButtonText: ->
      return @settings.addButtonText || "Add new #{@settings.typeName}"

    saveButtonText: ->
      return @settings.saveButtonText || "Save"

    cancelButtonText: ->
      return @settings.cancelButtonText || "Cancel"

  Template.codefabricShopifyUITableItemAdd.events
    "click .add a.add": (e, tpl) ->
      e.preventDefault()
      @beginAdd()

    "submit form.add": (e, tpl) ->
      el = $(e.target)
      form = el.closest('form')

      if form.valid()
        data = { }
        @settings.columns.forEach (col) ->
          input = form.find("input[name='" + col.field + "']")
          if input && (col.editable || true)
            data[col.field] = input.val()

        if @settings.onBeforeAdd
          @settings.onBeforeAdd e, data

        unless e.isDefaultPrevented()
          @addItem(data)

          if @settings.onAfterAdd
            @settings.onAfterAdd e, data

      e.preventDefault()

    "click .add a.cancel": (e, tpl) ->
      e.preventDefault()
      @endAdd()

    "change form.add input": (e, tpl) ->
      e.preventDefault()
      el = $(e.target)
      
      #this (@) is a TableColumn, since we are in the each loop
      if @onChange
        @onChange e, el