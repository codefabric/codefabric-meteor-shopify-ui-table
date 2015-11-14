# client/lib/shopifyTableItem.coffee

namespace 'CodeFabric.Shopify.UI', () ->

  class TableItem extends CodeFabric.Model
    constructor: (table, item) ->
      @extend item

      if !@_id?
        @_id = (new Mongo.ObjectID()).valueOf()

      @table = table

      @EDIT_SESSION_KEY = 'codefabric::shopify::ui::table::' + @table.id + '::edit'
      @SELECT_SESSION_KEY = 'codefabric::shopify::ui::table::' + @table.id + '::select'

      super()

    #Public Methods

    isEditing: () ->
      return Session.get(@EDIT_SESSION_KEY) == @[@table.settings.idField]

    beginEdit: () ->
      Session.set(@EDIT_SESSION_KEY, @[@table.settings.idField])
      if @table.settings.onBeginEdit
        @table.settings.onBeginEdit @

    endEdit: () ->
      Session.set(@EDIT_SESSION_KEY, null)
      if @table.settings.onEndEdit
        @table.settings.onEndEdit @

    saveItem: (item) ->
      if !@table.settings.updateMethod
        @table.collection.update(@_id, $set: item)
      else if typeof @table.settings.updateMethod is 'function'
        @table.settings.updateMethod item
      else if typeof @table.settings.updateMethod is 'string'
        Meteor.call @stable.ettings.updateMethod, item

      @endEdit()

    removeItem: () ->
      if !@table.settings.removeMethod
        @table.collection.remove(@_id)
      else if typeof @table.settings.removeMethod is 'function'
        @table.settings.removeMethod @
      else if typeof @table.settings.removeMethod is 'string'
        Meteor.call @stable.settings.removeMethod, @_id

    isSelected: () ->
      selection = (Session.get @SELECT_SESSION_KEY) || []
      return (@_id in selection)

    setSelected: (isSelected) ->
      selection = (Session.get @SELECT_SESSION_KEY) || []
      if isSelected && (@_id not in selection)
        selection.push @_id
      else if !isSelected
        selection = (id for id in selection when id != @_id)

      Session.set @SELECT_SESSION_KEY, selection


    #Private Methods

  return ['TableItem', TableItem]

