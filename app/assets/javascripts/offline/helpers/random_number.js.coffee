Handlebars.registerHelper "randomNumber", ->
  return Math.floor(Math.random()*100000000000+1)
