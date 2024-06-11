if CPPI then
    return
else
    if SERVER then
        ErrorNoHalt("You need a CPPI compliant prop protection addon installed! I am not responsible for any problem you encounter without one (Here's two you can use:\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=159298542\nhttps://steamcommunity.com/sharedfiles/filedetails/?l=french&id=133537219)\n")
    end
end

local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")

CPPI = {}
CPPI.CPPI_DEFER = 100100
CPPI.CPPI_NOTIMPLEMENTED = 7080

function CPPI:GetName()
    return "BaseWars"
end

function CPPI:GetVersion()
    return self.CPPI_NOTIMPLEMENTED
end

function CPPI:GetInterfaceVersion()
    return self.CPPI_NOTIMPLEMENTED
end

function CPPI:GetNameFromUID(uid)
    return self.CPPI_NOTIMPLEMENTED
end

function PLAYER:CPPIGetFriends()
    return CPPI.CPPI_NOTIMPLEMENTED
end

function ENTITY:CPPIGetOwner()
    return NULL, CPPI.CPPI_NOTIMPLEMENTED
end

if SERVER then
    function ENTITY:CPPISetOwner(ply)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPISetOwnerUID(UID)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPICanTool(ply, tool)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPICanPhysgun(ply)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPICanPickup(ply)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPICanPunt(ply)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPICanUse(ply)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPICanDamage(ply)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPIDrive(ply)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPICanProperty(ply, property)
        return CPPI.CPPI_NOTIMPLEMENTED
    end

    function ENTITY:CPPICanEditVariable(ply, key, val, editTbl)
        return CPPI.CPPI_NOTIMPLEMENTED
    end
end