-- Set up hotkey combinations
local mashshift = {"cmd", "alt", "shift"}
local funkymash = {"cmd", "ctrl", "shift"}

hs.hotkey.bind(mashshift, 'space', hs.spotify.displayCurrentTrack)
hs.hotkey.bind(mashshift, 'P',     hs.spotify.play)
hs.hotkey.bind(mashshift, 'O',     hs.spotify.pause)
hs.hotkey.bind(mashshift, 'N',     hs.spotify.next)
hs.hotkey.bind(mashshift, 'I',     hs.spotify.previous)

hs.hotkey.bind(funkymash, 'space', hs.itunes.displayCurrentTrack)
hs.hotkey.bind(funkymash, 'P',     hs.itunes.play)
hs.hotkey.bind(funkymash, 'O',     hs.itunes.pause)
hs.hotkey.bind(funkymash, 'N',     hs.itunes.next)
hs.hotkey.bind(funkymash, 'I',     hs.itunes.previous)
