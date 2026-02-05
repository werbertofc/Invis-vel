--[[
    WERBERT GOD V3 - O FANTASMA (ANTI-HIT)
    Criado por: @werbert_ofc
    
    TÉCNICA AVANÇADA:
    1. Deleta 'TouchInterest' do corpo (O jogo não sente que você tocou em lava/armas).
    2. Reduz a Hitbox para tamanho 0.1 (Difícil de acertar tiro).
    3. Trava a vida em 100% (Caso algo passe pelo bloqueio).
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Limpeza
if getgenv().GhostLoop then getgenv().GhostLoop:Disconnect() end
if getgenv().WerbertUI then getgenv().WerbertUI:Destroy() end

local isGhostActive = false

-- ==============================================================================
-- INTERFACE (COM MINIMIZAR)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertGodV3"
if pcall(function() ScreenGui.Parent = CoreGui end) then
    getgenv().WerbertUI = ScreenGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    getgenv().WerbertUI = ScreenGui
end

-- Draggable Function
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 180)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(85, 0, 255) -- Roxo Fantasma
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "GOD V3 (FANTASMA)"
Title.TextColor3 = Color3.fromRGB(170, 100, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = MainFrame

-- Botões de Janela
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -70, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 20
MiniBtn.Parent = MainFrame
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

-- Botão Ativar
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 60)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleBtn.Text = "ATIVAR MODO FANTASMA"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Ícone Flutuante
local FloatIcon = Instance.new("TextButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatIcon.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
FloatIcon.Text = "👻"
FloatIcon.TextSize = 24
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)

makeDraggable(MainFrame)
makeDraggable(FloatIcon)

-- ==============================================================================
-- LÓGICA DO MODO FANTASMA (ANTI-HIT)
-- ==============================================================================

local function activateGhost()
    isGhostActive = true
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
    ToggleBtn.Text = "FANTASMA: ON (INTOCÁVEL)"
    
    getgenv().GhostLoop = RunService.Stepped:Connect(function()
        if not isGhostActive then return end
        
        local char = LocalPlayer.Character
        if char then
            -- 1. DELETAR SENSORES DE TOQUE (O SEGREDO)
            -- Isso impede que scripts de "Touched" (Lava, Espadas) funcionem em você
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    local touch = part:FindFirstChild("TouchInterest")
                    if touch then
                        touch:Destroy() -- O servidor perde a capacidade de saber que você tocou algo
                    end
                    
                    -- 2. NOCLIP (Evita colisão física com balas)
                    part.CanCollide = false
                end
            end
            
            -- 3. HITBOX MINIMALISTA
            -- Reduz a RootPart para quase zero. Balas vão passar direto.
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(0.1, 0.1, 0.1)
                hrp.Transparency = 0.5 -- Visual para você saber que está ativo
                hrp.Color = Color3.fromRGB(255, 0, 0)
            end
            
            -- 4. TRAVA DE VIDA (Backup)
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
                hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) -- Estado especial
            end
        end
    end)
end

local function deactivateGhost()
    isGhostActive = false
    if getgenv().GhostLoop then getgenv().GhostLoop:Disconnect() end
    
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ToggleBtn.Text = "ATIVAR MODO FANTASMA"
    
    -- Tenta restaurar (Requer respawn para restaurar TouchInterest 100%)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Size = Vector3.new(2, 2, 1) -- Tamanho padrão
        char.HumanoidRootPart.Transparency = 1
    end
end

-- ==============================================================================
-- BOTÕES
-- ==============================================================================

ToggleBtn.MouseButton1Click:Connect(function()
    if isGhostActive then
        deactivateGhost()
    else
        activateGhost()
    end
end)

MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatIcon.Visible = true
end)

FloatIcon.MouseButton1Click:Connect(function()
    FloatIcon.Visible = false
    MainFrame.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    deactivateGhost()
    ScreenGui:Destroy()
end)

-- Auto-Reativar no Respawn
LocalPlayer.CharacterAdded:Connect(function()
    if isGhostActive then
        task.wait(1)
        activateGhost()
    end
end)

game.StarterGui:SetCore("SendNotification", {Title="Werbert God V3", Text="Anti-Hit Carregado!", Duration=5})
