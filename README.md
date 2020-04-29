# Dashboard in Shiny
This repository is an application to visualize [Global Hospital Beds Capacity (for covid-19)](https://www.kaggle.com/ikiulian/global-hospital-beds-capacity-for-covid19#hospital_beds_USA_v1.csv) data in a strucured way using shiny.

## Prerequisites for using this dashboard
This dashboard was built in [R](https://www.r-project.org/), an open source programming language using the [Shiny]((https://shiny.rstudio.com/)) package, a web application framework for R. Users will need to download R in order to use this dashboard and also it is suggested to use [RStudio](https://rstudio.com/). [R](https://www.r-project.org/) is completely free to use. All required code can be found in this github repositroy.

## Input type for calculations
This dashboard works with standard [csv-files (.csv)](/01_Data/USHospitalBeds.csv), which were extracted from the Global Hospital Beds Capacity (for covid-19) data with following package: USHospitalBeds. 

## The variables needed for this dashboard are as follows:

Input variables for this dashboard
Country group data

## Story of dashboard
The datasets provide a foundation for policymakers to understand the realistic capacity of healthcare providers being able to deal with the spikes in demand for intensive care. As a way to help, the [author](https://www.kaggle.com/ikiulian/global-hospital-beds-capacity-for-covid19#hospital_beds_USA_v1.csv) of this dataset has prepared a dataset of beds across countries and states. Work in progress dataset that should and will be updated as more data becomes available and public on weekly basis.

## The dashboard is structured into three areas (tabs):

Maps

Individual State

States

Animation of States


## In the first area, the following variables are included:
Variable | Detail
------------ | -------------
state | more granular location
lat | latitude
lng | longtitude
beds | number of beds per 1000

## In the second area, the following variables are included:
Variable | Detail
------------ | -------------
state | more granular location
beds | number of beds per 1000

## In the third area, the following variables are included:
Variable | Detail
------------ | -------------
state | more granular location
beds | number of beds per 1000

## In the fourth area, the following variables are included:
Variable | Detail
------------ | -------------
state | more granular location
beds | number of beds per 1000

The dashboard can be found with the following link:
[https://athenal-shinyapp-testing.shinyapps.io/Shiny/](https://athenal-shinyapp-testing.shinyapps.io/Shiny/)


## An example of the first image of the dashboard:

This graph shows the various units comparison between Acute, ICU, Psychiatric and other in group state of California, New York and FL. 
![Tri State Graph](/03_images/6.png)

## Privacy and storage
This dashboard works with open source data. All data for the running example was collected from the Kaggle.
This dashboard can be run locally (for example: Shiny server) or on personal machines (mac, windows).

## Author
This dashboard was created at the School of Science of the St. Thomas University by Athena in the class CIS-546 DATA VISUALIZATION.
