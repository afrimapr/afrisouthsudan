# afrisouthsudan
R package containing geographic data in an Integrated Humanitarian Data Package (IHDP) for South Sudan

A part of the [afrimapr](www.afrimapr.org) project.

In early development, will change, contact Andy South with questions.

### online viewer prototype

[https://https://andysouth.shinyapps.io/southsudan-mapviewer/](https://andysouth.shinyapps.io/southsudan-mapviewer/)

See the 'about' tab in this viewer for details about the project.


### Install afrisouthsudan

Install the development version from GitHub using :

    # install.packages("remotes") # if not already installed
    
    remotes::install_github("afrimapr/afriasouthsudan")


### To run the viewer locally

``` r
library(afrisouthsudan)

afrisouthsudan::runviewer()

```
