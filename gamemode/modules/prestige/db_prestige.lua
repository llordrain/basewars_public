hook.Add("BaseWars:InitializeDatabase", "BaseWars:Prestige", function()
    MySQLite.tableExists("basewars_prestige", function(bool)
        if bool then return end

        MySQLite.query([[
            CREATE TABLE basewars_prestige(
                profile_id INTEGER PRIMARY KEY,
                player_id64 VARCHAR(17) NOT NULL,
                prestige INTEGER UNSIGNED NOT NULL,
                perks TEXT NOT NULL,
                point INTEGER UNSIGNED NOT NULL
            )]], function()
                BaseWars:SQLLogs("Created table basewars_prestige")
            end, BaseWarsSQLError)

        MySQLite.query("CREATE INDEX basewars_prestige_id64_index ON basewars_prestige(player_id64)", function()
            BaseWars:SQLLogs("Created index \"basewars_prestige_id64_index\" for table \"basewars_prestige\"")
        end, BaseWarsSQLError)
    end, BaseWarsSQLError)
end)