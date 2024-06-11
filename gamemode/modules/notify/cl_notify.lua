BaseWars:CreateFont("BaseWars.Notifications", 26, 500)

local NotificationsData = {
	[NOTIFICATION_GENERIC] = {
		name = "Generic",
		icon = Material("basewars_materials/notification/generic.png", "smooth"),
		colorText = Color(54, 61, 78),
		colorIcon = Color(42, 45, 55)
	},

	[NOTIFICATION_ERROR] = {
		name = "Error",
		icon = Material("basewars_materials/notification/error.png", "smooth"),
		colorText = Color(136, 35, 35),
		colorIcon = Color(100, 35, 35)
	},

	[NOTIFICATION_UNDO] = {
		name = "Undo",
		icon = Material("basewars_materials/notification/hint.png", "smooth"),
		colorText = Color(54, 61, 78),
		colorIcon = Color(42, 45, 55)
	},

	[NOTIFICATION_HINT] = {
		name = "Hint",
		icon = Material("basewars_materials/notification/undo.png", "smooth"),
		colorText = Color(54, 61, 78),
		colorIcon = Color(42, 45, 55)
	},

	[NOTIFICATION_CLEANUP] = {
		name = "CleanUp",
		icon = Material("basewars_materials/notification/cleanup.png", "smooth"),
		colorText = Color(54, 61, 78),
		colorIcon = Color(42, 45, 55)
	},

	[NOTIFICATION_WARNING] = {
		name = "Warning",
		icon = Material("basewars_materials/notification/warning.png", "smooth"),
		colorText = Color(136, 35, 35),
		colorIcon = Color(100, 35, 35)
	},

	[NOTIFICATION_PURCHASE] = {
		name = "Purchase",
		icon = Material("basewars_materials/notification/purchase.png", "smooth"),
		colorText = Color(179, 42, 83),
		colorIcon = Color(133, 30, 61)
	},

	[NOTIFICATION_RAID] = {
		name = "Raid",
		icon = Material("basewars_materials/notification/raid.png", "smooth"),
		colorText = Color(2212, 97, 9),
		colorIcon = Color(173, 79, 7)
	},

	[NOTIFICATION_SELL] = {
		name = "Sell",
		icon = Material("basewars_materials/notification/sell.png", "smooth"),
		colorText = Color(46, 184, 46),
		colorIcon = Color(50, 135, 50)
	},

	[NOTIFICATION_PRESTIGE] = {
		name = "Prestige",
		icon = Material("basewars_materials/notification/prestige.png", "smooth"),
		colorText = Color(54, 61, 78),
		colorIcon = Color(42, 45, 55)
	},

	[NOTIFICATION_DEATHNOTICE] = {
		name = "Death Notice",
		icon = Material("basewars_materials/notification/death_notice.png", "smooth"),
		colorText = Color(114, 42, 165),
		colorIcon = Color(88, 36, 126)
	},
	[NOTIFICATION_FACTION] = {
		name = "Faction",
		icon = Material("basewars_materials/notification/faction.png", "smooth"),
		colorText = Color(41, 151, 178),
		colorIcon = Color(33, 110, 145)
	},
	[NOTIFICATION_ADMIN] = {
		name = "Admin",
		icon = Material("basewars_materials/notification/admin.png", "smooth"),
		colorText = Color(132, 178, 41),
		colorIcon = Color(100, 145, 33)
	},
}

local notifications = {}
local notificationsHistory = {}
local ScreenPos = 10

local function DrawNotification(x, y, w, h, text, icon, textColor, iconColor)
	BaseWars:DrawRoundedBox(4, x, y, w + 25, h, textColor)
	BaseWars:DrawRoundedBoxEx(4, x, y, h, h, iconColor, true, false, true, false)
	BaseWars:DrawMaterial(icon, x + 12.5, y + 12.5, 25, 25, color_white)

	draw.SimpleText(text, "BaseWars.Notifications", x + w + 12.5, y + h / 2, color_white, TEXT_ALIGN_RIGHT, 1)
end

function BaseWars:GetNotificationsHistory()
	return notificationsHistory
end

function BaseWars:Notify(text, type, time, ...)
	text = tostring(text)
	type = type or 0

	if text[1] == "#" then
		text = Format(LocalPlayer():GetLang(string.sub(text, 2)), ...)
	end

	if #notificationsHistory >= 300 then
		notificationsHistory[#notificationsHistory] = nil
	end

	table.insert(notificationsHistory, 1, {
		text = text,
		col1 = NotificationsData[type].colorText,
		col2 = NotificationsData[type].colorIcon,
		icon = NotificationsData[type].icon
	})

	local w = BaseWars:GetTextSize(text, "BaseWars.Notifications") + 50
	local h = 50
	local x = ScrW()
	local y = ScreenPos

	table.insert(notifications, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		col1 = NotificationsData[type].colorText,
		col2 = NotificationsData[type].colorIcon,
		icon = NotificationsData[type].icon,
		time = CurTime() + (time or 5),
	})

	MsgC(NotificationsData[type].colorText, text, "\n")

	surface.PlaySound("bw_notification.wav")
end

local chatNotificationColor = Color(150, 150, 150)
function BaseWars:ChatNotify(text, args)
	text = tostring(text)

	if text[1] == "#" then
		text = Format(LocalPlayer():GetLang(string.sub(text, 2)), unpack(args))
	end

	chat.AddText(color_white, ":basewars0::basewars1::basewars2::basewars3::basewars4::basewars5:", chatNotificationColor, " » ", color_white, text)
end

function notification.Kill() end
function notification.AddProgress() end
function notification.AddLegacy(text, type, lenght)
	BaseWars:Notify(text, type, lenght)
end

function DrawBaseWarsNotifications()
	for k, v in ipairs(notifications) do
		DrawNotification(math.floor(v.x), math.floor(v.y), v.w, v.h, v.text, v.icon, v.col1, v.col2)

		local lerpFrac = FrameTime() * 20

		v.x = Lerp(lerpFrac, v.x, v.time > CurTime() and ScrW() - v.w - 35 or ScrW() + 10)
		v.y = Lerp(lerpFrac, v.y, ScreenPos + (k - 1) * (v.h + 5))
	end

	for k, v in ipairs(notifications) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove(notifications, k)
		end
	end
end

net.Receive("BaseWars:Notifications", function(len)
	local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

	local text = data.text
	if text[1] == "#" then
		text = Format(LocalPlayer():GetLang(string.sub(text, 2)), unpack(data.args))
	end

	BaseWars:Notify(text, data.type, data.lenght)
end)

net.Receive("BaseWars:Notifications:Chat", function(len)
	local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

	BaseWars:ChatNotify(data.text, data.args)
end)

concommand.Add("bw_testnotif", function(ply)
	if not BaseWars:IsSuperAdmin(ply) then return end

	for k, v in ipairs(NotificationsData) do
		timer.Simple(k * .25, function()
			BaseWars:Notify(v.name, k, 10)
		end)
	end
end)

net.Receive("BaseWars:Notif:ClearNotifs", function()
	notifications = {}
	BaseWars:Notify("#command_clearNotifs", NOTIFICATION_GENERIC, 5)
end)