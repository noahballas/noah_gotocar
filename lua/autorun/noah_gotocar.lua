if not sam then return end

local sam, command = sam, sam.command

command.set_category("Teleport")

local gotocar_cmd = command.new("gotocar")
    :DisallowConsole()
    :SetPermission("gotocar", "admin")
    :AddArg("player", {single_target = true, allow_higher_target = true, cant_target_self = false})
    :Help("Teleporte vers le vehicule d'un joueur.")
    :OnExecute(function(ply, target)
        if istable(target) then target = target[1] end

        if not IsValid(target) or not target:IsPlayer() then
            sam.player.send_message(ply, "Joueur invalide.")
            return
        end

        local foundCar = target:GetVehicle()
        
        if not IsValid(foundCar) then
            for _, ent in ipairs(ents.GetAll()) do
                if (ent:GetClass() == "prop_vehicle_jeep" or ent:IsVehicle()) then
                    if (ent.CPPIGetOwner and ent:CPPIGetOwner() == target) or (ent.isKeysOwnedBy and ent:isKeysOwnedBy(target)) then
                        foundCar = ent
                        break
                    end
                end
            end
        end

        if not IsValid(foundCar) then
            sam.player.send_message(ply, target:Nick() .. " ne possede pas de vehicule.")
            return
        end

        if ply:InVehicle() then ply:ExitVehicle() end

        ply:SetPos(foundCar:GetPos() + Vector(0, 0, 80))
        sam.player.send_message(nil, ply:Nick() .. " s'est teleporte sur le vehicule de " .. target:Nick() .. ".")
    end)

-- Cette ligne force SAM a reconnaitre la commande dans le chat
gotocar_cmd:End()
