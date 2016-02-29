-----------------------------------------------
-- Set up
-----------------------------------------------

inspect = require "hs.inspect"
log = hs.logger.new('default', 'debug')

require "misc_helpers"
require "window_helpers"
require "layouts"
require "watchers"

currentLayout = nil
hyper = {"cmd", "alt", "ctrl"}
hotKeyDefinitions = {}

hs.window.animationDuration = 0

hs.grid.GRIDWIDTH  = 64
hs.grid.GRIDHEIGHT = 36
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

primaryScreen = 1
externalScreen = 2

-----------------------------------------------
-- Layouts
-----------------------------------------------

defaultLayout = {
  Atom = { primaryScreen, fullScreen },
  Evernote = { primaryScreen, fullScreen },
  SourceTree = { primaryScreen, fullScreen },
  Flowdock = { primaryScreen, fullScreen },
  Slack = { primaryScreen, fullScreen },
  iTerm = { primaryScreen, fullScreen },
  Firefox = { primaryScreen, fullScreen },
  Waterfox = { primaryScreen, fullScreen },
  PagerDuty = { primaryScreen, fullScreen },
  Feedly = { primaryScreen, fullScreen },
  Preview = { primaryScreen, fullScreen },
  Spotify = { primaryScreen, fullScreen },
  ["Google Chrome"] = { primaryScreen, fullScreen },
  ["Sublime Text"] = { primaryScreen, fullScreen },
  ["Zendesk Gmail"] = { primaryScreen, fullScreen },
  ["Zendesk Calendar"] = { primaryScreen, fullScreen },
  ["Google Inbox"] = { primaryScreen, fullScreen },
  ["Airmail"] = { primaryScreen, fullScreen }
}

twoMonitorDefault = {
  ["Sublime Text"] = { primaryScreen, leftHalf },
  Preview = { primaryScreen, leftHalf },
  Atom = { primaryScreen, leftHalf },
  Evernote = { primaryScreen, leftHalf },
  SourceTree = { primaryScreen, rightHalf },
  Flowdock = { primaryScreen, rightHalf },
  Slack = { primaryScreen, rightHalf },
  iTerm = { primaryScreen, rightHalf },
  Firefox = { primaryScreen, middleScreen },
  Waterfox = { primaryScreen, middleScreen },
  PagerDuty = { primaryScreen, middleScreen },
  Feedly = { externalScreen, fullScreen },
  Spotify = { externalScreen, fullScreen },
  Monitoring = { externalScreen, fullScreen },
  ["Google Chrome"] = { primaryScreen, middleScreen },
  ["Zendesk Gmail"] = { externalScreen, fullScreen },
  ["Zendesk Calendar"] = { externalScreen, fullScreen },
  ["Google Inbox"] = { externalScreen, fullScreen },
  ["Airmail"] = { externalScreen, fullScreen }
}

homeLayoutBase = {
  ["Zendesk Calendar"] = { primaryScreen, leftHalf },
  ["Zendesk Gmail"] = { primaryScreen, leftHalf },
  ["Google Inbox"] = { primaryScreen, leftHalf },
  ["Airmail"] = { primaryScreen, leftHalf }
}

workLayoutBase = {
  Flowdock = { externalScreen, fullScreen },
  Slack = { externalScreen, fullScreen }
}

homeLayout = joinMyTables(twoMonitorDefault, homeLayoutBase)
workLayout = joinMyTables(twoMonitorDefault, workLayoutBase)
currentLayout = defaultLayout

layouts = {
  [ "+69731840" ]          = defaultLayout,
  [ "+69678529" ]          = homeLayout,
  [ "+69508561+69731840" ] = workLayout,
}

-----------------------------------------------
-- Functions
-----------------------------------------------

function bossKey()
  return function()
    local apps = hs.application.runningApplications()
    for i = 1, #apps do
      apps[i]:hide()
    end
    hs.execute("open " .. "http://hackertyper.net/")
  end
end

function atWork()
  setAudioVolume(0)
  applyLayout(workLayout)
end

function atHome()
  setAudioVolume(25)
  applyLayout(homeLayout)
end

function onTheGo()
  setAudioVolume(0)
  applyLayout(defaultLayout)
end

function wifiChanged(ssid)
  if ssid == "zendesk" then
    atWork()
  elseif ssid == "HOME" then
    atHome()
  else
    onTheGo()
  end
end

function startWatchers()
  gScreenWatcher = hs.screen.watcher.new(screenWatcher):start()
  gAppWatcher = hs.application.watcher.new(applicationWatcher):start()
  gWifiWatcher = hs.wifi.watcher.new(wifiWatcher):start()
  -- gPathWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
end

-----------------------------------------------
-- Key bindings
-----------------------------------------------

hotKeyDefinitions = {
  Up    = gridset(fullScreen),
  Down  = gridset(middleScreen),
  Left  = gridset(leftHalf),
  Right = gridset(rightHalf),

  pad2  = reduceWindowSize(),
  pad4  = gridset(leftHalf),
  pad5  = gridset(middleScreen),
  pad6  = gridset(rightHalf),
  pad8  = increaseWindowSize(),

  C     = activateApp("Google Chrome"),
  E     = activateApp("Zendesk Gmail"),
  F     = activateApp("Flowdock"),
  T     = activateApp("iTerm"),
  A     = activateApp("Atom"),

  X     = bossKey()
}

-----------------------------------------------
-- Init
-----------------------------------------------

startWatchers()
createHotkeys(hotKeyDefinitions)
screenWatcher()

hs.hotkey.bind(hyper, '\\', function()
  reloadConfig()
end)

hs.alert.show("Config reloaded")
