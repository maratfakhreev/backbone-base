define [
  'marionette'
], (Marionette) ->

  App = new Marionette.Application

  App.addRegions
    headerRegion: '#header_region'
    mainRegion: '#main_region'

  App.navigate = (route, options) ->
    options or= {}
    Backbone.history.navigate(route, options)

  App.on 'initialize:after', ->
    Backbone.history.start
      pushState: true
      root: '/'

    $(document).on 'click', '.js-link', (event) ->
      event.preventDefault()
      href = $(event.currentTarget).attr('href')
      App.navigate(href, trigger: true)

    console.log 'app started'

  App
