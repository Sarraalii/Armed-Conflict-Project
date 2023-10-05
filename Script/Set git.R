library(usethis)

# Configure your Git identity
use_git_config(user.name = "Sarraalii", user.email = "sarra.ali@mail.utoronto.ca")

# Initialize Git in your project directory
use_git()

# Link your local Git repository to a GitHub repository
use_github()

# Stage all changes (including new folders and files)


usethis::use_git_config()

usethis::use_git() 

usethis::use_github()

# Commit changes with a meaningful message
git commit -m "Added new folders and files"

usethis::use_git_remote("origin", url = NULL, overwrite = TRUE)
