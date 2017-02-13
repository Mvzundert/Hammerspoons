local gmail = require "widgets/gmailMenu"
local menubar = {}

local gmailBars = {}

local apiKey = nil
local credFile = nil
local gmailCreds = {}

function menubar.init()
   if file_exists("private/gmail_creds.lua") then
      credFile = require "private/gmail_creds"
      updateGmailBar()
      hs.timer.doEvery(2*60, updateGmailBar)
   else
      hs.alert.show('GmailBar in use, but no gmail_creds file found!')
   end
end

function updateGmailBar()
   for index, gmailBar in ipairs(gmailBars) do
      gmailBar:delete()
   end

   gmailBars = {}

   for index, creds in ipairs(credFile) do
      gmail.mailCount(creds.username, creds.password, function(count)
         if count > 0 then
            local gmailBar = hs.menubar.new()
            gmailBar:setTitle('📬' .. count)
            gmailBar:setMenu({
                  {title = creds.username,
                   fn = updateGmailBar}})
            table.insert(gmailBars, gmailBar)
         end
      end)
   end
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then
      io.close(f)
      return true
   else
      return false
   end
end

return menubar
