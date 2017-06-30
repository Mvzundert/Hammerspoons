-- Set constants
local Menu
local Settings = require("hs.settings")
local TimeOut = Settings.get("hs.TimeOut") or nil
local Timestamp = Settings.get("hs.Timestamp") or nil
local MenuIconOff = "./resources/caffeinateMenuOff.pdf"
local MenuIconOn = "./resources/caffeinateMenuOn.pdf"
local DefaultTimeOut = {
    seconds = nil,
    icon = "∞",
    title = "Indefinitely"
}
local MenuItems = {
  {
    seconds = 900,
    title = "15 minutes"
  },
  {
    seconds = 1800,
    title = "30 minutes"
  },
  {
    seconds = 3600,
    title = "60 minutes"
  },
  {
    seconds = 5400,
    title = "90 minutes"
  },
  {
    seconds = 7200,
    title = "120 minutes"
  },
  {
    seconds = nil,
    icon = "∞",
    title = "Indefinitely"
  }
}
-- Set functions
function CheckTimer()
  local currentTime = math.floor(hs.timer.secondsSinceEpoch())
  if Timestamp ~= nil then
    if TimeOut["seconds"] ~= nil then
      if ( currentTime - TimeOut["seconds"] ) > Timestamp then
        Toggle()
      else
        if not Menu then
          CreateMenu()
        else
          local LockedUntilTimestamp = ( Timestamp + TimeOut["seconds"] ) - currentTime - 3600
          local LockedUntil = os.date(" %H:%M:%S",LockedUntilTimestamp)
          Menu:setTooltip("Caffeinate: Locked for: "..LockedUntil)
          Menu:setTitle(LockedUntil)
        end
      end
    else
        if TimeOut["icon"] ~= nil  then
            Menu:setTitle(" "..TimeOut["icon"])
        else
            Menu:setTitle(nil)
        end
    end
  else
    Menu:setTooltip("Caffeinate")
    Menu:setTitle(nil)
  end
end
function Toggle()
  UpdateMenuItem(hs.caffeinate.toggle("displayIdle"))
end

function UpdateMenuItem(state)
  if not Menu then
    CreateMenu()
  end
  if state then
    if not TimeOut then
      TimeOut = DefaultTimeOut
    end
    informativeText = "Enabled for "..TimeOut["title"]
    Timestamp = math.floor(hs.timer.secondsSinceEpoch())
    Menu:setTooltip("Caffeinate: "..informativeText)
    Menu:setIcon(MenuIconOn)
    hs.notify.new({ title = "Caffeinate", informativeText = informativeText }):send()
  else
    Timestamp = nil
    TimeOut = nil
    Menu:setIcon(MenuIconOff)
    Menu:setTooltip("Caffeinate")
    hs.notify.new({ title = "Caffeinate", informativeText = "Disabled" }):send()
  end
  Settings.set("hs.Timestamp", Timestamp)
  Settings.set("hs.TimeOut", TimeOut)
end

function UpdateTimeout(timeout)
  Timestamp = math.floor(hs.timer.secondsSinceEpoch())
  Settings.set("hs.Timestamp", Timestamp)
  TimeOut = timeout
  Menu:setTooltip("Caffeinate: Enabled for "..TimeOut["title"])
  if not Timestamp then
    Toggle()
  else
    Menu:setIcon(MenuIconOn)
    Settings.set("hs.TimeOut", TimeOut)
  end
end

function CreateMenu()
  Menu = hs.menubar.new(true)
  Menu:setTooltip("Caffeinate")
  Menu:setIcon(MenuIconOff)
  Menu:setMenu(PopulateMenu)
  if Timestamp then
    hs.caffeinate.toggle("displayIdle")
    Menu:setIcon(MenuIconOn)
  end
end
-- Dynamic menu by cmsj https://github.com/Hammerspoon/hammerspoon/issues/61#issuecomment-64826257
PopulateMenu = function(key)
  MenuData = {}
  for timeoutKey, timeoutItem in pairs(MenuItems) do
    table.insert(
      MenuData,
      {
        title = timeoutItem["title"],
        fn = function() UpdateTimeout(timeoutItem) end
      }
    )
  end
  if TimeOut then
    table.insert(
      MenuData,
      1,
      {
        title = "Current: "..TimeOut["title"],
        fn = function() Toggle() end
      }
    )
    table.insert(MenuData, 2, { title = "-" })
  end
  return MenuData
end

-- Create menu item
CreateMenu()
-- Create timer
Timer = hs.timer.doEvery(1, function() CheckTimer() end)
-- Set the idle display to true --
hs.caffeinate.set('displayIdle', true)
-- Always put the state on the value  specified--
UpdateMenuItem(true)
