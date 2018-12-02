#----------Setting up the Github Connection---------------

#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
detach(package:plotly, unload=TRUE)


# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
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



#-------------Interrogate the GitHub API to build visualisation of data available that--------------
#-------------elucidates some aspect of the softare engineering process-----------------------------



getFollowers <- function(username)
{
  i = 1
  x = 1
  followersDataFrame <- data_frame()
  while(x!=0)
  {
    followers <- GET( paste0("https://api.github.com/users/", username, "/followers?per_page=100&page=", i),getToken)
    followersContent <- content(followers)
    currentFollowersDF <- lapply(followersContent, function(x) 
    {
      df <- data_frame(user = x$login, userID = x$id, followersURL = x$followers_url, followingURL = x$following_url)
    }) %>% bind_rows()
    i <- i+1
    x <- length(followersContent)
    followersDF <- rbind(followersDF, currentFollowersDF)
  }
  return (followersDF)
}

getFollowers <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/followers", sep="")
  followers = fromJSON(URL)
  return (followers$login)
}

getFollowing <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/following", sep="")
  followers = fromJSON(URL)
  return (followers$login)
}

getRepositories <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/repos", sep="")
  repos = fromJSON(URL) 
  return (repos$name)
}







#Returns a dataframe with information on the Current Users Repositories
getRepos <- function(username)
{
  i <- 1
  x <- 1
  reposDF <- data_frame()
  while(x!=0)
  {
    repos <- GET( paste0("https://api.github.com/users/", username, "/repos?per_page=100&page=", i),getToken)
    reposContent <- content(repos)
    currentReposDF <- lapply(reposContent, function(x) 
    {
      df <- data_frame(repo = x$name, id = x$id, commits = x$git_commits_url, language = x$languages) #language = x$language)
    }) %>% bind_rows()
    i <- i+1
    x <- length(reposContent)
    reposDF <- rbind(reposDF, currentReposDF)
  }
  return (reposDF)
}

#Returns a dataframe with the language used in each of the users repos
getLanguages <- function(username)
{
  
  reposDF <- GET( paste0("https://api.github.com/users/", username, "/repos?per_page=100"),getToken)
  repoContent <- content(reposDF)
  i <- 1
  languageDF <- data_frame()
  numberOfRepos <- length(repoContent)
  for(i in 1:numberOfRepos)
  {
    repoLanguage <- repoContent[[i]]$language
    repoName <- repoContent[[i]]$name
    if(is_null(repoLanguage))
    {
      currentLanguageDF <- data_frame(repo = repoName, language = "No language specified")
    }else
    {
      currentLanguageDF <- data_frame(repo = repoName, language = repoLanguage)
    }
    i <- i+1
    languageDF <- rbind(languageDF, currentLanguageDF)
  }
  return (languageDF)
}









# Use API

UserFollowingData = GET(paste0("https://api.github.com/users/mbostock/followers?per_page=100&page=",i), gtoken)
UserFollowingDataContent = content(UserFollowingData)
UserFollowingDataFrame = jsonlite::fromJSON(jsonlite::toJSON(UserFollowingDataContent))

followersLogins = c(UserFollowingDataFrame$login)
followersLogins

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "mbostock/datasharing", "created_at"] 
