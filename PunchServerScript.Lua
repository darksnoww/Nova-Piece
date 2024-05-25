-- Script location in ServerScriptService
-- This script work with the CombatClientScript

local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local PunchDebounces = {}
local punchDistance = 4
local punchDebounceDuration = 1.2

local function hit(character, damage)
	character.Humanoid:TakeDamage(damage)

	local vF = Instance.new("VectorForce")
	vF.Attachment0 = character.HumanoidRootPart.RootAttachment
	vF.Force = Vector3.new(0, 0, 40000)
	vF.Parent = character.PrimaryPart

	local particle = script.PunchParticle:Clone()
	particle.Parent = character.PrimaryPart
	particle:Emit(30)
	
	local punchSound = script.PunchSound:Clone()
	punchSound.Parent = character.PrimaryPart
	punchSound:Play()

	task.wait(0.03)

	if vF.Parent ~= nil then
		vF:Destroy()
	end

	task.wait(1)

	if particle.Parent ~= nil then
		particle:Destroy()
		punchSound:Destroy()
	end
end

local function punch(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local punchDamage = 30

	if character == nil then return end
	if not character:FindFirstChild("Humanoid") then return end
	if character.Humanoid.Health == 0 then return end
	if PunchDebounces[player] then return end

	PunchDebounces[player] = true

	local punchAnimation = character.Humanoid.Animator:LoadAnimation(script.Punch)
	punchAnimation:Play()

	punchAnimation.KeyframeReached:Connect(function(keyframeName)
		if keyframeName ~= "Damage" then
			return
		end

		for _, plr in players:GetPlayers() do
			local char = plr.Character

			if char == nil or plr == player then continue end

			if (char.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude <= punchDistance then
				coroutine.wrap(hit)(char, punchDamage)
				break
			end
		end

		for _, dummy in workspace.Dummies:GetChildren() do
			if (dummy.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude <= punchDistance then
				coroutine.wrap(hit)(dummy, punchDamage)
				break
			end
		end

	end)

	task.Spawn(function()
		task.wait(punchDebounceDuration)
		if PunchDebounces[player] then
			PunchDebounces[player] = nil
		end
	end)
end

replicatedStorage.Punch.OnServerEvent:Connect(punch)
