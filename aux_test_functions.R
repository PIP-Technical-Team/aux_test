# Set of functions to setup a fake auxiliary data repo to be used for testing ####
# These functions interact with the GitHub Api

# Loading packages 
library("gh")
library("httr")

# -------- Functions to manage branches ---------- # 
# Get them from {pipfun}


library(pipfun)
# pipfun::create_new_brach()
# pipfun::delete_branch()

# ------- Function to create/add files --------- #

generate_aux_data <- function(countries  = 200,
                              first_year = 1990,
                              last_year  = 2020,
                              measure    = "gdp") {
  
  # Generate random data frame 
  
  # Generate country names
  country_names <- paste("country", 1:countries, sep = "")
  
  # Generate years
  years <- first_year:last_year
  
  # Create an empty data frame to store results
  data <- data.frame(
    country = rep(country_names, 
                  each = length(years)),
    year = rep(years, 
               times = countries),
    measure = rep(measure, 
                  times = countries * length(years)),
    value = runif(countries * length(years), 
                  1000, 
                  100000)  # Random values for the measure (between 1000 and 100000)
  )
  
  return(data)
}

  
  
push_file_to_gh <- function(data,
                            repo   = "aux_test", 
                            branch = "DEV", 
                            owner  = "PIP-Technical-Team") {
  
  # Write CSV to temporary file
  temp_file <- tempfile(fileext = ".csv")
  write.csv(data, temp_file, row.names = FALSE)
  
  # Read CSV as content
  csv_content <- readBin(temp_file, "raw", file.info(temp_file)$size)
  
  # Upload the CSV to the branch
  gh::gh(
    "PUT /repos/{owner}/{repo}/contents/{branch}/test_aux_data.csv",
    owner = owner,
    repo = repo,
    branch = branch,
    path = "test_aux_data.csv",
    message = "Adding fake aux data CSV",
    content = base64enc::base64encode(csv_content),
    branch = branch
  )
  
  #message("CSV file added to branch '", branch, "'.")
}




