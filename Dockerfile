FROM openanalytics/r-base

MAINTAINER Aaron Miles "amiles@cbuscollaboratory.com"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl1.0.0

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown', 'flexdashboard), repos='https://cloud.r-project.org/')"

# install dependencies of the stock app
RUN R -e "install.packages(c('tidyquant', 'highcharter', 'lubridate', 'timetk'), repos='https://cloud.r-project.org/')"

# copy the app to the image
RUN mkdir /root/
COPY tq_dashboard.Rmd /root/tq_dashboard.Rmd

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "rmarkdown::run('/root/tq_dashboard.Rmd')"]