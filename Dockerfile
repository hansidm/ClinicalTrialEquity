FROM r-base:latest
LABEL maintainer="USER <user@example.com>"
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN R -e 'install.packages(c("BiocManager", "shinydashboard", "shiny", "shinyBS", "ggplot2", "methods", "hexbin", "DT", "dplyr", "RColorBrewer", "BBmisc", "viridis", "hrbrthemes", "plotly", "tidyr", "haven", "survey", "stringr", "interactions", "gplots", "lazyeval", "tidyverse", "treemap", "sunburstR", "d3r", "rintrojs", "jsonlite", "sp", "shinyjqui", "geofacet", "gtsummary", "data.table", "formattable", "kableExtra", "DataCombine", "knitr", "magrittr", "bsplus", "gtools", "rAmCharts", "shinyjs", "shinyWidgets", "rjson", "shinyFeedback", "remotes", "devtools"))'
RUN R -e 'remotes::install_github("daqana/dqshiny")'
RUN R -e 'devtools::install_github("vladchimescu/lpsymphony")'
RUN echo "local(options(shiny.port = 3838, shiny.host = '0.0.0.0'))" > /usr/lib/R/etc/Rprofile.site
RUN addgroup --system app \
    && adduser --system --ingroup app app
WORKDIR /home/app
COPY app .
RUN chown app:app -R /home/app
USER app
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/home/app')"]