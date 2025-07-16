local uis = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

local espEnabled = false
local tpSpamming = false
local speedEnabled = false
local speed = 35 -- дефолтная скорость спидхака

-- ВХ
local function createBoxESP(part, color, name)
	local adorn = Instance.new("BoxHandleAdornment")
	adorn.Adornee = part
	adorn.AlwaysOnTop = true
	adorn.ZIndex = 10
	adorn.Size = part.Size + Vector3.new(0.2, 0.2, 0.2)
	adorn.Color3 = color
	adorn.Transparency = 0.4
	adorn.Name = "ESP_" .. name
	adorn.Parent = part
end

local function toggleESP()
	espEnabled = not espEnabled
	if espEnabled then
		for _, m in pairs(workspace.Players.Survivors:GetChildren()) do
			local hrp = m:FindFirstChild("HumanoidRootPart")
			if hrp and not hrp:FindFirstChild("ESP_Survivor") then
				createBoxESP(hrp, Color3.fromRGB(0,255,0), "Survivor")
			end
		end
		for _, m in pairs(workspace.Players.Killers:GetChildren()) do
			local hrp = m:FindFirstChild("HumanoidRootPart")
			if hrp and not hrp:FindFirstChild("ESP_Killer") then
				createBoxESP(hrp, Color3.fromRGB(255,0,0), "Killer")
			end
		end
		for _, o in ipairs(workspace:GetDescendants()) do
			if o:IsA("Model") and o.Name == "Generator" then
				local p = o:FindFirstChildWhichIsA("BasePart")
				if p and not p:FindFirstChild("ESP_Generator") then
					createBoxESP(p, Color3.fromRGB(0,170,255), "Generator")
				end
			end
		end
	else
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BoxHandleAdornment") and v.Name:match("^ESP_") then
				v:Destroy()
			end
		end
	end
end

-- TP спам
task.spawn(function()
	while task.wait(2) do
		if tpSpamming then
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				for _, m in ipairs(workspace.Players.Survivors:GetChildren()) do
					local h = m:FindFirstChild("Humanoid")
					local t = m:FindFirstChild("HumanoidRootPart")
					if h and h.Health > 0 and m ~= lp.Character and t then
						hrp.CFrame = t.CFrame + Vector3.new(0,3,0)
						break
					end
				end
			end
		end
	end
end)

-- SpeedHack
task.spawn(function()
	while task.wait(0.05) do
		if speedEnabled then
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Velocity = hrp.CFrame.LookVector * speed
			end
		end
	end
end)

-- Хоткеи
uis.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.X then
		toggleESP()
	elseif input.KeyCode == Enum.KeyCode.C then
		tpSpamming = not tpSpamming
	elseif input.KeyCode == Enum.KeyCode.B then
		speedEnabled = not speedEnabled
	elseif input.KeyCode == Enum.KeyCode.G then
		local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 25
		end
	end
end)
