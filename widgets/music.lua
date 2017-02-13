-- Set up hotkey combinations
local mashshift = {"cmd", "alt", "shift"}

-- Set volume increments
local volumeIncrement = 5

hs.hotkey.bind(mashshift, 'space', hs.spotify.displayCurrentTrack)
hs.hotkey.bind(mashshift, 'P',     hs.spotify.play)
hs.hotkey.bind(mashshift, 'O',     hs.spotify.pause)
hs.hotkey.bind(mashshift, 'N',     hs.spotify.next)
hs.hotkey.bind(mashshift, 'I',     hs.spotify.previous)

hs.hotkey.bind(mashshift, 'T', function() hs.alert.show(os.date("%A %b %d, %Y - %I:%M%p"), 4) end)

hs.hotkey.bind(mashshift, ']', function() hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.current().volume + 5) end)
hs.hotkey.bind(mashshift, '[', function() hs.audiodevice.defaultOutputDevice():setVolume(hs.audiodevice.current().volume - 5) end)
