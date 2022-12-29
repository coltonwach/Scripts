local Players = game:GetService "Players"
	local BadInstances = {
		"DataModelMesh",
		"FaceInstance",
		"ParticleEmitter",
		"Trail",
		"Smoke",
		"Fire",
		"Sparkles",
		"PostEffect",
		"Explosion",
		"Clothing",
		"BasePart",
	}
	local CanBeEnabled = { "ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles", "PostEffect" }
	local function PartOfCharacter(Instance)
		for i, v in pairs(Players:GetPlayers()) do
			if v.Character and Instance:IsDescendantOf(v.Character) then
				return true
			end
		end
		return false
	end
	if _G.Settings["Low Water Graphics"] or (_G.Settings.Other and _G.Settings.Other["Low Water Graphics"]) then
		workspace:FindFirstChildOfClass("Terrain").WaterWaveSize = 0
		workspace:FindFirstChildOfClass("Terrain").WaterWaveSpeed = 0
		workspace:FindFirstChildOfClass("Terrain").WaterReflectance = 0
		workspace:FindFirstChildOfClass("Terrain").WaterTransparency = 0
	end
	if _G.Settings["No Shadows"] or (_G.Settings.Other and _G.Settings.Other["No Shadows"]) then
		game:GetService("Lighting").GlobalShadows = false
		game:GetService("Lighting").FogEnd = 9e9
	end
	if _G.Settings["Low Rendering"] or (_G.Settings.Other and _G.Settings.Other["Low Rendering"]) then
		settings().Rendering.QualityLevel = 1
	end
	sethiddenproperty(workspace.Terrain, "Decoration", false)
