# client/lib/shopifyTable.coffee

namespace 'CodeFabric.Shopify.UI', (ns)->

  class Table

    constructor: (collection, options) ->
      @id = new Mongo.ObjectID()

      @ADD_SESSION_KEY = 'codefabric::shopify::ui::table::' + @id + '::add'
      @SORT_SESSION_KEY = 'codefabric::shopify::ui::table::' + @id + '::sort'
      @FILTER_SESSION_KEY = 'codefabric::shopify::ui::table::' + @id + '::filter'

      @collection = collection


      defaults =
          idField: '_id'
          columns: []
          defaultSort: { }
          defaultFilter: { }

          inline: true
          
          addMethod: null
          updateMethod: null
          removeMethod: null
          
          addButtonText: null
          editButtonText: null
          removeButtonText: null
          saveButtonText: null
          cancelButtonText: null

          editItemTemplate: 'codefabricShopifyUITableItemEdit'
          addItemTemplate: 'codefabricShopifyUITableItemAdd'
          itemTemplate: 'codefabricShopifyUITableItemDisplay'
          headerTemplate: 'codefabricShopifyUITableHeader'

          canRemove: true
          canEdit: true
          canAdd: true

          onBeginEdit: (item) ->
          onEndEdit: (item) ->

          onChange: (e, el) ->
          
          onBeforeRemove: (e, item) ->
          onAfterRemove: (e, item) ->
          onBeforeAdd: (e, item) ->
          onAfterAdd: (e, item) ->
          onBeforeUpdate: (e, item) ->
          onAfterUpdate: (e, item) ->

      @settings = @buildSettings options, defaults

      Session.setDefault(@SORT_SESSION_KEY, @settings.defaultSort)
      Session.setDefault(@FILTER_SESSION_KEY, @settings.defaultFilter)

    #Public Methods
    data: () ->
      sort = Session.get(@SORT_SESSION_KEY)
      filter = Session.get(@FILTER_SESSION_KEY)
      if @collection? && @collection.constructor == Mongo.Collection
        @__data = _.map(@collection.find(filter, { sort: sort }).fetch(), (item) => @createTableItem item)
      else if @collection?
        sorted = @collection.orderBy(sort).filterBy(filter)
        @__data = _.map(sorted, (item) => @createTableItem item)
      else
        @__data = []

      return @__data

    createTableItem: (item) ->
      return new ns.TableItem @, item

    sort: (field, element) ->
      sort = Session.get(@SORT_SESSION_KEY)

      newSort = {}
      element.find('i').remove()

      hasKey = false
      for own key, value of sort
        if key == field
          if value == 1
            newSort[key] = -1
            element.append('<i class="fa fa-caret-down"></i>') 

          hasKey = true
        else
          newSort[key] = value

      if !hasKey
        newSort[field] = 1
        element.append('<i class="fa fa-caret-up"></i>')

      Session.set(@SORT_SESSION_KEY, newSort)

    beginAdd: () ->
      Session.set(@ADD_SESSION_KEY, true)

    endAdd: () ->
      Session.set(@ADD_SESSION_KEY, false)

    isAdding: () -> 
      return Session.get(@ADD_SESSION_KEY)

    addItem: (item) ->
      if !@settings.addMethod
        @collection.insert(item)
      else if typeof @settings.addMethod is 'function'
        @settings.addMethod item
      else if typeof @settings.addMethod is 'string'
        Meteor.call @settings.addMethod, item

      @endAdd()

    selectAll: () ->
      for item in @data()
        item.setSelected true

    deselectAll: () ->
      for item in @data()
        item.setSelected false

    #Private Methods
    buildSettings: (options, defaults) ->
      try
        theOptions = options
        if !theOptions
          theOptions = defaults

        theSettings = _.extend defaults, theOptions

        theColumns = theSettings.columns
        theSettings.columns = []
        theColumns.forEach (col) =>
          theSettings.columns.push (new ns.TableColumn @, col)
      catch err
        console.error err

      return theSettings || defaults

  return ['Table', Table]