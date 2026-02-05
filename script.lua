--[[
    WERBERT SHIELD V4 - ANTI-BALA & ANTI-TRAVA
    Criado por: @werbert_ofc
    
    TECNOLOGIA NOVA (V4):
    1. CanQuery = false: Faz os Raios (Balas) atravessarem seu corpo.
    2. CanTouch = false: Impede dano por toque (Lava/Espada).
    3. Proteção de Movimento: NÃO altera o tamanho da RootPart (Zero travamentos).
    4. Auto-Heal Rápido: Para danos que passem pelo filtro.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Limpeza
if getgenv().ShieldLoop then getgenv().ShieldLoop:Disconnect() end
if getgenv().WerbertUI then getgenv().WerbertUI:Destroy() end

local isShieldActive = false

-- ==============================================================================
-- INTERFACE (COM MINIMIZAR)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertShieldV4"
if pcall(function() ScreenGui.Parent = CoreGui end) then
    getgenv().WerbertUI = ScreenGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    getgenv().WerbertUI = ScreenGui
end

-- Função de Arrastar
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
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

-- Painel Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 180)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 150, 255) -- Azul Escudo
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "WERBERT SHIELD V4"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = MainFrame

-- Botões Janela
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -70, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
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
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
ToggleBtn.Text = "ATIVAR ESCUDO (NO CLIP)"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Status
local StatusTxt = Instance.new("TextLabel")
StatusTxt.Size = UDim2.new(1, 0, 0, 20)
StatusTxt.Position = UDim2.new(0, 0, 0.8, 0)
StatusTxt.BackgroundTransparency = 1
StatusTxt.Text = "Status: Normal"
StatusTxt.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusTxt.Font = Enum.Font.Gotham
StatusTxt.TextSize = 12
StatusTxt.Parent = MainFrame

-- Ícone Flutuante
local FloatIcon = Instance.new("TextButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatIcon.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
FloatIcon.Text = "🛡️"
FloatIcon.TextSize = 24
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)

makeDraggable(MainFrame)
makeDraggable(FloatIcon)

-- ==============================================================================
-- LÓGICA DO ESCUDO (CANQUERY + CANTOUCH)
-- ==============================================================================

local function activateShield()
    isShieldActive = true
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    ToggleBtn.Text = "ESCUDO ATIVO (GOD)"
    StatusTxt.Text = "Balas e Toques Desativados"
    StatusTxt.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    getgenv().ShieldLoop = RunService.Stepped:Connect(function()
        if not isShieldActive then return end
        
        local char = LocalPlayer.Character
        if char then
            -- Para cada parte do corpo (Cabeça, Braço, Tronco...)
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    -- 1. DESATIVA COLISÃO DE BALAS (O Segredo)
                    -- Se CanQuery for false, Raycasts (tiros) ignoram essa parte.
                    -- O tiro passa direto como se fosse fantasma.
                    part.CanQuery = false 
                    
                    -- 2. DESATIVA TOQUE (Lava/Espada)
                    part.CanTouch = false
                    
                    -- 3. MANTÉM MOVIMENTO (Correção do bug de travar)
                    -- Não alteramos Size, nem destruímos RootPart.
                    -- Apenas desligamos colisões físicas com objetos (NoClip)
                    part.CanCollide = false 
                end
            end
            
            -- 4. CURA DE EMERGÊNCIA (Caso algo passe)
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end
    end)
end

local function deactivateShield()
    isShieldActive = false
    if getgenv().ShieldLoop then getgenv().ShieldLoop:Disconnect() end
    
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
    ToggleBtn.Text = "ATIVAR ESCUDO (NO CLIP)"
    StatusTxt.Text = "Status: Vulnerável"
    StatusTxt.TextColor3 = Color3.fromRGB(150, 150, 150)
    
    -- Tenta restaurar propriedades (Melhor resetar o boneco se possível)
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanQuery = true
                part.CanTouch = true
                part.CanCollide = true
            end
        end
    end
end

-- ==============================================================================
-- BOTÕES
-- ==============================================================================

ToggleBtn.MouseButton1Click:Connect(function()
    if isShieldActive then
        deactivateShield()
    else
        activateShield()
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
    deactivateShield()
    ScreenGui:Destroy()
end)

-- Reativar automático se morrer (Respawn)
LocalPlayer.CharacterAdded:Connect(function()
    if isShieldActive then
        task.wait(1)
        activateShield()
    end
end)

game.StarterGui:SetCore("SendNotification", {Title="Werbert Shield V4", Text="Proteção Ativa!", Duration=5})
