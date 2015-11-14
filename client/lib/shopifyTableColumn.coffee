
namespace 'CodeFabric.Shopify.UI', ()->

  class TableColumn extends CodeFabric.Model
    constructor: (table, col) ->
      @extend col
      @table = table

      if typeof @editable is 'undefined'
        @editable = true

      if typeof @addable is 'undefined'
        @addable = @editable

      if typeof @sortable is 'undefined'
        @sortable = true

      if typeof @visible is 'undefined'
        @visible = true

      super()

    validationAttributes: ->
      attrs = {}
      if @required
        attrs.required = @required
        attrs.placeholder = @displayName + " required"

      if @minLength?
        attrs.minLength = @minLength

      if @maxLength?
        attrs.maxLength = @maxLength

      if @min?
        attrs.min = @min

      if @max?
        attrs.max = @max

      if @regex
        attrs.pattern = @regex

      if @unique
        attrs.unique = @unique

      return attrs

  return ['TableColumn', TableColumn]