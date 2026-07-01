

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Peak Client | Universal',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Movement'),
    ['UI Settings'] = Window:AddTab('Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Character Layout')

-- Movement Features
LeftGroupBox:AddSlider('WalkSpeedSlider', {
    Text = 'WalkSpeed',
    Default = 16,
    Min = 16,
    Max = 250,
    Rounding = 1,
    Compact = false,
})

LeftGroupBox:AddSlider('JumpPowerSlider', {
    Text = 'JumpPower',
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Compact = false,
})

-- Logic for updating character attributes
task.spawn(function()
    while task.wait(0.1) do
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            -- Only update if the slider value differs from default to prevent fight-back from some games
            if Options.WalkSpeedSlider.Value > 16 then
                character.Humanoid.WalkSpeed = Options.WalkSpeedSlider.Value
            end
            if Options.JumpPowerSlider.Value > 50 then
                character.Humanoid.JumpPower = Options.JumpPowerSlider.Value
            end
        end
    end
end)

local SettingsGroupBox = Tabs['UI Settings']:AddLeftGroupbox('Menu')

SettingsGroupBox:AddButton('Unload', function() Library:Unload() end)
SettingsGroupBox:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

-- Theme and Save Management initialization
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('PeakClient')
SaveManager:SetFolder('PeakClient/Universal')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()
