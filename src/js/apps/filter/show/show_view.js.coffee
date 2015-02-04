@Kodi.module "FilterApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  ###
    Base.
  ###

  class Show.FilterLayout extends App.Views.LayoutView
    template: 'apps/filter/show/filters_ui'
    className: "side-bar"
    regions:
      regionSort: '.sort-options'
      regionFiltersActive: '.filters-active'
      regionFiltersList: '.filters-list'
      regionFiltersOptions: '.filter-options-list'
      regionNavSection: '.nav-section'
      regionNavItems: '.nav-items'

  class Show.ListItem extends App.Views.ItemView
    template: 'apps/filter/show/list_item'
    tagName: 'li'

  class Show.List extends App.Views.CollectionView
    childView: Show.ListItem
    tagName: "ul"
    className: "selection-list"


  ###
    Extends.
  ###

  ## Sort.

  class Show.SortListItem extends Show.ListItem
    triggers:
      "click .sortable": "filter:sortable:select"
    initialize: ->
      classes = ['option', 'sortable']
      if @model.get('active') is true
        classes.push 'active'
      classes.push 'order-' + @model.get('order')
      tag = @themeTag('span', {'class': classes.join(' ')}, @model.get('alias'))
      @model.set(title: tag)

  class Show.SortList extends Show.List
    childView: Show.SortListItem

  ## Filter

  class Show.FilterListItem extends Show.ListItem
    triggers:
      "click .filterable": "filter:filterable:select"
    initialize: ->
      classes = ['option', 'option filterable']
      if @model.get('active')
        classes.push 'active'
      tag = @themeTag('span', {'class': classes.join(' ')}, @model.get('alias'))
      @model.set(title: tag)


  class Show.FilterList extends Show.List
    childView: Show.FilterListItem

  ## Filter option.

  class Show.OptionListItem extends Show.ListItem
    triggers:
      "click .filterable-option" : "filter:option:select"
    initialize: ->
      classes = ['option', 'option filterable-option']
      if @model.get('active')
        classes.push 'active'
      tag = @themeTag('span', {'class': classes.join(' ')}, @model.get('value'))
      @model.set(title: tag)

  class Show.OptionList extends Show.List
    activeValues: []
    childView: Show.OptionListItem


  ## Active Filters.

  class Show.ActiveListItem extends Show.ListItem
    triggers:
      "click .filterable-remove" : "filter:option:remove"
    initialize: ->
      tooltip = t.gettext('Remove') + ' ' + t.gettext(@model.get('key')) + ' ' + t.gettext('filter')
      text = @themeTag('span', {'class': 'text'}, @model.get('values').join(', '))
      tag = @themeTag('span', {'class': 'filter-btn filterable-remove', title: tooltip}, text)
      @model.set(title: tag)

  class Show.ActiveNewListItem extends Show.ListItem
    triggers:
      "click .filterable-add" : "filter:add"
    initialize: ->
      tag = @themeTag('span', {'class': 'filter-btn filterable-add'}, t.gettext('Add Filter'))
      @model.set(title: tag)

  class Show.ActiveList extends Show.List
    childView: Show.ActiveListItem
    emptyView: Show.ActiveNewListItem
    className: "active-list"