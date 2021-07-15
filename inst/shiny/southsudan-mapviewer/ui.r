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

  headerPanel('South Sudan Integrated Humanitarian Data Package (IHDP) mapviewer'),
  # headerPanel(p( 'South Sudan mapviewer by',
  #                a("afrimapr", href="http://www.afrimapr.org", target="_blank")
  #                )),

  # p("compare", a("geoBoundaries", href="https://www.geoboundaries.org/", target="_blank"),
  #   "&",       a("GADM", href="https://www.gadm.org/", target="_blank") ,
  #   "- may take a few seconds to download selected data"),

  p("This is prototype application to view data collated by a MapAction pilot project concluding July 2021.\n"),

  p("Select a layer on the left, choose to subset by admin region and which data to visualise.\n",
    "Select tabs on the right to view the map or attribute data. In the map choose basemaps with layers icon at top left\n"
    ),

  sidebarLayout(

    sidebarPanel( width=3,


                  radioButtons("admin_level", label = "select admin level",
                               choices = c('country','admin1','admin2'),
                               inline = TRUE, #horizontal
                               selected = 'country'),

                  uiOutput("select_admin"),

                  #user can select which layer to display
                  #TODO consider allowing multiple layers to be selected, but would cause other issues

                  uiOutput("select_layer"),

                  uiOutput("select_column"),

                  # selectInput("type", label = "geoboundaries type",
                  #             choices = c("simple (sscu)"="sscu", "precise (hpscu)"="hpscu", "simple standard (sscgs)"="sscgs", "precise standard (hpscgs)"="hpscgs"),
                  #             selected = 1),


                  p("active development July 2021, v0.3 ",
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
                  tabPanel("table", DT::dataTableOutput("table_names")),
                  tabPanel("about", htmlOutput("showabout")))

    )
  )
)



