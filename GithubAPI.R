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


#------------------ Looking at my followers------------------------
getFollowers <- function(username)
{
  URLtoAccess <- paste("https://api.github.com/users/", username ,"/followers",sep="")
  followersInfo <- fromJSON(URLtoAccess)
  return (followersInfo$login)
}

myFollowers = getFollowers("stephenoquigley")
numberOfFollowers = length(myFollowers)


#------------------ Looking at my following------------------------
getFollowing <- function (username)
{
  URLtoAccess <- paste("https://api.github.com/users/", username ,"/following",sep="")
  followingInfo <- fromJSON(URLtoAccess)
  return (followingInfo$login)
}

myFollowing = getFollowing("stephenoquigley")
numberFollowing = length(myFollowing)


#------------------ Looking at my repositories------------------------
getRepositories <- function (username)
{
  URLtoAccess <- paste("https://api.github.com/users/", username ,"/repos",sep="")
  reposInfo <- fromJSON(URLtoAccess)
  return (reposInfo$name)
}

myRepositories = getRepositories("stephenoquigley")
numberOfRepos = length(myRepositories)


#---------- Now to compile visualisations for a given user-----------------
username = "mbostock"
usernameURL = paste("https://api.github.com/users/",username,"/followers?per_page=100;",sep="")
selectedUsersData = GET(usernameURL,gtoken)
stop_for_status(selectedUsersData)
contentOfUser = content(selectedUsersData)
githubDataBase = jsonlite::fromJSON(jsonlite::toJSON(contentOfUser))
githubDataBase$login
followers=githubDB$login
followersLogins = c(followers)

users = c()
usersDB = data.frame(
    username = integer(),
    following = integer(),
    followers = integer(),
    repos = integer(),
    dateCreated = integer())


# Loop through each of the selected users followers
for(i in 1:length(followersLogins))
{
    followerURL = paste("https://api.github.com/users/", user_ids[i], "/following", sep = "")
    usersFollowing = GET(followerURL, gtoken)
    usersFollowingContent = content(usersFollowing)
    
    # Move on to the next follower if they do not follow anyone
    if(length(usersFollowingContent) == 0)
    {
        next
    }
    
    # Compile a data frame of the users they follow
    followingDataFrame = jsonlite::fromJSON(jsonlite::toJSON(usersFollowingContent))
    followingUsernames = followingDataFrame$login
    
    
    # Loop through 'following' users
    for (j in 1:length(followingUsernames))
    {
        # Check user is not already in list
        if (is.element(followingUsernames[j], users) == FALSE)
        {
            # Add user to list
            users[length(users) + 1] = followingUsernames[j]
            
            # Retrieve data on each user
            followingURL = paste("https://api.github.com/users/", followingUsernames[j], sep = "")
            followingInfo = GET(followingURL, gtoken)
            followingContent = content(following2)
            followingDataFrame2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
            
        }    
    }
}













