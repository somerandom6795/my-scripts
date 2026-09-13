local lp = game:GetService("Players").LocalPlayer
local fly_enabled = false 
character = lp.Character
lp.CharacterAdded:Connect(function()
	task.wait(0.7)
	character = lp.Character
	local attachment = Instance.new("Attachment")
	attachment.Name = "Attachment"
	attachment.Parent = character.HumanoidRootPart
end)
local attachment = Instance.new("Attachment")
attachment.Name = "Attachment"
attachment.Parent = character.HumanoidRootPart
local function puhs(velocity: Vector3)
	local LV = Instance.new("LinearVelocity")
	LV.Name = "velocity"
	LV.Parent = character
	LV.ForceLimitsEnabled = false
	LV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	LV.Attachment0 = character.HumanoidRootPart.Attachment
	LV.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
	LV.VectorVelocity = velocity
	task.wait(0.1)
	LV:Destroy()
end
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
	if not gpe then
		if input.KeyCode == Enum.KeyCode.X then
			puhs(Vector3.new(0, 0, -100))
		elseif input.KeyCode == Enum.KeyCode.V and fly_enabled == true then
			puhs(Vector3.new(0, 50, 0))
		end
	end
end)