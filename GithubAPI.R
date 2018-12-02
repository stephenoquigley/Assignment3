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


#---------- Gather data to be able to build visualisations------------
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
usersDataBase = data.frame(
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
            followingContent = content(followingInfo)
            followingDataFrame2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
            
            # Retrieve specific details on each user
            followingNumber = followingDataFrame2$following
            followersNumber = followingDataFrame2$followers
            reposNumber = followingDataFrame2$public_repos
            yearCreated = substr(followingDataFrame2$created_at, start = 1, stop = 4)
            
            
            # Add users data to a new row in the dataframe
            usersDataBase[nrow(usersDataBase) + 1, ] = c(followingUsernames[j], followingNumber, followersNumber, reposNumber, yearCreated)
        }
        next
    }
    
    #Stop when there are more than 400 users
    if(length(users) > 400)
    {
        break
    }
    next
}



#----------------- Now to build the visualisations-------------------

# Scatter plot of the number of followers a user has and the number of repositories they have
plot1 = plot_ly(data = usersDataBase, x = ~repos, y = ~followers, 
                text = ~paste("User:", username,"<br>Followers: ", followers, "<br>Repositories: ", 
                              repos, "<br>Date Created:", dateCreated), color = ~dateCreated)%>%
                layout(title='Relationship between Followers and Repositories')
plot1


# Scatter plot of the number of followers a user has and the number of users they follow
plot2 = plot_ly(data = usersDataBase, x = ~followers, y = ~following,
                text = ~paste("User:", username,"<br>Followers:",followers,"<br>Following:",following))%>%
      layout(title = 'Relationship between Followers and Following')
plot2


#------------------Languages Visualization ---------------------------
languages = c()

# Loop hrough all the users
for (i in 1:length(users))
{
    reposURL = paste("https://api.github.com/users/", users[i], "/repos", sep = "")
    repos = GET(reposURL, gtoken)
    reposContent = content(repos)
    reposDataFrame = jsonlite::fromJSON(jsonlite::toJSON(reposContent))
    
    reposNames = reposDataFrame$name
  
    # Go through all of the repos if the user
    for (j in 1: length(reposNames))
    {
        
        reposURL2 = paste("https://api.github.com/repos/", users[i], "/", reposNames[j], sep = "")
        repos2 = GET(reposURL2, gtoken)
        reposContent2 = content(repos2)
        reposDataFrame2 = jsonlite::fromJSON(jsonlite::toJSON(reposContent2))
        
        language = reposDataFrame2$language
        
        # Skip a repository if it has no language
        if (length(language) != 0 && language != "<NA>")
        {
            # Add the languages to a list
            languages[length(languages)+1] = language
        }
        
        next
    }
    
    # Loop breaks after 200 entries as it takes too long to run otherwise
    if(length(languages) > 2000)
    {
      break
    }
    next
}

# Save the top 20 languages in a table
languageTable = sort(table(languages), increasing=TRUE)
languageTableTop20 = languageTable[(length(languageTable)-19):length(languageTable)]

languageDataFrame = as.data.frame(languageTableTop20)
  
plot3 = plot_ly(data = languageDataFrame, x = languageDataFrame$languages, y = languageDataFrame$Freq, type = "bar") %>%
        layout(title="Top 20 Languages Used")
plot3



Sys.setenv("plotly_username"="stephenoquigley")
Sys.setenv("plotly_api_key"= "ImYtk3y7KA0TBoEcnL6m")
api_create(plot1, filename = "Followers vs Repositories by Date")
api_create(plot2, filename = "Followers vs Following")
api_create(plot3, filename = "Languages used in Repositories")




