local Parent = script.Parent
local Remote = Parent:WaitForChild('RemoteEvent')
Remote.OnServerEvent:Connect(function(Player, arg, Table, Damage)
	if arg == "Parry" then
		local Parry = Instance.new('NumberValue')
		Parry.Name = "Parry"
		Parry.Parent = Player.Character
		game.Debris:AddItem(Parry, 0.25)
	elseif arg == "DoDamage" then --// Damage/ Hitbox
		pcall(function()
			for i,v in pairs(Table) do
				if not v:FindFirstChild('Parry') then
					v.Humanoid:TakeDamage(Damage)
				else
					--// Do Parry Stuff
					print('Parried')
					local load = Player.Character.Humanoid:Loadanimation(script.Parent.Parry)
					load:Play()
					return
				end
			end
		end)
	end
end)
