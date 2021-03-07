# Weather Now for iOS

## Overview
Weather Now is a iOS app written in the Swift Programming Langauge, that has been published as coding sample from me (Larry Herb). The app is a very simple app that allows you to look up the weather for a specific location by cityname using the http://www.openweathermap.org/ API. While the app may be updated, it may not be updated to meet changing platform standards.

## Features
The following are a number of the features of this app.
* Presents Weather Information on a Visually Animated User Interface
* Downloads Weather Icon Image
* Downloads JSON Feed from REST service and displays information on the interface.
* Presents Information with Multi Language Support includes (English, Spanish, Chinese, & Russian) 
* The App Retains the Last Used Location.

## Limitation
Because this is a code sample and not a large scale project, where there would be a lot of time availible to build out a robust user interface the application does have limitations which I've listed below.
* Only Current Weather Conditions Are Shown, No 5 Day Forecast.
* **The app requires a typed city name** such as "Boston, New York, London" and **is not Latitude/Longitude based**. This was NOT designed to be an robust weather app.
* The app only displays temperature in F and uses Meters, and does not provide the ability to convert.

## IMPORTANT (How to Run)
In order to run the app you will need to register and add the API Key from http://www.openweathermap.org/ to the MainViewController.swift file.

For More detailed information please see the wiki.

© Copyright 2021 Larry Herb
