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
	AddPosButton = TPTool:AddButton("Add Position", function()
		if debounce then return end
		table.insert(Positions, game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
		CurrentPositionText.Text = "Current Index: ".. #Positions
		debounce = true
		AddPosButton.Text = "Added!"
		task.wait(1)
		debounce = false
		AddPosButton.Text = "Add Position"
	end)
	TPTool:AddButton("Preview", function()
		for i,v in pairs(Positions) do
			local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v).Magnitude/100, Enum.EasingStyle.Linear), {CFrame = CFrame.new(v)})
			Tween:Play()
			Tween.Completed:Wait()
		end
	end)
	TPTool:AddButton("Preview Reverse", function()
		for i = #Positions, 0, -1 do
			local v = Positions[i]
			local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v).Magnitude/100, Enum.EasingStyle.Linear), {CFrame = CFrame.new(v)})
			Tween:Play()
			Tween.Completed:Wait()
		end
	end)
	TPTool:AddButton("Clear Positions", function()
		table.clear(Positions)
		CurrentPositionText.Text = "Current Index: 0"
	end)
	TPTool:AddButton("Remove Most Recent Position", function()
		table.remove(Positions, #Positions)
		CurrentPositionText.Text = "Current Index: "..#Positions
	end)
	TPTool:AddButton("End", function()
		local code = "local Positions = {"
		for i,v in pairs(Positions) do
			code = code.."["..i.."] = "..Vector3ToString(v)..","
		end
		code = code.."}\n\n"..[[local TweenService = game:GetService("TweenService")
			
for i,v in pairs(Positions) do
	local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v).Magnitude/100, Enum.EasingStyle.Linear), {CFrame = CFrame.new(v)})
	Tween:Play()
	Tween.Completed:Wait()
end]]
		setclipboard(code)
		windowinst:Destroy()
	end)
end)