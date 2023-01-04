# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

setwd('C:/Users/vince/OneDrive/Documents/WD/Programming/Shiny/package/SQE')
library(here)
here()

# Engineering

## Dependencies ----
## Amend DESCRIPTION with dependencies read from package code parsing
## install.package('attachment') # if needed.
attachment::att_amend_desc()

## Add some extra dependency
usethis::use_package("ggplot2")
usethis::use_package("dplyr")

usethis::use_package("data.table")
usethis::use_data_table()

## Add modules ----
## Create a module infrastructure in R/
# golem::add_module(name = "name_of_module1", with_test = TRUE) # Name of the module
# golem::add_module(name = "name_of_module2", with_test = TRUE) # Name of the module

golem::add_module(name = "select_QTL", with_test = TRUE)
golem::add_fct("QTL_candidates", with_test = FALSE)
golem::add_fct("QTL_candidates_wrapper", with_test = FALSE)

golem::add_module(name = "QTL_effect", with_test = TRUE)
golem::add_fct("QTL_effect_detail", with_test = FALSE)
golem::add_utils("add_xy_and_dim_id", with_test = FALSE)
golem::add_utils("plot_Qmain_QxE", with_test = FALSE)

golem::add_module(name = "QTLxEC_effect", with_test = TRUE)
golem::add_fct("QTLxEC_projection", with_test = FALSE)
golem::add_utils("red_tab", with_test = FALSE)
golem::add_utils("get_EC_val", with_test = FALSE)
golem::add_utils("pop_EC_par_mat_form", with_test = FALSE)
golem::add_utils("EC_proj", with_test = FALSE)
golem::add_utils("plot_QpxEC", with_test = FALSE)

## Add helper functions ----
## Creates fct_* and utils_*
golem::add_fct("helpers", with_test = TRUE)
golem::add_utils("helpers", with_test = TRUE)

## External resources
## Creates .js and .css files at inst/app/www
golem::add_js_file("script")
golem::add_js_handler("handlers")
golem::add_css_file("custom")
golem::add_sass_file("custom")

## Add internal datasets ----
## If you have data in your package
# usethis::use_data_raw(name = "my_dataset", open = FALSE)

# see annex file

## Tests ----
## Add one line by test you want to create
usethis::use_test("app")

# Documentation

## Vignette ----
usethis::use_vignette("SQE")
devtools::build_vignettes()

## Code Coverage----
## Set the code coverage service ("codecov" or "coveralls")
usethis::use_coverage()

# Create a summary readme for the testthat subdirectory
covrpage::covrpage()

## CI ----
## Use this part of the script if you need to set up a CI
## service for your application
##
## (You'll need GitHub there)
usethis::use_github()

# GitHub Actions
usethis::use_github_action()
# Chose one of the three
# See https://usethis.r-lib.org/reference/use_github_action.html
usethis::use_github_action_check_release()
usethis::use_github_action_check_standard()
usethis::use_github_action_check_full()
# Add action for PR
usethis::use_github_action_pr_commands()

# Travis CI
usethis::use_travis()
usethis::use_travis_badge()

# AppVeyor
usethis::use_appveyor()
usethis::use_appveyor_badge()

# Circle CI
usethis::use_circleci()
usethis::use_circleci_badge()

# Jenkins
usethis::use_jenkins()

# GitLab CI
usethis::use_gitlab_ci()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")

# test the app
library(SQE)
SQE::run_app()
