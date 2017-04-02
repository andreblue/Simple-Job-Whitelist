
function whitelist.Message(...)
  MsgC(Color(255, 102, 0), "[Whitelist System] ")
  MsgC(...)
  MsgN()
end
function whitelist.GetTeam(Team)
  --Check if its a number right off.
  if tonumber(Team) then
    return tonumber(Team)
  end
  --Is it TEAM_ named?
  if string.find(Team, "TEAM_") then
    local teamcheck = _G[Team]
    if isnumber(teamcheck) and teamcheck > 0 then
      return teamcheck
    end
  end
  --Lookup team by name then.
  local teams = team.GetAllTeams()
  for team_id, data in pairs(teams) do
    if data.Name and data.Name == Team then
      return team_id
    end
  end
  return false
end

if SERVER then
  function whitelist.SendErrorMessage(msg, reciever)
    net.Start("Whitelist_Message_Relay")
      net.WriteString("Message") -- Telling what data we will send
      net.WriteBool(true) -- Means an error message is coming.
      net.WriteString(msg)
    net.Send(reciever)
  end
    function whitelist.SendMessage(msg, reciever)
      net.Start("Whitelist_Message_Relay")
        net.WriteString("Message") -- Telling what data we will send
        net.WriteBool(false) -- Means an error message is coming.
        net.WriteString(msg)
      net.Send(reciever)
    end
end
