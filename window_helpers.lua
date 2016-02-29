function gridset(frame)
  return function()
    local win = hs.window.focusedWindow()
    if win then
      hs.grid.set(win, frame, win:screen())
    end
  end
end

function reduceWindowSize()
  return function()
    local win = hs.window.focusedWindow()
    if win then
      local currentFrame = hs.grid.get(win)
      local newX = currentFrame.x + 3
      local newY = currentFrame.y + 3
      local newH = currentFrame.h - 5
      local newW = currentFrame.w - 5
      local newFrame = { x = newX, y = newY, h = newH, w = newW }
      hs.grid.set(win, newFrame, win:screen())
    end
  end
end

function increaseWindowSize()
  return function()
    local win = hs.window.focusedWindow()
    if win then
      local currentFrame = hs.grid.get(win)
      local newX = currentFrame.x - 3
      local newY = currentFrame.y - 3
      local newH = currentFrame.h + 5
      local newW = currentFrame.w + 5
      local newFrame = { x = newX, y = newY, h = newH, w = newW }
      hs.grid.set(win, newFrame, win:screen())
    end
  end
end

function applyPlace(win, place)
  hs.grid.set(win, place[2], hs.screen:allScreens()[place[1]])
end

function applyLayout(layout)
  for appName, place in pairs(layout) do
    local app = hs.appfinder.appFromName(appName)
    if app then
      for i, win in ipairs(app:allWindows()) do
        applyPlace(win, place)
      end
    end
  end
end

function activateApp(appName)
  return function()
    hs.application.find(appName):activate()
  end
end
