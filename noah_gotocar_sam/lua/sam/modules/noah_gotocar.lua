if not sam then return end

local sam, command = sam, sam.command

command.set_category("Teleport")

command.new("gotocar")
    :SetPermission("[G4L] gotocar", "superadmin")
	:AddArg("player", {single_target = true, allow_higher_target = true, cant_target_self = true})
    :Help("Teleport to a player's car.")

    :OnExecute(function(ply, target)
        if istable(target) then
            target = target[1]
        end

        if not IsValid(target) or not target:IsPlayer() then
            sam.player.send_message(ply, "⚠️ Invalid player.")
            return
        end

        local foundCar = nil
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetClass() == "prop_vehicle_jeep" and ent:isKeysOwnedBy(target) then
                foundCar = ent
                break
            end
        end

        if not foundCar then
            sam.player.send_message(ply, "⚠️ " .. target:Nick() .. " does not own a car.")
            return
        end

        if ply:InVehicle() then ply:ExitVehicle() end

        ply:SetPos(foundCar:GetPos() + Vector(0, 0, 72)) 

        sam.player.send_message(nil, ply:Nick() .. " teleported to " .. target:Nick() .. "'s car.")
    end)
:End()
