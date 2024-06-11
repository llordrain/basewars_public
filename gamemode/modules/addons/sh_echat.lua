local LAST_UPDATED_VERSION = 1.43 -- May 31th 2024 // https://www.gmodstore.com/market/view/echat-feature-rich-chatbox/versions
local GRAY_COLOR = Color(200, 200, 200)

local function makeModifications()
    if not echat then return end
    if echat.addon.info.version != LAST_UPDATED_VERSION then
        ErrorNoHalt("addons/sh_echat.lua needs to be updated!")

        return
    end

    local prefixRank = {
        user = "<clr:white>:user0::user1::user2::user3: ",
        vip = "<clr:white>:vip0::vip1::vip2::vip3: ",
        moderator_test = "<clr:white>:moderator_test0::moderator_test1::moderator_test2::moderator_test3::moderator_test4::moderator_test5::moderator_test6::moderator_test7::moderator_test8: ",
        moderator = "<clr:white>:moderator0::moderator1::moderator2::moderator3::moderator4::moderator5::moderator6: ",
        admin = "<clr:white>:admin0::admin1::admin2::admin3::admin4::admin5::admin6::admin7: ",
        superadmin = "<clr:white>:superadmin0::superadmin1::superadmin2::superadmin3::superadmin4::superadmin5::superadmin6: ",
    }

    local prefixBaseWars = {
        basewars = "<clr:white>:basewars0::basewars1::basewars2::basewars3::basewars4::basewars5: ",
        adminchat = "<clr:white>:admin_chat0::admin_chat1::admin_chat2::admin_chat3::admin_chat4::admin_chat5::admin_chat6: ",
        advert = "<clr:white>:advert0::advert1::advert2::advert3::advert4: ",
    }

    local prefixPerso = {
        ["76561198345453711"] = "<clr:white>:76561198345453711_0::76561198345453711_1::76561198345453711_2::76561198345453711_3::76561198345453711_4::76561198345453711_5::76561198345453711_6::76561198345453711_7: ",
    }

    local names = {
        ["76561198345453711"] = "llordrain",
    }

    echat.config.autocompleters["DarkRP_Commands"] = false
    echat.config.autocompleters["BaseWars_Commands"] = true
    echat.config.pm_command["enable"] = false
    echat.config.ooc_command["enable"] = false
    echat.config.advert_command["enable"] = false
    echat.config.rank_formats = {
        ["76561198345453711"] = prefixPerso["76561198345453711"] .. "{job_color}{nick}", -- llordrain | The prefix says "GAMEMODE DEV" so keep it if you want i really don't care

        ["superadmin"] = prefixRank["superadmin"] .. "{job_color}{nick}",
        ["admin"] = prefixRank["admin"] .. "{job_color}{nick}",
        ["Moderator"] = prefixRank["moderator"] .. "{job_color}{nick}",
        ["Moderator-Test"] = prefixRank["moderator_test"] .. "{job_color}{nick}",
        ["VIP"] = prefixRank["vip"] .. "{job_color}{nick}",

        ["__default__"] = prefixRank["user"] .. "{job_color}{nick}",
    }

    if CLIENT then
        -- Add auto completes with args for all BaseWars commands
        echat:AddAutoComplete("BaseWars_Commands",function(text, word)
            local commandPrefix = BaseWars.Config.ChatCommandPrefix

            if not text or string.Left(text, #commandPrefix) != commandPrefix then
                return
            end

            local ply = LocalPlayer()
            local suggestions = {}
            for k,v in pairs(BaseWars:GetChatCommands()) do
                if v.rank and not (v.rank[ply:GetUserGroup()] or BaseWars:IsSuperAdmin(ply)) then continue end

                local command_text = string.Trim(commandPrefix .. k)
                if (string.find(command_text, text, 1, true) != nil) then
                    table.insert(suggestions, {
                        type = "command",
                        offset = 0,
                        text = command_text,
                        description = v.desc[1] == "#" and ply:GetLang(string.sub(v.desc, 2)) or v.desc,
                        args = v.args
                    })
                end
            end

            return suggestions
        end)

        concommand.Add("bw_show_chatprefix", function(ply, cmd, args, argStr)
            if not BaseWars:IsSuperAdmin(LocalPlayer()) then return end

            chat.AddText(color_white, "Tout les prefix »<separator>")
            chat.AddText(prefixRank["user"])
            chat.AddText(prefixRank["vip"])
            chat.AddText(prefixRank["moderator_test"])
            chat.AddText(prefixRank["moderator"])
            chat.AddText(prefixRank["admin"])
            chat.AddText(prefixRank["superadmin"], "<separator>")

            chat.AddText(prefixBaseWars["basewars"])
            chat.AddText(prefixBaseWars["adminchat"])
            chat.AddText(prefixBaseWars["advert"], "<separator>")

            local count, totalCount = 0, table.Count(prefixPerso)
            for k, v in SortedPairs(prefixPerso) do
                count = count + 1

                chat.AddText(v, GRAY_COLOR, names[k], color_white, count >= totalCount and "<separator>" or "")
            end
        end)
    end
end

hook.Add(CLIENT and "InitPostEntity" or "PlayerInitialSpawn", "BaseWars:Addons:EChat", function()
    makeModifications()

    hook.Remove(CLIENT and "InitPostEntity" or "PlayerInitialSpawn", "BaseWars:Addons:EChat")

    -- Lua Refresh
    hook.Add("BaseWars:Initialize", "BaseWars:Addons:EChat", function()
        makeModifications()
    end)
end)