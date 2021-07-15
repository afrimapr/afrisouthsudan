#' to run the shiny web application.
#' @export
runviewer <- function() {

  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("Package \"shiny\" needed for this function to work. Please install it from CRAN",
         call. = FALSE)
  }

  shiny::runApp(system.file('shiny/southsudan-mapviewer', package='afrisouthsudan'))
}
