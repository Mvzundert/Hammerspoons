hsreload_keys = hsreload_keys or {{"cmd", "shift", "ctrl"}, "R"}
if string.len(hsreload_keys[2]) > 0 then
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "Reload Configuration", function() hs.reload() end)
end

lockscreen_keys = lockscreen_keys or {{"cmd", "shift", "ctrl"}, "L"}
if string.len(lockscreen_keys[2]) > 0 then
    hs.hotkey.bind(lockscreen_keys[1], lockscreen_keys[2],"Lock Screen", function() hs.caffeinate.lockScreen() end)
end
