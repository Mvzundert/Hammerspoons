--[==============[
Custom widgets and stuff regarding Hammerspoon
--]==============]

--[==============[
hs cleanup stuff.
--]==============]
hs.hotkey.alertDuration=0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

--[==============[
Don't remove this line in fear of breaking basicmode.
also don't turn off basicmode or modal.
Should probably be a better way to solve this.
--]==============]
modal_list = {}

require "basicmode"
require "modal"

--[==============[
Check for Private path that could contain custom_config.
 We create it when it doesn't exist,
so we can .gitignore the private folder without doing funky stuff
--]==============]
privatepath = hs.fs.pathToAbsolute(hs.fs.currentDir()..'/private')
if privatepath == nil then
    hs.fs.mkdir(hs.fs.currentDir()..'/private')
end

--[==============[
If we find a file named custom_config.lua we require it.
--]==============]
privateconf = hs.fs.pathToAbsolute(hs.fs.currentDir()..'/private/custom_config.lua')
if privateconf ~= nil then
    require('private/custom_config')
end

--[==============[
Custom PHP like print_r function
Used for debugging hammerspoon
--]==============]
function print_r(t)
  local print_r_cache = {}
  local function sub_print_r(t, indent)
    if (print_r_cache[tostring(t)]) then
      print(indent .. "*" .. tostring(t))
    else
      print_r_cache[tostring(t)] = true
      if (type(t) == "table") then
        for pos, val in pairs(t) do
          if (type(val) == "table") then
            print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
            sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
            print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
          elseif (type(val) == "string") then
            print(indent .. "[" .. pos .. '] => "' .. val .. '"')
          else
            print(indent .. "[" .. pos .. "] => " .. tostring(val))
          end
        end
      else
        print(indent .. tostring(t))
      end
    end
  end
  if (type(t) == "table") then
    print(tostring(t) .. " {")
    sub_print_r(t, " ")
    print("}")
  else
    sub_print_r(t, " ")
  end
  print()
end

--[==============[
Currently default disabled modules:
  - "modes/indicator",
  - "modes/clipshow",
  - "widgets/analogclock",
  - "widgets/showtime",
  - "widgets/netspeed",
  - "widgets/windowfocus",
  - "widgets/caffeinate",
Enable them for your own use when needed.
--]==============]
if not module_list then
    module_list = {
        "widgets/keybindings",
        "widgets/hotkeys",
        "widgets/hcalendar",
        "widgets/music",
        "widgets/colors",
        "widgets/clipboard",
        "modes/hsearch",
    }
end

--[==============[
       / \    )\__/(     / \
      /   \  (_\  /_)   /   \
____ /_____\__\@  @/___/_____\____
|             |\../|              |
|              \VV/               |
|                                 |
|        Here be dragons.         |
|_________________________________|
|    /\ /      \\       \ /\    |
|  /   V        ))       V   \  |
|/     `       //        '     \|
`              V                '
--]==============]

for i=1,#module_list do
    require(module_list[i])
end

if #modal_list > 0 then
  require("modalmgr")
end
