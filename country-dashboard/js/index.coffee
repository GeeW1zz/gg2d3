#Routing information
showing = null
route = null
#F coffescript scope
selectedCountries = null

HashBangs = Backbone.Router.extend
  routes:
    "home": "showHome"

    "about" : 'showAbout'

    "compare" : "showCompare"
    "compare/*countries": "showCompare"

    "watch" : 'showWatch'
    "watch/:hour" : 'showWatch'

    "bubble" : 'showBubble'
    "bubble/:country" : 'showBubble'


  initialize: (options)->

  showHome: ()->
    $("#main").html($("#home").html())
    showing="home"
    updateTopLinks()

  showAbout: ()->
    $("#main").html($("#about").html())
    showing="about"
    updateTopLinks()

  showCompare: (countries)->
    if countries
      selectedCountries = _.map(countries.split("/"), (c)-> if c.length is 0 then null else decodeURI(c))
    else
      selectedCountries = ["United States"]
    while selectedCountries.length isnt 60 #compare.rainbow.length
      selectedCountries.push(null)

    if showing isnt "compare"
      $("#main").html($("#compare").html())
      showing="compare"
      updateTopLinks()
      createCompareChart()
    updateCompareChart()


  showWatch: (hour)->
    if showing isnt "watch"
      $("#main").html($("#watch").html())
      showing="watch"
      updateTopLinks()
      createWatchChart()
    if hour
      updateWatchChart(hour)
    else
      updateWatchChart()

  showBubble: (givenCountry)->

    if showing isnt "bubble"
      $("#main").html($("#bubble").html())
      showing="bubble"
      updateTopLinks()
      createBubbleChart()
    updateBubbleChart(givenCountry)

updateTopLinks = ()->
   $("ul.nav > li").removeClass("active")
   $("#link-#{showing}").addClass("active")

$(".hidden").toggleClass("hidden").hide()



#Start everything up
start = ()->
  route = new HashBangs()
  Backbone.history.start()
  if Backbone.history.fragment is "" then route.navigate("home",{trigger: true})

  reset = ()->
    showing = "none"
    route.navigate("#/#{Backbone.history.fragment}",
      {trigger: true, replace:true})

  $(window).resize(reset)