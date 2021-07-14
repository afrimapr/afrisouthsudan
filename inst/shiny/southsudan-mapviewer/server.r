# afrisouthsudan/southsudan-mapviewer/server.r
# to view southsudan data to inform covax planning

library(sf)

#global variables

#TODO later probably store this as data in the package
lookupname <- system.file("extdata","ssd-layer-description-lookup.csv", package="afrisouthsudan", mustWork=TRUE)
dflayers <- read.csv(lookupname)

filename <- system.file("extdata","ssd_ihdp_c19_s0_pp.gpkg", package="afrisouthsudan", mustWork=TRUE)

# to try to allow retaining of map zoom, when selections are changed
zoom_view <- NULL
# to allow current layer to be saved & accessed from different functions
sfloadedlayer <- NULL
sfadmin <- NULL
sfadmin_sel <- NULL
admin_names <- NULL
layernum <- NULL
layername <- NULL
layertypecol <- NULL
layerlabelcol <- NULL

#to stop auto use of dark basemap with light points
mapviewOptions(basemaps.color.shuffle = FALSE)


# Define a server for the Shiny app
function(input, output) {


  ######################################
  # mapview interactive leaflet map plot
  output$serve_map <- renderLeaflet({

    cat("in serve_map()\n")

    #if sfloadedlayer changes e.g. due to admin selection I would expect this to be triggered
    #but doesn't seem to be
    #adding a dependency on input$admin_names_selected mostly sorts it
    cat("selected admin:", input$admin_names_selected,"\n")
    #TODO fix occasional error that sfloadedlayer doesn't contain data

    #avoid problems at start
    #BEWARE I think this may have created issues
    #if (is.null(sfloadedlayer)) return(NULL)

    # did have problem that when changing the layer
    # this code initially tries to map the new layer
    # but using the previously chosen column
    # it was due to reacting to old layercontent at start of this func
    # I fixed issue & then it seemed to start again

    # layernum <<- which(dflayers$content==input$layercontent)
    # layername <- dflayers$name[layernum]
    # layertypecol <- dflayers$type_column[layernum]
    # layerlabelcol <- dflayers$label_column[layernum]

    #sflayer <- sf::st_read(filename, layer=layername)

    # assigning to a global object so that other functions can access
    #sfloadedlayer <<- sf::st_read(filename, layer=layername)


    zcol <- input$column_selected
    label <- layerlabelcol
    #BEWARE having a : in the layername stopped map from rendering
    layer.name <- paste(dflayers$content[layernum]," - ",zcol)

    cat("HERE layernum, name:",layernum,layername," selected col: ",input$column_selected,"layer.name",layer.name,"\n")


    #mapplot <- mapview(sfloadedlayer, zcol=zcol, label=label)

    #ARG!! it was working, now not, then yes, then not
    #at one point worked in browser, but not direct from RStudio
    #issues seemed to go away when I commented out this at start : if (is.null(sfloadedlayer)) return(NULL)


    mapplot <- mapview(sfloadedlayer, zcol=zcol, label=label,
                       layer.name=layer.name,
                       map.types=c('CartoDB.Positron','OpenStreetMap.HOT','Thunderforest.Transport','Esri.WorldImagery'))


    #add admin polygons to the plot
    if (input$admin_level != 'country')
    {
      if (input$admin_level == 'admin1') zcol <- "adm1_name"
      else if (input$admin_level == 'admin2') zcol <- "adm2_name"

      mapplot_to_add <- mapview::mapview(sfadmin_sel, zcol=zcol, color = "darkred", col.regions = "blue", alpha.regions=0.01, lwd = 2, legend=FALSE)

      mapplot <- mapplot + mapplot_to_add
    }


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
  # dynamic selectable list of admin regions - initially just allow one to be selected
  output$select_admin <- renderUI({

    if (input$admin_level != 'country')
    {
      cat("in select_admin()")

      #I could select features rather than zoom view, but that wouldn't select from the table
      #if I do select from the global sfloadedlayer object
      #I will need to make sure to re-read the whole layer before doing any other selection
      #that suggests that this selection should go on in the select_column() function

      if (input$admin_level == "admin1")
      {
        admin_layername <- "ssd_admn_ad1_py_s0_c19ihdp_pp"
        sfadmin <<- sf::st_read(filename, layer=admin_layername)
        #filter just the selected regions, base to avoid dplyr dependency
        #sfadmin_sel <- sfadmin[which(sfadmin$adm1_name%in%input$admin_names_selected),]
        admin_names <<- sfadmin$adm1_name

      } else if (input$admin_level == "admin2")
      {
        admin_layername <- "ssd_admn_ad2_py_s0_c19ihdp_pp"
        sfadmin <<- sf::st_read(filename, layer=admin_layername)
        #filter just the selected regions, base to avoid dplyr dependency
        #sfadmin_sel <- sfadmin[which(sfadmin$adm2_name%in%input$admin_names_selected),]
        admin_names <<- sfadmin$adm2_name
      }

      selectInput('admin_names_selected',label=NULL,
                  choices=admin_names)

    }

  })

  ################################################################################
  # dynamic selectable list of layers in the geopackage
  output$select_layer <- renderUI({

    radioButtons("layercontent", label = "layer to view",
                 choices = dflayers$content,
                 selected = dflayers$content[1])
  })

  ################################################################################
  # dynamic selectable list of columns in current selected layer
  output$select_column <- renderUI({

    # if I get this to react to the layer list
    # then i can use this to load & store the selected layer

    #avoid problems at start
    if (length(input$layercontent) == 0) return(NULL)

    # because it is in this function
    # the table should also update if user changes layer while in the table
    layernum <<- which(dflayers$content==input$layercontent)
    layername <<- dflayers$name[layernum]
    layertypecol <<- dflayers$type_column[layernum]
    layerlabelcol <<- dflayers$label_column[layernum]

    # assigning to a global object so that other functions can access
    sfloadedlayer <<- sf::st_read(filename, layer=layername)

    column_names <- names(sf::st_drop_geometry(sfloadedlayer))

    #starting admin region selection
    #using one of the 2 admin region layers stored in the geopackage
    #have a UI element allowing selection by admin1 or 2
    #TODO THIS NEEDS TO BE CONVERTED WON'T WORK YET

    if (input$admin_level != 'country')
    {
      #cat("test")

      #I could select features rather than zoom view, but that wouldn't select from the table
      #if I do select from the global sfloadedlayer object
      #I will need to make sure to re-read the whole layer before doing any other selection
      #that suggests that this selection should go on in the select_column() function

      if (input$admin_level == "admin1")
      {
        #admin_layername <- "ssd_admn_ad1_py_s0_c19ihdp_pp"
        #sfadmin <<- sf::st_read(filename, layer=admin_layername)
        #filter just the selected regions, base to avoid dplyr dependency
        sfadmin_sel <<- sfadmin[which(sfadmin$adm1_name%in%input$admin_names_selected),]

      } else if (input$admin_level == "admin2")
      {
        #admin_layername <- "ssd_admn_ad2_py_s0_c19ihdp_pp"
        #sfadmin <<- sf::st_read(filename, layer=admin_layername)
        #filter just the selected regions, base to avoid dplyr dependency
        sfadmin_sel <<- sfadmin[which(sfadmin$adm2_name%in%input$admin_names_selected),]
      }


      #filter points that are within selected regions
      #this returns sf # GOOD example to put in the BOOK (not obvious to me)
      #https://geocompr.robinlovelace.net/spatial-operations.html
      suppressWarnings(sfloadedlayer <<- sfloadedlayer[sfadmin_sel, ,op = st_within])
    }


    radioButtons("column_selected", label = "data to display on map",
                 choices = column_names,
                 #start with the default column for this layer
                 selected = dflayers$type_column[layernum])
  })


  #########################################################################
  # trying to detect map zoom as a start to keeping it when options changed
  observeEvent(input$serve_map_bounds, {

    #print(input$serve_healthsites_map_bounds)

    #save to a global object so can reset to it
    zoom_view <<- input$serve_map_bounds
  })


  ###########################
  # attribute table for selected layer
  output$table_names <- DT::renderDataTable({

    #BEWARE this won't work if I allow multiple layers to be displayed

    #avoid problems at start
    if (length(input$layercontent) == 0) return(NULL)

    #add dependency to make it respond to admin_selection
    cat("in table_names() selected admin:", input$admin_names_selected,"\n")

    # drop the geometry column - not wanted in table
    sflayer <- sf::st_drop_geometry(sfloadedlayer)

    DT::datatable(sflayer, options = list(pageLength = 50))
  })




}
