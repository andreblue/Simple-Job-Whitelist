
function whitelist.Populate()
  if not sql.TableExists( whitelist.config.table.jobs ) then
    local created = sql.Query( "CREATE TABLE " .. sql.SQLStr(whitelist.config.table.jobs) .. "(job_id INT PRIMARY KEY UNIQUE NOT NULL, ignore_force BOOLEAN NOT NULL);" )
    if created == false then
      whitelist.Message("Error creating jobs table.")
      whitelist.Message(sql.LastError())
    else
      whitelist.Message("Created jobs table.")
    end
  end
  if not sql.TableExists( whitelist.config.table.whitelist ) then
    local created = sql.Query( "CREATE TABLE " .. sql.SQLStr(whitelist.config.table.whitelist) .. "(steam_id TEXT NOT NULL, job INT NOT NULL, name TEXT);" )
    if created == false then
      whitelist.Message("Error creating whitelist table.")
      whitelist.Message(sql.LastError())
    else
      whitelist.Message("Created whitelist table.")
    end
  end
end

--Add a job to the whitelist
function whitelist.Add(Team, ignoreForce, adder)
  Team = whitelist.GetTeam(Team)
  if Team == false then
    if IsValid(adder) then
      whitelist.SendErrorMessage("Team could not be found. Please try again.", adder)
    else
      whitelist.Message("Failed to find team. Please try again.")
    end
    return
  end
  if ignoreForce ~= true then ignoreForce = false end

  local exists = sql.QueryRow( "SELECT * FROM " .. sql.SQLStr(whitelist.config.table.jobs) .. " WHERE job_id = " .. sql.SQLStr(Team) .. ";" )
  if exists then
    local created =  sql.Query( "UPDATE " .. sql.SQLStr(whitelist.config.table.jobs) .. " SET ignore_force = " .. sql.SQLStr(ignoreForce) .. " WHERE job_id = " .. sql.SQLStr(Team) .. ";" )
    if created == false then
      whitelist.Message("Error updating job to job table.")
      whitelist.Message(sql.LastError())
      if IsValid(adder) then
        whitelist.SendErrorMessage("Error updating job to job table.", adder)
      end
    else
      whitelist.Message("Updated job in job table.")
      if IsValid(adder) then
        whitelist.SendMessage("Updated job in job table.", adder)
      end
    end
  else
    local created =  sql.Query( "INSERT INTO " .. sql.SQLStr(whitelist.config.table.jobs) .. "(job_id, ignore_force) VALUES (" .. sql.SQLStr(Team) .. ", " .. sql.SQLStr(ignoreForce) .. ");" )
    if created == false then
      whitelist.Message("Error adding job to job table.")
      whitelist.Message(sql.LastError())
      if IsValid(adder) then
        whitelist.SendErrorMessage("Error adding job to job table.", adder)
      end
    else
      whitelist.Message("Added job to job table.")
      if IsValid(adder) then
        whitelist.SendMessage("Added job to job table.", adder)
      end
    end
  end
end

--Remove a job from the whitelist
function whitelist.Remove(Team, adder)
  Team = whitelist.GetTeam(Team)
  if Team == false then
    if IsValid(adder) then
      whitelist.SendErrorMessage("Team could not be found. Please try again.", adder)
    else
      whitelist.Message("Failed to find team. Please try again.")
    end
    return
  end
  local exists = sql.QueryRow( "SELECT * FROM " .. sql.SQLStr(whitelist.config.table.jobs) .. " WHERE job_id = " .. sql.SQLStr(Team) .. ";" )
  if exists then
    local created =  sql.Query( "DELETE FROM " .. sql.SQLStr(whitelist.config.table.jobs) .. " WHERE job_id = " .. sql.SQLStr(Team) .. ";" )
    if created == false then
      whitelist.Message("Error deleting job from job table.")
      whitelist.Message(sql.LastError())
      if IsValid(adder) then
        whitelist.SendErrorMessage("Error removing job from job table.", adder)
      end
    else
      whitelist.Message("Removed job from job table.")
      if IsValid(adder) then
        whitelist.SendMessage("Removed job from job table.", adder)
      end
    end
  else
    if IsValid(adder) then
      whitelist.SendErrorMessage("Team is not a whitelisted team.", adder)
    else
      whitelist.Message("Team is not a whitelisted team.")
    end
  end
