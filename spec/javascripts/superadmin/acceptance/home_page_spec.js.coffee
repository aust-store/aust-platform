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
      console.log $('ul li a:first').text()
      console.log $('body').text()
      $('ul li a:first').text().should.equal("My Store")
      done()
    ), 80
