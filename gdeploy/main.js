#!/usr/bin/env node
/**
 * @module gdeploy
 * 
 * @license Unlicense
 */
const connect = require('node-firefox-connect')
const installApp = require('node-firefox-install-app')
const {execSync} = require('child_process')
const fs = require('fs')
const path = require('path')

const DEBUGGER_PORT = process.env['DEBUGGER_PORT'] || 6000

const libCache = {manager: null, client: null}

function reportError(err) {
  console.error(err) 
  process.exit(1)
}

function exitApp() {
  process.exit(0)
}

function getRawAppManager() {
  return new Promise(async (resolve, reject) => {
    if(libCache.manager) {
      resolve(libCache.manager)
      return
    }
    execSync(`adb forward tcp:${DEBUGGER_PORT} localfilesystem:/data/local/debugger-socket`)
    let client = await connect(DEBUGGER_PORT)
    client.getWebapps((err, manager) => {
      if(err) reject(err)
      else {
        libCache.manager = manager
        libCache.client = client
        resolve(manager)
      }
    })
  })
}

function list() {
  return new Promise(async (resolve, reject) => {
    let manager = await getRawAppManager()
    manager.getInstalledApps(function(err, apps) {
      if(err) reject(err)
      else resolve(apps)
    })
  })
}

function install(dirPath) {
  return new Promise(async (resolve, reject) => {
    let manager = await getRawAppManager()
    installApp({appPath: path.resolve(dirPath), client: libCache.client})
      .then(function(appId) {
        resolve(appId)
      }, function(err) {
        reject(err)
      })
  })
}

function uninstall(manifestUrl) {
  return new Promise(async (resolve, reject) => { 
    let manager = await getRawAppManager()
    manager.uninstall(manifestUrl, function(err, apps) {
      if(err) reject(err)
      else resolve()
    })
  })
}

function start(manifestUrl) {
  return new Promise(async (resolve, reject) => { 
    let manager = await getRawAppManager()
    manager.launch(manifestUrl, function(err, apps) {
      if(err) reject(err)
      else resolve()
    })
  })
}

function stop(manifestUrl) {
  return new Promise(async (resolve, reject) => { 
    let manager = await getRawAppManager()
    let client = libCache.client
    manager.close(manifestUrl, function(err, apps) {
      if(err) reject(err)
      else resolve()
    })
  })
}

function evaluateJsInAppContext(manifestUrl, js) {
  return new Promise(async (resolve, reject) => { 
    let manager = await getRawAppManager()
    manager.getApp(manifestUrl, function(err, app) {
      if(err) {
        reject(err)
        return
      }
      app.Console.evaluateJS(js.toString(), (err, resp) => {
        if(err) reject(err)
        else resolve(resp.result)
      })
    })
  })
}

function idToManifest(id) {
  return id.indexOf('://') > -1 ? id : `app://${id}/manifest.webapp`
}

if(module.parent) {
  module.exports = {
    getRawAppManager,
    list,
    install,
    uninstall,
    start,
    stop,
    evaluateJsInAppContext
  }
} else {
  function usage() {
    console.log('Usage: gdeploy [list|install DIR|uninstall ID|start ID|stop ID|evaluate ID "script"]')
    process.exit(1)
  }

  console.log('GDEPLOY\n-------')

  var cmd = process.argv[2], param = process.argv[3], param2 = process.argv[4]


  if(!cmd) usage()
  cmd = cmd.toLowerCase()
  if(!param && cmd!=='list') usage();
  if(!param2 && cmd==='evaluate') usage();

  switch(cmd) {
    case 'list':
      list().then(apps => {
        for(let app of apps)
          console.log(`${app.name} ${app.localId} ${app.manifestURL}`)
        exitApp()
      }).catch(reportError)
      break
    case 'install':
      install(param).then(appId => {
        console.log(`Application ${appId} installed successfully`)
        exitApp()
      }).catch(reportError)
      break
    case 'uninstall':
      uninstall(idToManifest(param)).then(() => {
        console.log(`Application ${param} uninstalled successfully`)
        exitApp()
      }).catch(reportError)
      break
    case 'start':
      start(idToManifest(param)).then(() => {
        console.log(`Application ${param} started successfully`)
        exitApp()
      }).catch(reportError)
      break
    case 'stop':
      stop(idToManifest(param)).then(() => {
        console.log(`Application ${param} stopped successfully`)
        exitApp()
      }).catch(reportError)
      break
    case 'evaluate':
      evaluateJsInAppContext(idToManifest(param), param2).then(resp => {
        console.log(`Script run in the ${param} app context evaluated to:`, resp)
        exitApp()
      }).catch(reportError)
      break
    default:
      usage()
  }
}
