# Using plumber for this
FROM rstudio/plumber

RUN apt-get update -qq && apt-get install -y libssl-dev libcurl4-gnutls-dev libpng-dev libpng-dev pandoc

# Required R packages
RUN R -e "install.packages(c('plumber', 'stats'))"

# copying files from directory to the dockerfile
COPY API.R API.R
COPY diabetes_data.rds diabetes_data.rds
COPY final_model.rds final_model.rds

# exposing an API port
EXPOSE 8000

# Run
ENTRYPOINT ["R", "-e", \
"pr <- plumber::plumb('API.R'); pr$run(host='0.0.0.0', port=8000)"]