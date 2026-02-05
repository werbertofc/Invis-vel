--[[
    WERBERT GOD V8 - O ZUMBI (NO-ROOT)
    Criado por: @werbert_ofc
    
    ESTRATÉGIA SUPREMA (ESTÁTICA):
    1. Ancora o Tronco (Torso) para não cair.
    2. Deleta a 'HumanoidRootPart' (A peça que recebe 99% dos danos).
    3. Remove braços e pernas para diminuir a área de contato.
    4. Resultado: O personagem quebra a lógica de dano do jogo e fica imortal.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Limpeza
if getgenv().WerbertUI then getgenv().WerbertUI:Destroy() end

-- Variáveis
local isZombieActive = false
local originalCFrame = nil -- Para salvar onde você estava

-- ==============================================================================
-- INTERFACE MODERNA (PRETO E ROXO)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertGodV8"
if pcall(function() ScreenGui.Parent = CoreGui end) then
    getgenv().WerbertUI = ScreenGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    getgenv().WerbertUI = ScreenGui
end

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

-- Janela
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 180)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(170, 0, 255) -- Roxo
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "GOD V8: O ZUMBI"
Title.TextColor3 = Color3.fromRGB(170, 0, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = MainFrame

-- Botões Janela
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 30, 0, 30)
MiniBtn.Position = UDim2.new(1, -70, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
ToggleBtn.Text = "ATIVAR MODO ZUMBI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0.75, 0)
Status.BackgroundTransparency = 1
Status.Text = "Status: Normal (Mortal)"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Parent = MainFrame

-- Ícone
local FloatIcon = Instance.new("TextButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatIcon.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
FloatIcon.Text = "🧟"
FloatIcon.TextSize = 24
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)

makeDraggable(MainFrame)
makeDraggable(FloatIcon)

-- ==============================================================================
-- LÓGICA ZUMBI (NO ROOT)
-- ==============================================================================

local function activateZombie()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Identifica o Tronco (R6 ou R15)
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if not torso or not root then 
        game.StarterGui:SetCore("SendNotification", {Title="Erro", Text="Personagem não carregou!", Duration=3})
        return 
    end
    
    isZombieActive = true
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    ToggleBtn.Text = "ZUMBI: ON (IMÓVEL & IMORTAL)"
    Status.Text = "Hitbox Removida (Seguro)"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    -- 1. SALVAR POSIÇÃO
    originalCFrame = root.CFrame
    
    -- 2. ANCORAR TUDO (Para não cair no void)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = true
        end
    end
    
    -- 3. REMOVER A PEÇA MESTRA (ROOT PART)
    -- Isso quebra o script de dano do inimigo
    if root and root ~= torso then -- Garante que não é o torso em R6
        root:Destroy()
    end
    
    -- 4. REMOVER MEMBROS (Opcional, mas ajuda a evitar hits)
    -- Mantemos a Cabeça e o Tronco para o jogo não te matar automaticamente
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            if part.Name == "Left Arm" or part.Name == "Right Arm" or part.Name == "Left Leg" or part.Name == "Right Leg" or
               part.Name == "LeftUpperArm" or part.Name == "RightUpperArm" or part.Name == "LeftUpperLeg" or part.Name == "RightUpperLeg" then
                part:Destroy()
            end
        end
    end
    
    -- 5. TRAVA DE VIDA (Loop Rápido)
    getgenv().ZombieLoop = RunService.RenderStepped:Connect(function()
        if not isZombieActive then return end
        local h = char:FindFirstChild("Humanoid")
        if h then
            h.Health = h.MaxHealth
            -- Evita estado de morte
            if h:GetState() == Enum.HumanoidStateType.Dead then
                h:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end
    end)
    
    game.StarterGui:SetCore("SendNotification", {Title="GOD V8", Text="Modo Zumbi Ativo! Não se mova.", Duration=5})
end

local function resetCharacter()
    -- Para sair, precisamos morrer de verdade
    local char = LocalPlayer.Character
    if char then
        -- Desancora para cair ou força morte
        local h = char:FindFirstChild("Humanoid")
        if h then h.Health = 0 end
    end
    
    if getgenv().ZombieLoop then getgenv().ZombieLoop:Disconnect() end
    isZombieActive = false
    
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ToggleBtn.Text = "ATIVAR MODO ZUMBI"
    Status.Text = "Resetando..."
end

-- ==============================================================================
-- BOTÕES
-- ==============================================================================

ToggleBtn.MouseButton1Click:Connect(function()
    if isZombieActive then
        resetCharacter()
    else
        activateZombie()
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
    ScreenGui:Destroy()
end)

LocalPlayer.CharacterAdded:Connect(function()
    isZombieActive = false
    if getgenv().ZombieLoop then getgenv().ZombieLoop:Disconnect() end
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ToggleBtn.Text = "ATIVAR MODO ZUMBI"
    Status.Text = "Normal"
end)

game.StarterGui:SetCore("SendNotification", {Title="Werbert God V8", Text="Imortalidade Estática Pronta!", Duration=5})
