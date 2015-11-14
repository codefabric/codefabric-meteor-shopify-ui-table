
namespace 'CodeFabric.Shopify.UI', () ->

  Template.codefabricShopifyUITableItemDisplay.helpers
    selected: () -> 
      if Template.instance().data.isSelected() 
        return { checked: 'checked' }
      else
        return { }

    selectionClass: () ->
      if Template.instance().data.isSelected() 
        return "selected"
      else
        return ""

    editButtonText: ->
      return @table.settings.editButtonText || "Edit"

    removeButtonText: ->
      return @table.settings.removeButtonText || "Delete"

  Template.codefabricShopifyUITableItemDisplay.events
    "click tr a.edit": (e, tpl) ->
      e.preventDefault()
      @beginEdit()

    "click tr a.delete": (e, tpl) ->
      if @table.settings.onBeforeRemove
        @table.settings.onBeforeRemove e, @

      unless e.isDefaultPrevented()
        @removeItem()

        if @table.settings.onAfterRemove
          @table.settings.onAfterRemove e, @

      e.preventDefault()

    "change tr input[type='checkbox'].select": (e, tpl) ->
      e.preventDefault()
      Template.instance().data.setSelected e.target.checked

    "click tr td.detail a": (e, tpl) ->
      e.preventDefault()
      detailId = $(e.currentTarget).data('detail')
      detailRow = $(e.target).closest('table').find("tr.detail[data-detail='#{detailId}']")
      if detailRow?
        if $(detailRow).is(':hidden')
          $(e.currentTarget).find('i').removeClass('fa-caret-down').addClass('fa-caret-up')
          detailRow.slideDown()
        else
          $(e.currentTarget).find('i').removeClass('fa-caret-up').addClass('fa-caret-down')
          detailRow.slideUp()


    