loadstring(game:HttpGet "https://raw.githubusercontent.com/coltonwach/Scripts/main/UILib.lua")()
local window, windowinst = library:AddWindow("ColRealPro's Teleport Tool", {
	main_color = Color3.fromRGB(11, 179, 221),
	min_size = Vector2.new(400, 365),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
})
local TPTool = window:AddTab "TPTool"
TPTool:AddLabel("Instructions: Press start to start the teleport tool\nThen press \"Add Position\"\nGo to the next position and do the same\nWhen finished, Press end.\nIt will copy the code to your clipboard")
local StartButton
function Vector3ToString(vector)
	return "Vector3.new(".. math.floor(vector.x*100)/100 ..",".. math.floor(vector.y*100)/100 ..",".. math.floor(vector.z*100)/100 ..")"
end
StartButton = TPTool:AddButton("Start", function()
	StartButton:Destroy()
	local Positions = {}
	local debounce = false
	local CurrentPositionText = TPTool:AddLabel("Current Index: 0")
	local TweenService = game:GetService("TweenService")
	local AddPosButton
	local parts = {}
	local function update()
		print(pcall(function()
			for i,v in pairs(parts) do
				v:Destroy()
			end
			table.clear(parts)
	
			for i,v in pairs(Positions) do
				local point = Instance.new("Part")
				point.Anchored = true
				point.CanCollide = false
				point.Color = Color3.fromRGB(11, 179, 221)
				point.Material = Enum.Material.Neon
				point.Position = v
				point.Shape = Enum.PartType.Ball
				point.Size = Vector3.new(0.4, 0.4, 0.4)
				local attachment = Instance.new("Attachment", point)
				attachment.Name = "Attachment"
				local beam = Instance.new("Beam")
				beam.Brightness = 5
				beam.Name = "Beam"
				beam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 51, 63)), ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 51, 63)) })
				beam.FaceCamera = true
				beam.Width0, beam.Width1 = 0.1, 0.1
				beam.Attachment0 = attachment
				beam.Parent = point
				point.Parent = workspace
				table.insert(parts, point)
			end
	
			for i,v in pairs(parts) do
				if parts[i+1] then
					v.Beam.Attachment1 = parts[i+1].Attachment
				end
			end
		end))
	end
	AddPosButton = TPTool:AddButton("Add Position", function()
		if debounce then return end
		table.insert(Positions, game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
		CurrentPositionText.Text = "Current Index: ".. #Positions
		debounce = true
		AddPosButton.Text = "Added!"
		update()
		task.wait(1)
		debounce = false
		AddPosButton.Text = "Add Position"
	end)
	TPTool:AddButton("Preview", function()
		local istping = true
		task.spawn(function()
			repeat
				game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new()
				task.wait()
			until not istping
		end)
		for i,v in pairs(Positions) do
			local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v).Magnitude/100, Enum.EasingStyle.Linear), {CFrame = CFrame.new(v)})
			Tween:Play()
			Tween.Completed:Wait()
		end
		istping = false
	end)
	TPTool:AddButton("Preview Reverse", function()
		local istping = true
		task.spawn(function()
			repeat
				game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new()
				task.wait()
			until not istping
		end)
		for i = #Positions, 0, -1 do
			if i == 0 then
				break
			end
			local v = Positions[i]
			local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v).Magnitude/100, Enum.EasingStyle.Linear), {CFrame = CFrame.new(v)})
			Tween:Play()
			Tween.Completed:Wait()
		end
		istping = false
	end)
	TPTool:AddButton("Clear Positions", function()
		table.clear(Positions)
		CurrentPositionText.Text = "Current Index: 0"
		update()
	end)
	TPTool:AddButton("Remove Most Recent Position", function()
		table.remove(Positions, #Positions)
		CurrentPositionText.Text = "Current Index: "..#Positions
		update()
	end)
	TPTool:AddButton("End", function()
		local code = "local Positions = {"
		for i,v in pairs(Positions) do
			code = code.."["..i.."] = "..Vector3ToString(v)..","
		end
		code = code.."}\n\n"..[[local TweenService = game:GetService("TweenService")
			
local istping = true
task.spawn(function()
	repeat
		game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new()
		task.wait()
	until not istping
end)
for i,v in pairs(Positions) do
	local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v).Magnitude/100, Enum.EasingStyle.Linear), {CFrame = CFrame.new(v)})
	Tween:Play()
	Tween.Completed:Wait()
end
istping = false]]
		setclipboard(code)
		windowinst:Destroy()
		table.clear(Positions)
		update()
	end)
end)