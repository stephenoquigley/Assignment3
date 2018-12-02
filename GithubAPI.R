#----------Setting up the Github Connection---------------

#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
detach(package:plotly, unload=TRUE)
library(plotly)
library(jsonlite)
library(httpuv)
library(httr)
library(devtools)
library(magrittr)
library(dplyr)


# Establish connection to Github
oauth_endpoints("github")

# Connecting to my github 
myapp = oauth_app(appname = "APIgithub",
                   key = "90c0d84a80d883a21a2a",
                   secret = "270da448c534eecfefc996e02e20fe35680652c0")

# Get OAuth credentials
github_token = oauth2.0_token(oauth_endpoints("github"), myapp)
gtoken = config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

# Code sourced from: https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08

#-------------Interrogate the GitHub API to build visualisation of data available that--------------
#-------------elucidates some aspect of the softare engineering process-----------------------------

myUserData = fromJSON("https://api.github.com/users/stephenoquigley")
myUserData$followers
myUserData$following

pltlyKey <- "ImYtk3y7KA0TBoEcnL6m"

#Function that returns a list of the provided user's followers. 
getFollowers <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/followers", sep="")
  followers = fromJSON(URL)
  return (followers$login)
}

#Function that returns a list of the people the provided user is following. 
getFollowing <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/following", sep="")
  following = fromJSON(URL)
  return (following$login)
}

getRepos <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/repos", sep="")
  repos = fromJSON(URL)
  return (followers$login)
}













