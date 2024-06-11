--[[-------------------------------------------------------------------------
	HUD NOTIFICATIONS
---------------------------------------------------------------------------]]
util.AddNetworkString("BaseWars:Notifications")

local function sendNotif(ply, text, type, lenght, ...)
	text = tostring(text or "")

	if text == "" then
		text = "none"
	end

	local data = util.Compress(util.TableToJSON({
		text = text,
		type = type or 0,
		lenght = lenght or 5,
		args = {...}
	}))

	net.Start("BaseWars:Notifications")
		net.WriteData(data, #data)
	net[IsValid(ply) and "Send" or "Broadcast"](ply)
end

function BaseWars:Notify(ply, text, type, lenght, ...)
	if IsValid(ply) and ply:IsPlayer() then
		sendNotif(ply, text, type, lenght, ...)

		return
	end

	text = tostring(text)
	if text[1] == "#" then
		text = Format(BaseWars:GetLang(string.sub(text, 2)), ...)
	end

	BaseWars[(type == NOTIFICATION_ERROR or type == NOTIFICATION_WARNING) and "Warning" or "Log"](BaseWars, text)
end

function BaseWars:NotifyAll(text, type, lenght, ...)
	sendNotif(nil, text, type, lenght, ...)
end

--[[-------------------------------------------------------------------------
	CHAT NOTIFICATIONS
---------------------------------------------------------------------------]]
util.AddNetworkString("BaseWars:Notifications:Chat")

local function sendChatNotif(ply, text, ...)
	text = tostring(text or "")

	if text == "" then
		text = "none"
	end

	local data = util.Compress(util.TableToJSON({
		text = text,
		args = {...}
	}))

	net.Start("BaseWars:Notifications:Chat")
		net.WriteData(data, #data)
	net[IsValid(ply) and "Send" or "Broadcast"](ply)
end

function BaseWars:ChatNotify(ply, text, ...)
	if not (IsValid(ply) and ply:IsPlayer()) then return end

	sendChatNotif(ply, text, ...)
end

function BaseWars:ChatNotifyAll(text, ...)
	sendChatNotif(nil, text, ...)
end