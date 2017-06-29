-- Set constants
local caffeinateMenu
local caffeinateSettings = require("hs.settings")
local caffeinateTimeOut = caffeinateSettings.get("hs.caffeinateTimeOut") or nil
local caffeinateTimestamp = caffeinateSettings.get("hs.caffeinateTimestamp") or nil
local caffeinateMenuIconOff = "./resources/caffeinateMenuOff.pdf"
local caffeinateMenuIconOn = "./resources/caffeinateMenuOn.pdf"
local caffeinateMenuItems = {
  {
    seconds = 900,
    string = "15 minutes"
  },
  {
    seconds = 1800,
    string = "30 minutes"
  },
  {
    seconds = 3600,
    string = "60 minutes"
  },
  {
    seconds = 5400,
    string = "90 minutes"
  },
  {
    seconds = 7200,
    string = "120 minutes"
  },
  {
    seconds = nil,
    string = "Indefinitely"
  }
}

-- Set functions
function caffeinateCheckTimer()
  local currentTime = math.floor(hs.timer.secondsSinceEpoch())

  if caffeinateTimestamp ~= nil then
    if caffeinateTimeOut["seconds"] ~= nil then
      if ( currentTime - caffeinateTimeOut["seconds"] ) > caffeinateTimestamp then
        caffeinateToggle()
      else
        if not caffeinateMenu then
          caffeinateCreateMenu()
        else
          local caffeinateLockedUntilTimestamp = ( caffeinateTimestamp + caffeinateTimeOut["seconds"] ) - currentTime - 3600
          local caffeinateLockedUntil = os.date("%H:%M:%S",caffeinateLockedUntilTimestamp)

          caffeinateMenu:setTooltip("Caffeinate: Locked for: "..caffeinateLockedUntil)
        end
      end
    end
  else
    caffeinateMenu:setTooltip("Caffeinate")
  end
end

function caffeinateToggle()
  caffeinateUpdateMenuItem(hs.caffeinate.toggle("displayIdle"))
end

function caffeinateUpdateMenuItem(state)
  if not caffeinateMenu then
    caffeinateCreateMenu()
  end

  if state then
    if not caffeinateTimeOut then
      caffeinateTimeOut = {
        seconds = nil,
        string = "Indefinitely"
      }
    end

    informativeText = "Enabled for "..caffeinateTimeOut["string"]

    caffeinateTimestamp = math.floor(hs.timer.secondsSinceEpoch())

    caffeinateMenu:setTooltip("Caffeinate: "..informativeText)
    caffeinateMenu:setIcon(caffeinateMenuIconOn)

    hs.notify.new({ title = "Caffeinate", informativeText = informativeText }):send()
  else
    caffeinateTimestamp = nil
    caffeinateTimeOut = nil

    caffeinateMenu:setIcon(caffeinateMenuIconOff)
    caffeinateMenu:setTooltip("Caffeinate")

    hs.notify.new({ title = "Caffeinate", informativeText = "Disabled" }):send()
  end

  caffeinateSettings.set("hs.caffeinateTimestamp", caffeinateTimestamp)
  caffeinateSettings.set("hs.caffeinateTimeOut", caffeinateTimeOut)
end

function caffeinateUpdateTimeout(timeout)
  caffeinateTimeOut = timeout

  caffeinateMenu:setTooltip("Caffeinate: Enabled for "..caffeinateTimeOut["string"])

  if not caffeinateTimestamp then
    caffeinateToggle()
  else
    caffeinateMenu:setIcon(caffeinateMenuIconOn)

    caffeinateSettings.set("hs.caffeinateTimeOut", caffeinateTimeOut)
  end
end

function caffeinateCreateMenu()
  caffeinateMenu = hs.menubar.new(true)
  caffeinateMenu:setTooltip("Caffeinate")
  caffeinateMenu:setIcon(caffeinateMenuIconOff)
  caffeinateMenu:setMenu(caffeinatePopulateMenu)

  if caffeinateTimestamp then
    hs.caffeinate.toggle("displayIdle")

    caffeinateMenu:setIcon(caffeinateMenuIconOn)
  end
end

-- Dynamic menu by cmsj https://github.com/Hammerspoon/hammerspoon/issues/61#issuecomment-64826257
caffeinatePopulateMenu = function(key)
  caffeinateMenuData = {}

  for timeoutKey, timeoutItem in pairs(caffeinateMenuItems) do
    table.insert(
      caffeinateMenuData,
      {
        title = timeoutItem["string"],
        fn = function() caffeinateUpdateTimeout(timeoutItem) end
      }
    )
  end

  if caffeinateTimeOut then
    table.insert(
      caffeinateMenuData,
      1,
      {
        title = "Current: "..caffeinateTimeOut["string"],
        fn = function() caffeinateToggle() end
      }
    )

    table.insert(caffeinateMenuData, 2, { title = "-" })
  end

  return caffeinateMenuData
end

-- Create menu item
caffeinateCreateMenu()

-- Create timer
caffeinateTimer = hs.timer.doEvery(5, function() caffeinateCheckTimer() end)

-- Set the idle display to true -- 
hs.caffeinate.set('displayIdle', true)
-- Always put the state on the value  specified--
caffeinateUpdateMenuItem(true)
