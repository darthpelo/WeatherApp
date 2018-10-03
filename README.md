# WeatherApp

## Requirements

* Xcode 10
* Swift 4.2

## Build & Run

After the checkout, before open the project, you must download some dependencies:

1. open a terminal and in folder `/where you made the checkout/WeaterhApp/`
2. run the command `pod install`
3. run the command `open WeatherApp.xcworkspace`
4. build 🙂

## Coverage

For a better visualization of code coverage, you can use **xcov**:

`xcov -w WeatherApp.xcworkspace -s WeatherApp -x .xcovignore --only_project_targets true -o xcov_output`

This are the files/folders ignored:

* Pods
* WeatherApp/Extensions
* .*ViewCell.swift
* .*GoogleExtensions.swift

### Small issue

Regardless of the ignore of Pods folder, Xcode count a lot of files from pod libraries 😕

## Linter

Here swiftlin configuration:
`/where you made the checkout/WeaterhApp/.swiftlint.yml`