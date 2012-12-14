App.Router = Ember.Router.extend(
  location: 'hash'
  enableLogging: true

  root: Ember.Route.extend(
    home: Ember.Route.transitionTo('index')

    index: Ember.Route.extend(
      route: '/'
      showCompany: Ember.Route.transitionTo('root.company')

      connectOutlets: (router, context) ->
        router.get("applicationController").disconnectOutlet('state_navigation')
        router.get("applicationController").connectOutlet('body', 'companies', App.Company.find())
    )
    company: Ember.Route.extend(
      route: '/company/:id'
      enter: (router) ->
        router.get("applicationController").connectOutlet('state_navigation', 'state_navigation')

      deserialize: (router, context) -> return App.Company.find(context.id)
      serialize: (router, context)   -> return { id: context.id }

      connectOutlets: (router, aCompany) ->
        router.get("applicationController").connectOutlet('body', 'company', aCompany)
    )
  )
)
