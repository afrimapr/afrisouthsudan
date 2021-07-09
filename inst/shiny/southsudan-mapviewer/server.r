# afrisouthsudan/southsudan-mapviewer/server.r
# to view southsudan data to inform covax planning


#global variables

#TODO later probably store this as data in the package
lookupname <- system.file("extdata","ssd-layer-description-lookup.csv", package="afrisouthsudan", mustWork=TRUE)
dflayers <- read.csv(lookupname)

filename <- system.file("extdata","ssd_ihdp_c19_s0_pp.gpkg", package="afrisouthsudan", mustWork=TRUE)

# to try to allow retaining of map zoom, when selections are changed
zoom_view <- NULL


# Define a server for the Shiny app
function(input, output) {


  ######################################
  # mapview interactive leaflet map plot
  output$serve_map <- renderLeaflet({

    #avoid problems at start
    if (length(input$layercontent) == 0) return(NULL)

    layername <- dflayers$name[which(dflayers$content==input$layercontent)]

    sflayer <- sf::st_read(filename, layer=layername)

    mapplot <- mapview(sflayer)


    # to retain zoom if only types have been changed
    if (!is.null(zoom_view))
    {
      mapplot@map <- leaflet::fitBounds(mapplot@map, lng1=zoom_view$west, lat1=zoom_view$south, lng2=zoom_view$east, lat2=zoom_view$north)
    }


    #important that this returns the @map bit
    #otherwise get Error in : $ operator not defined for this S4 class
    mapplot@map

  })

  ################################################################################
  # dynamic selectable list of layers in the geopackage
  output$select_layer <- renderUI({


    radioButtons("layercontent", label = "layer to view",
                 choices = dflayers$content,
                 #inline = TRUE, #horizontal
                 selected = dflayers$content[1])
  })


  #########################################################################
  # trying to detect map zoom as a start to keeping it when options changed
  observeEvent(input$serve_map_bounds, {

    #print(input$serve_healthsites_map_bounds)

    #save to a global object so can reset to it
    zoom_view <<- input$serve_map_bounds
  })

  ####################################################################
  # perhaps can just reset zoomed view to NULL when country is changed
  # hurrah! this works, is it a hack ?
  observe({
    input$country
    zoom_view <<- NULL
  })


  ###########################
  # table of admin unit names from the 2 sources
  output$table_names <- DT::renderDataTable({

    #TODO want to avoid reading in the layer again
    #BEWARE this won't work if I allow multiple layers to be displayed

    #avoid problems at start
    if (length(input$layercontent) == 0) return(NULL)
    layername <- dflayers$name[which(dflayers$content==input$layercontent)]
    sflayer <- sf::st_read(filename, layer=layername)


    DT::datatable(sflayer, options = list(pageLength = 50))
  })




}
