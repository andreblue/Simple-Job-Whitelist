
whitelist = {}
--Config
whitelist.config = include("whitelist_config.lua")

--Net Messages
util.AddNetworkString("Whitelist_Message_Relay")

--Helper functions
include "whitelist_functions.lua"
AddCSLuaFile("whitelist_functions.lua")
AddCSLuaFile("whitelist_system/whitelist_system_cl.lua")
whitelist.Message("Starting up.")
--Database functions
include "whitelist_sqlite.lua"
--Reload Config Command
concommand.Add("whitelist_reload_config", function(ply)
    if IsValid(ply) then return end
    whitelist.config = include("whitelist_config.lua")
    whitelist.Message("Reloaded Config!")
end)

whitelist.Populate()

--Hook
hook.Add("playerCanChangeTeam","WhitelistJobChangeCheck", function(ply, team, force)
  local isWhitelisted, forced = whitelist.CheckJob(team)
  if isWhitelisted then
    if force and forced then
      return false, "You need to be whitelisted to use this job and can not be forced into it."
    end
    if force then
      return true
    end
    if whitelist.CheckUser(ply:SteamID(), team) then
      return true
    else
      return false , "You need to be whitelisted to use this job."
    end
  end
end)

--Concommands for whitelisting
--Add Job
concommand.Add("whitelist_add_job", function(ply, cmd, args)
    if IsValid(ply) then
      if not whitelist.config.allowed_whitelist_edit[ply:GetUserGroup()] then return end
    end
    local job = args[1]
    job = whitelist.GetTeam(job)
    if job == false then
      if IsValid(ply) then
        whitelist.SendErrorMessage("Invalid Job", ply)
      end
      whitelist.Message("Invalid Job")
      return
    end
    local force = false
    if args[2] and (args[2] == "1" or args[2] == 1)   then
      force = true
    end
    if IsValid(ply) then
      whitelist.Message(ply:GetName() .."["..ply:SteamID().."] tried to add job " .. tostring(job) .. " to the whitelist system.")
    end
    whitelist.Add(job, force, ply)
end)
--Remove Job
concommand.Add("whitelist_remove_job", function(ply, cmd, args)
    if IsValid(ply) then
      if not whitelist.config.allowed_whitelist_edit[ply:GetUserGroup()] then return end
    end
    local job = args[1]
    job = whitelist.GetTeam(job)
    if job == false then
      if IsValid(ply) then
        whitelist.SendErrorMessage("Invalid Job", ply)
      end
      whitelist.Message("Invalid Job")
      return
    end

    if IsValid(ply) then
      whitelist.Message(ply:GetName() .."["..ply:SteamID().."] tried to remove job " .. tostring(job) .. " from the whitelist system.")
    end
    whitelist.Remove(job, ply)
end)
--Add User
concommand.Add("whitelist_add_user", function(ply, cmd, args)
    if IsValid(ply) then
      if not whitelist.config.allowed_whitelist_edit[ply:GetUserGroup()] then return end
    end
    local job = args[1]
    job = whitelist.GetTeam(job)
    if job == false then
      if IsValid(ply) then
        whitelist.SendErrorMessage("Invalid Job", ply)
      end
      whitelist.Message("Invalid Job")
      return
    end
    if args[2] then
      if not string.find(args[2],"STEAM_") then
        args[2] = DarkRP.findPlayer(args[2])
          if not IsValid(args[2]) then
            if IsValid(ply) then
              whitelist.SendErrorMessage("Invalid player", ply)
            end
            whitelist.Message("Invalid player")
            return
          else
            args[2] = args[2]:SteamID()
          end
      end
    end

    if IsValid(ply) then
      whitelist.Message(ply:GetName() .."["..ply:SteamID().."] tried to add " .. tostring(args[2]) .. " to the whitelist for " .. tostring(job))
    end
    whitelist.AddPlayer(args[2], job, ply)
end)
--Remove User
concommand.Add("whitelist_remove_user", function(ply, cmd, args)
  if IsValid(ply) then
    if not whitelist.config.allowed_whitelist_edit[ply:GetUserGroup()] then return end
  end
  local job = args[1]
  job = whitelist.GetTeam(job)
  if job == false then
    if IsValid(ply) then
      whitelist.SendErrorMessage("Invalid Job", ply)
    end
    whitelist.Message("Invalid Job")
    return
  end
  if args[2] then
    if not string.find(args[2],"STEAM_") then
      args[2] = DarkRP.findPlayer(args[2])
        if not IsValid(args[2]) then
          if IsValid(ply) then
            whitelist.SendErrorMessage("Invalid player", ply)
          end
          whitelist.Message("Invalid player")
          return
        else
          args[2] = args[2]:SteamID()
        end
    end
  end

  if IsValid(ply) then
    whitelist.Message(ply:GetName() .."["..ply:SteamID().."] tried to remove " .. tostring(args[2]) .. " from the whitelist for " .. tostring(job))
  end
    whitelist.RemovePlayer(args[2], job, ply)
end)
