if SERVER then
	AddCSLuaFile()
	include("whitelist_system/whitelist_system.lua")
elseif CLIENT then
	include("whitelist_system/whitelist_system_cl.lua")
end