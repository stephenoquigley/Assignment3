#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp = oauth_app(appname = "APIgithub",
                   key = "90c0d84a80d883a21a2a",
                   secret = "270da448c534eecfefc996e02e20fe35680652c0")

# Get OAuth credentials
github_token = oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken = config(token = github_token)
UserFollowingData = GET("https://api.github.com/users/mbostock/following", gtoken)
UserFollowingDataContent = content(UserFollowingData)
UserFollowingDataFrame = jsonlite::fromJSON(jsonlite::toJSON(UserFollowingDataContent))

followersLogins = c(UserFollowingDataFrame$login)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "stephenoquigley/datasharing", "created_at"] 
