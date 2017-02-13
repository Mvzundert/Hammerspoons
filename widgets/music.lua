-- Set up hotkey combinations
local mashshift = {"cmd", "alt", "shift"}

hs.hotkey.bind(mashshift, 'space', hs.spotify.displayCurrentTrack)
hs.hotkey.bind(mashshift, 'P',     hs.spotify.play)
hs.hotkey.bind(mashshift, 'O',     hs.spotify.pause)
hs.hotkey.bind(mashshift, 'N',     hs.spotify.next)
hs.hotkey.bind(mashshift, 'I',     hs.spotify.previous)
