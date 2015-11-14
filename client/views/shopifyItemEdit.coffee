
namespace 'CodeFabric.Shopify.UI', () ->

  Template.codefabricShopifyUITableItemEdit.onRendered () ->
    $.validator.addMethod "unique", (value, element) =>
      field = element.name
      id = $(element).closest('form').data('id')
      matches = item for item in @data.table.__data when item[field] == value and item._id != id

      return !matches? || matches.length == 0
    , "Value is not unique."

    $.validator.classRuleSettings.unique =
        unique: true
    
  Template.codefabricShopifyUITableItemEdit.helpers
    saveButtonText: ->
      return @table.settings.saveButtonText || "Save"

    cancelButtonText: ->
      return @table.settings.cancelButtonText || "Cancel"


  Template.codefabricShopifyUITableItemEdit.events
    "click form.edit a.save": (e, tpl) ->
      el = $(e.target)
      form = el.closest('form')

      if form.valid()
        data = { }
        @table.settings.columns.forEach (col) ->
          input = form.find("input[name='" + col.field + "']")
          if input && (col.editable || true)
            data[col.field] = input.val()

        if @table.settings.onBeforeUpdate
          @table.settings.onBeforeUpdate e, data

        unless e.isDefaultPrevented()
          @saveItem(data)

          if @table.settings.onAfterUpdate
            @table.settings.onAfterUpdate e, data

      e.preventDefault()

    "click .edit a.cancel": (e, tpl) ->
      e.preventDefault()
      @endEdit()

    "change form.edit input": (e, tpl) ->
      e.preventDefault()
      el = $(e.target)
      
      #this (@) is a TableColumn, since we are in the each loop
      if @onChange
        @onChange e, el