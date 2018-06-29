# Functional Testing with Selenium

## Table of contents
- [Functional Testing with Selenium](#functional-testing-with-selenium)
    - [General Information](#general-information)
    - [Prerequisites](#prerequisites)
    - [Getting Started](#getting-started)
    - [Testing with Selenium Grid in Docker](#testing-with-selenium-grid-in-docker)
    - [Testing with Selenium Using Local Webdrivers](#testing-with-selenium-using-local-webdrivers)
- [Docker](../docker/README.md)


## General Information
Functional testing is built around [Selenium](http://www.seleniumhq.org/). Test cases are written in 
the Groovy programming language using [Spock](http://spockframework.org/) and [Geb](http://www.gebish.org/) frameworks.

## Prerequisites

## Getting Started

## Testing with Selenium Grid in Docker
Build the Docker image per the instructions provided [here](../docker/README.md#building-an-image).

Execute the full test suite by running `./gradlew seleniumGridTest`. It will start up all of the requisite Docker 
containers, execute the suite, and then stop all of the containers.

## Testing with Selenium Using Local Webdrivers
Execute the full test suite by running `./gradlew seleniumTest`. The Docker container's must started following the directions located [here](../docker/README.md) prior to running this test.
The test suite points to http://localhost:8080 by default.
