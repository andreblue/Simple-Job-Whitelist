local Config = {
  table = { --Table Names
    jobs = "whitelist_jobs", --Which table to store jobs in that need to be whitelisted
    whitelist = "whitelist_users" --Which table to store users and their allowed jobs
  },
  allowed_whitelist = { --Which groups can whitelist/remove whitelists from a player.
    "superadmin",
    "admin"
  },
  allowed_whitelist_edit = { --Which groups can enable and disable whitelists on a job.
    "superadmin",
    "admin"
  }
}



--Do not touch below.
local newTable = {}
for k,v in ipairs(Config.allowed_whitelist) do
  newTable[v] = true
end
Config.allowed_whitelist = newTable
newTable = {}
for k,v in ipairs(Config.allowed_whitelist_edit) do
  newTable[v] = true
end
Config.allowed_whitelist_edit = newTable

return Config
