FROM rocker/shiny-verse:3.5.2

MAINTAINER Aaron Miles "amiles@cbuscollaboratory.com"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libxt-dev 
    
# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown', 'flexdashboard'), repos='https://cloud.r-project.org/')"

# install dependencies of the stock app
RUN R -e "install.packages(c('tidyquant', 'highcharter', 'lubridate', 'timetk'), repos='https://cloud.r-project.org/')"

# copy the app to the image
RUN mkdir /app/
COPY tq_dashboard.Rmd /app/tq_dashboard.Rmd

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "rmarkdown::run('/app/tq_dashboard.Rmd', shiny_args = list(port = 3838, host = '0.0.0.0'))"]