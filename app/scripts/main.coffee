require('underscore')
require('backbone')
require('backbone-routefilter')
require('backbone-stickit')
require('backbone-validation')
require('marionette')
require('bootstrap')
require('jade')
require('./modules/navigation.coffee')
require('./modules/landing.coffee')
require('./modules/dashboard.coffee')
App = require('./application.coffee')

$ -> App.start()
