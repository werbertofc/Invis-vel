--[[
    WERBERT GOD HUB V2 - BRUTE FORCE (IMORTALIDADE AGRESSIVA)
    Criado por: @werbert_ofc
    
    Estratégia:
    1. Health Spam: Cura mais rápido que o dano (RenderStepped).
    2. State Protection: Desativa o estado de 'Morto' no Humanoid.
    3. ForceField: Cria proteção nativa se o jogo permitir.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Limpeza
if getgenv().GodLoop then getgenv().GodLoop:Disconnect() end
if getgenv().WerbertGodUI then getgenv().WerbertGodUI:Destroy() end

-- ==============================================================================
-- UI MODERNA
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertGodUI_V2"
if pcall(function() ScreenGui.Parent = CoreGui end) then
    getgenv().WerbertGodUI = ScreenGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    getgenv().WerbertGodUI = ScreenGui
end

-- Janela Principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0.5, -125, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2
Stroke.Parent = Frame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "GOD MODE V2 (BRUTO)"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.Parent = Frame

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0.8, 0)
Status.BackgroundTransparency = 1
Status.Text = "Status: Vulnerável"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Parent = Frame

-- Botão Ativar
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.Text = "ATIVAR IMORTALIDADE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Frame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Arrastar
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- ==============================================================================
-- LÓGICA DE IMORTALIDADE (BRUTE FORCE)
-- ==============================================================================

local isActive = false

local function activateGodMode()
    isActive = true
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    ToggleBtn.Text = "IMORTALIDADE: ON"
    Status.Text = "Status: Protegido (Health Lock)"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)

    -- Loop Agressivo (RenderStepped = Antes de desenhar a tela)
    getgenv().GodLoop = RunService.RenderStepped:Connect(function()
        if not isActive then return end
        
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                -- 1. HEAL SPAM: Se a vida baixar de 100%, enche na hora
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
                
                -- 2. ANTI-DEATH STATE: Impede o jogo de te marcar como morto
                if hum:GetState() == Enum.HumanoidStateType.Dead then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                
                -- 3. FORCEFIELD: Cria um escudo se não tiver
                if not char:FindFirstChild("WerbertFF") then
                    local ff = Instance.new("ForceField")
                    ff.Name = "WerbertFF"
                    ff.Visible = false -- Invisível para não atrapalhar a visão
                    ff.Parent = char
                end
            end
        end
    end)
end

local function deactivateGodMode()
    isActive = false
    if getgenv().GodLoop then getgenv().GodLoop:Disconnect() end
    
    -- Remove o escudo
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("WerbertFF") then
        char.WerbertFF:Destroy()
    end
    
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.Text = "ATIVAR IMORTALIDADE"
    Status.Text = "Status: Vulnerável"
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
end

-- Botões
ToggleBtn.MouseButton1Click:Connect(function()
    if isActive then
        deactivateGodMode()
    else
        activateGodMode()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    deactivateGodMode()
    ScreenGui:Destroy()
end)

-- Reativar ao morrer (caso o dano seja Hitkill instantâneo e passe pelo filtro)
LocalPlayer.CharacterAdded:Connect(function()
    if isActive then
        task.wait(1) -- Espera carregar
        activateGodMode() -- Liga de novo
    end
end)

game.StarterGui:SetCore("SendNotification", {Title="Werbert God V2", Text="Modo Bruto Carregado!", Duration=5})
