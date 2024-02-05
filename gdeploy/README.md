# gdeploy - an open and simple CLI application manager for KaiOS

## About it

gdeploy is a small cross-platform utility (can be also used as a NodeJS module/library) created by BananaHackers group members as an answer to removal of kdeploy CLI client for NodeJS from all public sources (namely NPM and GitHub). It uses the same `firefox-client` backend but has much simpler architecture for application management.

The utility is completely open-source and released into the public domain. For more details, please see UNLICENSE file in this repo or [Unlicense page](https://unlicense.org).

## Prerequisites

- NodeJS (12 LTS or newer should be fine);
- ADB and zip installed in the system.

## Installation

1. Clone this repo;
2. Run `npm i && npm link`.

## Usage

### List all installed apps

- Command: `gdeploy list`
- Library call: `gdeploy.list().then(apps => ...).catch(err =>)`

### Install an app from directory

- Command: `gdeploy install [DIR_PATH]`
- Library call: `gdeploy.install(dir).then(appId => ...).catch(err => ...)`

### Uninstall an app

- Command: `gdeploy uninstall [APP_ID]`
- Library call: `gdeploy.uninstall(appManifestUrl).then(() => ...).catch(err => ...)`

### Start an app

- Command: `gdeploy start [APP_ID]`
- Library call: `gdeploy.start(appManifestUrl).then(() => ...).catch(err => ...)`

### Stop an app

- Command: `gdeploy stop [APP_ID]`
- Library call: `gdeploy.stop(appManifestUrl).then(() => ...).catch(err => ...)`

### Evaluate JS in the app's context

- Command: `gdeploy evaluate [APP_ID] "[JS_PROGRAM_STRING]"`
- Library call: `gdeploy.evaluateJsInAppContext(appManifestUrl, jsProgramString).then(evaluationResult => ...).catch(err => ...)`

## Caveats

1. If you need to use other port than the default 6000 for debugger connection, you need to set the DEBUGGER_PORT environment variable, e.g. `DEBUGGER_PORT=5252 gdeploy list` etc.
2. Unless you have performed a privileged mode reset, the contexts of systemwide preinstalled apps will not be available to you. Remember, this utility can only see the same scope of apps as a regular WebIDE connection.
3. For simplicity sake, library calls always work with full manifest URLs as opposed to just application IDs. Essentially, one is not hard to shape from another.

## Credits

Proudly created by [BananaHackers group](https://bananahackers.net) representatives.
