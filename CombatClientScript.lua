-- Script location in StarterPlayer --> StarterPlayerScript
-- This script work with the PunchServerScript

local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
		game.ReplicatedStorage:WaitForChild("Punch"):FireServer()
	end
end)
