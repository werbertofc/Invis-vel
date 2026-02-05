--[[
    WERBERT HUB V3 - INVISIBILIDADE FE (CORREÇÃO DE MOVIMENTO)
    Criado por: @werbert_ofc
    
    Correções:
    - Adicionado 'Massless = true' para o corpo não pesar e travar o boneco.
    - Adicionado 'CanCollide = false' agressivo para não prender no chão.
    - Otimização do loop para evitar lag.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Limpeza inicial
if getgenv().WerbertUI then
    getgenv().WerbertUI:Destroy()
    if getgenv().InvisibleConnection then getgenv().InvisibleConnection:Disconnect() end
end

-- Variáveis
local isInvisible = false
getgenv().InvisibleConnection = nil

-- ==============================================================================
-- INTERFACE GRÁFICA (UI)
-- ==============================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertHub_InvisV3"
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

-- PAINEL PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 170, 0) -- Laranja/Ouro
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- TÍTULO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 35)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "INVISÍVEL V3 (FIX)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- BOTÕES DE CONTROLE DA JANELA
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

-- BOTÃO TOGGLE
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.Text = "ATIVAR INVISIBILIDADE"
ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- STATUS TEXT
local StatusTxt = Instance.new("TextLabel")
StatusTxt.Size = UDim2.new(1, 0, 0, 20)
StatusTxt.Position = UDim2.new(0, 0, 0.8, 0)
StatusTxt.BackgroundTransparency = 1
StatusTxt.Text = "Status: Visível"
StatusTxt.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusTxt.Font = Enum.Font.Gotham
StatusTxt.TextSize = 12
StatusTxt.Parent = MainFrame

-- ÍCONE FLUTUANTE
local FloatIcon = Instance.new("TextButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatIcon.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
FloatIcon.Text = "👻"
FloatIcon.TextSize = 24
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FloatIcon).Thickness = 2

makeDraggable(MainFrame)
makeDraggable(FloatIcon)

-- ==============================================================================
-- LÓGICA DE INVISIBILIDADE (FIX)
-- ==============================================================================

local function updateInvisibility(state)
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not hrp or not humanoid then return end

    if state then
        -- === ATIVAR ===
        
        -- Configuração Inicial: Tira colisão de tudo para não travar
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Massless = true -- O SEGREDO: Tira o peso das partes
            end
        end

        -- Loop de Física (Stepped é melhor para evitar travamento)
        getgenv().InvisibleConnection = RunService.Stepped:Connect(function()
            if not char or not char.Parent or not hrp.Parent or humanoid.Health <= 0 then
                -- Se morreu, reseta
                if getgenv().InvisibleConnection then getgenv().InvisibleConnection:Disconnect() end
                isInvisible = false
                ToggleBtn.Text = "ATIVAR (RESET)"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                return
            end

            -- Move todas as partes (menos a raiz) para baixo
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = false
                    part.Massless = true
                    part.Velocity = Vector3.new(0,0,0)
                    
                    -- Manda para baixo, mas não TÃO longe para não quebrar a junta
                    -- 300 studs é seguro o suficiente
                    part.CFrame = hrp.CFrame * CFrame.new(0, -300, 0)
                end
            end
            
            -- Esconde efeitos visuais
            for _, obj in pairs(char:GetDescendants()) do
                if obj:IsA("Decal") then obj.Transparency = 1 end
                if obj:IsA("ParticleEmitter") then obj.Enabled = false end
            end
        end)
        
        -- Atualiza UI
        ToggleBtn.Text = "DESATIVAR (ON)"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        StatusTxt.Text = "Status: Invisível (Safe Mode)"
        StatusTxt.TextColor3 = Color3.fromRGB(0, 255, 0)
        
    else
        -- === DESATIVAR ===
        if getgenv().InvisibleConnection then
            getgenv().InvisibleConnection:Disconnect()
            getgenv().InvisibleConnection = nil
        end
        
        -- Tenta matar o personagem para resetar 100% (mais seguro para desbugar)
        -- humanoid.Health = 0 
        
        -- Ou apenas atualiza a UI se não quiser resetar
        ToggleBtn.Text = "ATIVAR INVISIBILIDADE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        StatusTxt.Text = "Status: Visível"
        StatusTxt.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end

-- ==============================================================================
-- BOTÕES
-- ==============================================================================

ToggleBtn.MouseButton1Click:Connect(function()
    isInvisible = not isInvisible
    updateInvisibility(isInvisible)
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
    if getgenv().InvisibleConnection then getgenv().InvisibleConnection:Disconnect() end
    ScreenGui:Destroy()
end)

-- Auto-Reativar ao morrer (Opcional, evita bugs)
LocalPlayer.CharacterAdded:Connect(function()
    isInvisible = false
    if getgenv().InvisibleConnection then getgenv().InvisibleConnection:Disconnect() end
    ToggleBtn.Text = "ATIVAR INVISIBILIDADE"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

game.StarterGui:SetCore("SendNotification", {Title="Werbert Hub V3", Text="Correção de Movimento Carregada!", Duration=5})
