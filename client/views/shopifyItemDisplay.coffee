
namespace 'CodeFabric.Shopify.UI', () ->

  class TableItemDisplay extends CodeFabric.View
    constructor: (@template) ->
      super(@template)

    onRendered: =>
      data = Template.instance().data
      @id = "#{data[data.table.settings.idField]}"
      if Router?
        currentRoute = Router.current()
        if currentRoute.params.query.detail?
          details = currentRoute.params.query.detail.split ','

          if @id in details
            detailElm = @__findDetailElements()
            @__showDetail detailElm

    toggleDetail: () ->
      detailElm = @__findDetailElements()
      if detailElm.row? and detailElm.link?
        if detailElm.row.is(':hidden')
          @__showDetail detailElm, =>
            @__addDetailToQuery()
        else
          @__hideDetail detailElm, =>
            @__removeDetailFromQuery()

    __addDetailToQuery: ->
      if Router?
        currentRoute = Router.current()
        urlParam = currentRoute.params.query.detail
        details = []
        if urlParam? and urlParam.split?
          details = urlParam.split ','

        if @id not in details
          details.push @id

        currentRoute.params.query.detail = details.join ','
        path = currentRoute.route.path(currentRoute.params, { query: jQuery.param(currentRoute.params.query) })
        Router.go path, currentRoute.params, { replaceState: true }

    __removeDetailFromQuery: ->
      if Router?
        currentRoute = Router.current()
        urlParam = currentRoute.params.query.detail
        details = []
        if urlParam? and urlParam.split?
          details = urlParam.split ','

        currentRoute.params.query.detail = (d for d in details when d != @id)
        path = currentRoute.route.path(currentRoute.params, { query: jQuery.param(currentRoute.params.query) })
        Router.go path, currentRoute.params, { replaceState: true }

    __showDetail: (detailElm, callback) ->
      detailElm.row.slideDown ->
        detailElm.link.find('i').removeClass('fa-caret-down').addClass('fa-caret-up')
        callback()

    __hideDetail: (detailElm, callback) ->
      detailElm.row.slideUp ->
        detailElm.link.find('i').removeClass('fa-caret-up').addClass('fa-caret-down')
        callback()

    __findDetailElements: () ->
      detailLink = $(Template.instance().firstNode).find("td.detail>a")
      detailRow = $(Template.instance().firstNode).next("tr.detail")

      return { link: detailLink, row: detailRow }

  itemDisplay = new TableItemDisplay(Template.codefabricShopifyUITableItemDisplay)


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
      itemDisplay.toggleDetail detailId

          




    