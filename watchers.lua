function wifiWatcher()
  local currentWifi = hs.wifi.currentNetwork()
  if not currentWifi then return end
  notifyUser("Connected to WiFi", "Now connected to " .. currentWifi)
  wifiChanged(currentWifi)
end

function applicationWatcher(appName, eventType, appObject)
  if (
    (eventType == hs.application.watcher.launching) or
    (eventType == hs.application.watcher.launched)
  ) then
    if currentLayout then
      applyLayout(currentLayout)
    end
  end
end

function screenWatcher()
  local identifier = ""
  for _, curScreen in pairs(hs.screen.allScreens()) do
    identifier = identifier .. "+" .. curScreen:id()
  end

  log:d("Screen unique identifier : ".. identifier)

  if layouts[identifier] then
    notifyUser("Layout", "Applying " .. identifier)
    currentLayout = layouts[identifier]
  else
    currentLayout = defaultLayout
  end

  applyLayout(currentLayout)
end
