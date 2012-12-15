#= spec_helper
#= require superadmin/application_manifest
#= require superadmin/fixtures/company

describe "Superadmin Home page", ->
  beforeEach ->
    App.store.reopen(
      adapter: 'DS.fixtureAdapter'
    )

    Ember.run -> App.initialize()

  it 'has the list of stores', (done) ->
    setTimeout ( ->
      $('.application ul li a:first').text().should.equal("My Store")
      done()
    ), 80
