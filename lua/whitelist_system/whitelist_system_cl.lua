
whitelist = {}
include "whitelist_functions.lua"
whitelist.Message("Starting up.")
net.Receive("Whitelist_Message_Relay",function()
  local typeOf = net.ReadString()
  if typeOf == "Message" then
    local isError = net.ReadBool()
    local message = net.ReadString()
    if isError then
      message = "[Error] " .. message
    end
    whitelist.Message(message)
  end
end)