end
--Add Player to job whitelist
function whitelist.AddPlayer(steam_id, job_id, adder)
  job_id = whitelist.GetTeam(job_id)
  local exists = sql.QueryRow( "SELECT * FROM " .. sql.SQLStr(whitelist.config.table.whitelist) .. " WHERE job_id = " .. sql.SQLStr(job_id) .. " AND steam_id = " .. sql.SQLStr(steam_id) .. ";" )
  if exists then
    whitelist.Message("User already exist. Can not add again.")
    if IsValid(adder) then
      whitelist.SendErrorMessage("User already exist. Can not add again.", adder)
    end
  else
    local created =  sql.Query( "INSERT INTO " .. sql.SQLStr(whitelist.config.table.whitelist) .. "(steam_id, job) VALUES (" .. sql.SQLStr(steam_id) .. ", " .. sql.SQLStr(job_id) .. ");" )
    if created == false then
      whitelist.Message("Error adding user to whitelist table.")
      whitelist.Message(sql.LastError())
      if IsValid(adder) then
        whitelist.SendErrorMessage("Error adding user to whitelist table.", adder)
      end
    else
      whitelist.Message("User added to whitelist table.")
      if IsValid(adder) then
        whitelist.SendMessage("User added to whitelist table.", adder)
      end
    end
  end
end
--Remove Player from job whitelist
function whitelist.RemovePlayer(steam_id, job_id, adder)
  job_id = whitelist.GetTeam(job_id)
  local exists = sql.QueryRow( "SELECT * FROM " .. sql.SQLStr(whitelist.config.table.whitelist) .. " WHERE job = " .. sql.SQLStr(job_id, true) .. " AND steam_id = " .. sql.SQLStr(steam_id) .. ";" )
  if exists then
    local created =  sql.Query( "DELETE FROM " .. sql.SQLStr(whitelist.config.table.whitelist) .. " WHERE job = " .. sql.SQLStr(job_id, true) .. " AND steam_id = " .. sql.SQLStr(steam_id) .. ";" )
    if created == false then
      whitelist.Message("Error deleting whitelist entry from whitelist table.")
      whitelist.Message(sql.LastError())
      if IsValid(adder) then
        whitelist.SendErrorMessage("Error deleting whitelist entry from whitelist table.", adder)
      end
    else
      whitelist.Message("User removed from whitelist table.")
      if IsValid(adder) then
        whitelist.SendMessage("User removed from whitelist table.", adder)
      end
    end
  else
    whitelist.Message("User does not exist. Can not remove.")
    if IsValid(adder) then
      whitelist.SendErrorMessage("User does not exist. Can not remove.", adder)
    end
  end
end

--Lookup if job is whitelisted
function whitelist.CheckJob(job_id)
  job_id = whitelist.GetTeam(job_id)
  local exists = sql.QueryRow( "SELECT * FROM " .. sql.SQLStr(whitelist.config.table.jobs) .. " WHERE job_id = " .. sql.SQLStr(job_id) .. ";" )
  if exists then
    ignore_force = exists.ignore_force or false
    return true, ignore_force
  else
    return false
  end
end
--Lookup if user is on the whitelist
function whitelist.CheckUser(steam_id, job_id)
  job_id = whitelist.GetTeam(job_id)
  local isWhitelisted, force = whitelist.CheckJob(job_id)
  if isWhitelisted then
    local exists = sql.QueryRow( "SELECT * FROM " .. sql.SQLStr(whitelist.config.table.whitelist) .. " WHERE job = " .. sql.SQLStr(job_id, true) .. " AND steam_id = " .. sql.SQLStr(steam_id) .. ";" )
    if exists then
      return true
    else
      return false
    end
  else
    return
  end
end
