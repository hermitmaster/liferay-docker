# Docker Liferay

## Table of contents
- [Mission Center R4](#mission-center-r4)
    - [General Information](#general-information)
    - [Prerequisites](#prerequisites)
    - [Getting Started](#getting-started)
    - [Common Tasks](#common-tasks)
    - [Helpful Tools](#helpful-tools)
    - [Versioning and Releases](#versioning-and-releases)
    - [Docker](#docker)
    - [Unit Testing](#unit-testing)
- [Functional Testing](functionalTest/README.md)
- [Git Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

## General Information
Please review this entire document before you begin working with the repository. The documentation below will likely 
answer a lot of questions and prevent issues getting up and running locally. The Mission Center R4 repository is laid 
out as a traditional Liferay 7/DXP workspace. If you have trouble finding anything, reference the 
[Liferay Workspce Documentation](https://dev.liferay.com/develop/tutorials/-/knowledge_base/7-0/liferay-workspace).
Tooling is based on  [Gradle 4.2](https://docs.gradle.org/4.2/userguide/userguide.html). The Gradle wrapper is provided 
as part of the repository, so there is no need to install Gradle on your machine.


## Prerequisites
- git 2.13+ (Linux: install with your package manager, MacOS: install with [Homebrew](https://brew.sh/), Windows: use the [Git for Windows](https://git-for-windows.github.io/) installer.
- OpenJDK 8, but Oracle JDK 1.8 should work fine if running Windows
- A Java IDE, such as [Eclipse](https://www.eclipse.org/), [VS Code](https://code.visualstudio.com/), or [IntelliJ IDEA](https://www.jetbrains.com/idea/)

## Required System Environment Variables for Running Locally
- `NC4_OBFUSCATOR_PASSWORD` - with a value (phrase) longer than 30 characters. Once set and data is being encrypted 
with this secret, it should never change within an environment.
- `CATALINA_OPTS` - optional, used to set local JVM parameters such as heap. Recommended setting: `-Xms2g -Xmx4g` If 
not set, Liferay defaults will be used.

## Helpful Tools
- [Blade CLI](https://dev.liferay.com/develop/tutorials/-/knowledge_base/7-0/blade-cli)
- Any MySQL/MariaDB client
- [Atlassian SourceTree](https://www.sourcetreeapp.com/)
- Eclipse plugins: 
  - [Groovy Eclipse Tools](http://dist.springsource.org/snapshot/GRECLIPSE/e4.6/)
  - [Jspresso Spock Plugin](http://www.jspresso.org/external/updates-snapshot/e44)
  - [EGit](http://www.eclipse.org/egit/)
  - [Docker plugin](https://marketplace.eclipse.org/content/eclipse-docker-tooling)
- If on Windows: Git Bash (included with Git for Windows and recommended), Windows Subsystem for Linux, Cygwin, etc. 
    Any bash-like command shell is fine.


## Getting Started
### Before doing anything, you must download the current Liferay bundle
**All references to `./gradlew` can simply be replaced with `gradlew` when using command prompt or PowerShell on 
Windows platforms.**

Download the bundle by running the following command: `./gradlew initBundle`.
The bundle will be downloaded automatically and extracted to the `bundles` directory. This will generally take a while on the first run, 
but the bundle gets cached locally to `~/.liferay/bundles/`. Subsequent executions will generally complete in less than 30 seconds.

## Common Tasks
**Do not run `clean` in conjunction with any other task. There are issues with parallel execution that cause weirdness and build failure
if you try to run `clean` with anything else. Technically, this SHOULD work in Gradle 4.x, but it's possibly a limitation of the Liferay
Workspace Gradle plugin.**
- `initBundle` - Prepares the workspace by downloading (if not cached locally already) and extracting a bundle to the `./bundles` directory. The bundle is defined in `./gradle.properties`. Patches defined in `./build.gradle` are automatically installed as part of this task.
- `distBundle` - Builds a distributable bundle in `./build/dist` with all modules/wars deployed.
- `deploy` - Builds and deploys all modules, wars, etc. Can be called directly on a sub-project.
- `buildImage` - Builds docker image. Automatically calls `distBundle`
- `clean` - Cleans build directories. Can be called directly on a sub-project.
- `seleniumTest` - Execute functional test suite against localhost using local webdrivers.
- `seleniumGridTest` Execute functional test suite in Docker using Selenium Grid remote browsers.

### Creating a new release
* Create a new branch off of `develop` with the following pattern: `release-4.17.0` (4.17.0 is just an example for illustrative purposes)
* Change the version in `./build.gradle` to `4.17.0-RC`
* Push the branch
* Open a pull request into `master` to indicate to QC that the release is ready for final approval
* Once QC approves the PR, update the version in `./build.gradle` to the release version (4.17.0) and push
* Merge and delete the release branch
* Update the version in `./build.gradle` on the `develop` branch to the next SNAPSHOT version (4.18.0-SNAPSHOT) and push

### Running Locally With Docker
#### General Info
Typical docker-compose commands, such as `docker-compose up` can be executed 
from the `./docker-compose` directory. Alternatively, there are Gradle tasks 
that can start and stop the application stack for you. See below for details.

#### Full Liferay application stack
\* **To run with docker-compose, ports 1099, 3306, 4000, 5000, 8000, 8025, 8080, 
and 11311 are expected to be available on localhost.**

To start: `./gradlew composeUp`
To stop: `./gradlew composeDown`

#### Docker Environment Variables
Available variables are listed below with default options. JPDA is disabled by default, but can be activated by 
setting the environment variable `DEBUG="true"`, either via command line or a `docker-compose.yml` file. Any Liferay property can
be defined as an environment variable rather than defining it in a properties file. Liferay documentation for 
[environment variables](https://dev.liferay.com/discover/portal/-/knowledge_base/7-0/environment-variables) goes into 
detail on how to use environment variables to define portal properties.

The following are required environment variables with their defaults:
```
  CATALINA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2"
  DB_HOST=""
  DB_PORT=""
  DEBUG="false"
  ELASTICSEARCH_CLUSTER_NAME="LiferayElasticsearchCluster"
  ELASTICSEARCH_HOSTS="localhost:9300"
  LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD=""
  LIFERAY_MAIL_PERIOD_SESSION_PERIOD_MAIL_PERIOD_SMTP_PERIOD_HOST=""
  LIFERAY_MAIL_PERIOD_SESSION_PERIOD_MAIL_PERIOD_SMTP_PERIOD_PORT=""
  LIFERAY_REDIRECT_PERIOD_URL_PERIOD_IPS_PERIOD_ALLOWED="127.0.0.1,SERVER_IP"
  LIFERAY_WEB_PERIOD_SERVER_PERIOD_PROTOCOL="https"
 ```

#### Docker Ports
Port |Exposed|Purpose
-----|------|-----------------------
1025 |Yes   |Mailhog smtp
3306 |Yes   |MariaDB
8080 |Yes   |Normal Tomcat http port
8000 |Yes   |JPDA port for remote debugging
8025 |Yes   |Mailhog http UI
11311|Yes   |GoGo shell port

## Unit Testing