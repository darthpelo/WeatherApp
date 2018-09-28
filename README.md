# SkinVision Coding challenge

Write a small weather app for the platform of your choice. Consume the [OpenWeatherAPI](https://openweathermap.org/api) to obtain the weather information to be displayed in the app.

## Requirements:
- after launching the app the user sees a list of cities; when installing the app on the device for the first time the list is empty
- There is a button which when pressed, takes the user into a screen where he can search for a city and add it to his list (hint: maybe the Google Places API can help you)
- The list of cities should be preserved between subsequent launches of the app
- The list of cities is ordered chronologically (newest added city on top)
- A list item should display the name of the city and the current temperature (in Celsius)
- The user can remove at any point an item from the list
- When tapping on a list item, the user navigates to the detail screen of the city
- The detail screen should show the following elements:
    - A background image of the selected city
    - The current temperature in the city
    - Today’s minimum and maximum temperature
    - Humidity and Atmospheric pressure values
    - A forecast for the following five days displayed in a vertical list
- The list should contain the name of the day, the date, and the temperature (in Celsius)

## How will the project be evaluated:
- Does it work? (Can we compile and run)
- Architecture
- Code clarity and readability
- Code coverage (unit tests are sufficient)
- Motivation of design decisions
- Attention to detail

## Delivery:
Upload your code to a GitHub/Bitbucket repository and give us access to it once it is completed. Provide a README.md file with instructions on how to setup the project. We encourage you to commit as you complete work. For example, you could commit every time a small part of the project is completed and functional.

## Note!
Use libraries sparingly! You are allowed (and encouraged) to use a networking library. However, be critical about what libraries you include the project and provide a motivation when you need to do so.

This repo contains a short video of how could such an app look for the iOS platform. You should not try to mimic 100% the design you see in there (although, if it makes your life easier, you can). While we understand UX might not be your strongest point, we do appreciate the effort and the originality :)

## Deadline: 
Max. 7 days from the moment you received this assignment.
