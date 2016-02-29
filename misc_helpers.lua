function clone(t)
  if type(t) ~= "table" then return t end
  local meta = getmetatable(t)
  local target = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      target[k] = clone(v)
    else
      target[k] = v
    end
  end
  setmetatable(target, meta)
  return target
end

function joinMyTables(t1, t2)
  local t3 = clone(t1)
  for k, v in pairs(t2) do t3[k] = v end
  return t3
end


function reloadConfig(files)
  hs.reload()
end

function notifyUser(title, detail, delay)
  local note = hs.notify.new({ title = title, informativeText = detail }):send()

  if not delay then
    delay = 3
  end

  if delay > 0 then
    hs.timer.doAfter(delay, function ()
      note:withdraw()
      note = nil
    end)
  end
end

function createHotkeys(definitions)
  for key, fun in pairs(definitions) do
    hs.hotkey.new(hyper, key, fun):enable()
  end

  hs.hotkey.bind(hyper, '\\', function()
    reloadConfig()
  end)
end

function setAudioVolume(percent)
  hs.audiodevice.defaultOutputDevice():setVolume(percent)
end
