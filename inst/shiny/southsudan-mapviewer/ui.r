# afrisouthsudan/southsudan-mapviewer/ui.r
# to view southsudan data to inform covax planning


library(shiny)
library(leaflet)
library(remotes)

if(!require(afrisouthsudan)){
  remotes::install_github("afrimapr/afrisouthsudan")
}

library(mapview)


#data(afcountries)

fluidPage(

  #headerPanel('afrimapr admin boundaries comparison tool'),
  headerPanel(p( 'South Sudan mapviewer by',
                 a("afrimapr", href="http://www.afrimapr.org", target="_blank")
                 )),

  # p("compare", a("geoBoundaries", href="https://www.geoboundaries.org/", target="_blank"),
  #   "&",       a("GADM", href="https://www.gadm.org/", target="_blank") ,
  #   "- may take a few seconds to download selected data"),

  sidebarLayout(

    sidebarPanel( width=3,


                  #user can select which layer to display
                  #TODO allow multiple layers to be selected
                  uiOutput("select_layer"),


                  # selectInput("type", label = "geoboundaries type",
                  #             choices = c("simple (sscu)"="sscu", "precise (hpscu)"="hpscu", "simple standard (sscgs)"="sscgs", "precise standard (hpscgs)"="hpscgs"),
                  #             selected = 1),


                  p("active development July 2021, v0.1 ",
                    "Open source ", a("R code", href="https://github.com/afrimapr/afrisouthsudan", target="_blank")),

                  #p("Contact : ", a("@southmapr", href="https://twitter.com/southmapr", target="_blank")),
                  #p("Open source ", a("R code", href="https://github.com/afrimapr/afriadmin", target="_blank")),

                  p("by ", a("afrimapr", href="http://www.afrimapr.org", target="_blank"),
                    ": creating R building-blocks to ease use of open health data in Africa"),

                  p("Input and suggestions ", a("welcome", href="https://github.com/afrimapr/suggestions_and_requests", target="_blank")),
                  #  "Contact : ", a("@southmapr", href="https://twitter.com/southmapr", target="_blank")),

                  p(tags$small("Disclaimer : Data used by afrimapr are sourced from published open data sets. We provide no guarantee of accuracy.")),

    ),

    mainPanel(

      #when just had the map
      #leafletOutput("serve_map", height=1000)

      #tabs
      tabsetPanel(type = "tabs",
                  tabPanel("map", leafletOutput("serve_map", height=800)),
                  tabPanel("table", DT::dataTableOutput("table_names")))

    )
  )
)



