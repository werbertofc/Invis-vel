--[[
    WERBERT GOD V12.5 - HÍBRIDO + MENU COMPLETO
    Criado por: @werbert_ofc
    
    ATUALIZAÇÃO DE UI:
    - Botão Minimizar (-) agora ativa o Ícone Flutuante.
    - Botão Fechar (X) desliga o modo Deus e fecha o script.
    - Lógica Híbrida mantida (Root Delete + Phantom Limbs).
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Limpeza de versões anteriores
if getgenv().WerbertUI then getgenv().WerbertUI:Destroy() end
if getgenv().HybridLoop then getgenv().HybridLoop:Disconnect() end

local isHybridActive = false
local speed = 30 -- Velocidade de voo

-- Controles de Voo
local keys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

-- ==============================================================================
-- INTERFACE GRÁFICA COMPLETA
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertGodV12_5"
if pcall(function() ScreenGui.Parent = CoreGui end) then
    getgenv().WerbertUI = ScreenGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    getgenv().WerbertUI = ScreenGui
end

-- Função para Arrastar (PC e Mobile)
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

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 180)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0) -- Vermelho Sangue
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "GOD V12.5: FINAL"
Title.TextColor3 = Color3.fromRGB(255, 80, 80)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = MainFrame

-- Botão Fechar (X) - Para tudo
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Botão Minimizar (-)
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

-- Botão Ativar (Toggle)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 60)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "ATIVAR GOD MODE"
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
Status.Text = "Status: Vulnerável"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Parent = MainFrame

-- ÍCONE FLUTUANTE (Para reabrir)
local FloatIcon = Instance.new("TextButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatIcon.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
FloatIcon.Text = "🛡️"
FloatIcon.TextSize = 24
FloatIcon.Visible = false -- Começa escondido
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FloatIcon).Color = Color3.fromRGB(255, 255, 255)
Instance.new("UIStroke", FloatIcon).Thickness = 2

makeDraggable(MainFrame)
makeDraggable(FloatIcon)

-- ==============================================================================
-- SISTEMA DE MOVIMENTO (WASD/Mobile)
-- ==============================================================================

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = false end
end)

local function startFlight(part)
    getgenv().HybridLoop = RunService.RenderStepped:Connect(function(dt)
        if not part or not part.Parent then return end
        
        -- Voo (Câmera)
        local cam = Workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        
        if keys.W then move = move + cam.LookVector end
        if keys.S then move = move - cam.LookVector end
        if keys.A then move = move - cam.RightVector end
        if keys.D then move = move + cam.RightVector end
        if keys.Space then move = move + Vector3.new(0,1,0) end
        if keys.Shift then move = move - Vector3.new(0,1,0) end
        
        if move.Magnitude > 0 then
            move = move.Unit * speed * dt * 5
            part.CFrame = part.CFrame + move
        end
        part.Velocity = Vector3.new(0,0,0)
        part.RotVelocity = Vector3.new(0,0,0)

        -- Proteção Contínua (Phantom Mode)
        local char = LocalPlayer.Character
        if char then
            for _, limb in pairs(char:GetChildren()) do
                if limb:IsA("BasePart") then
                    limb.CanCollide = false
                    limb.CanTouch = false -- Anti-Lava/Poder
                    limb.CanQuery = false -- Anti-Tiro
                    if limb:FindFirstChild("TouchInterest") then limb.TouchInterest:Destroy() end
                end
            end
            
            -- Trava de Vida
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        end
    end)
end

-- ==============================================================================
-- LÓGICA DO GOD MODE (ATIVAR/DESATIVAR)
-- ==============================================================================

local function deactivateHybrid()
    -- Reseta o loop e status
    if getgenv().HybridLoop then getgenv().HybridLoop:Disconnect() end
    isHybridActive = false
    
    -- Reseta o personagem (Mata para voltar ao normal)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
    end
    
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.Text = "ATIVAR GOD MODE"
    Status.Text = "Resetando..."
end

local function activateHybrid()
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    
    if not torso then return end
    
    isHybridActive = true
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ToggleBtn.Text = "GOD MODE: ON"
    Status.Text = "Proteção Híbrida Ativa"
    Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    
    -- 1. Deleta a Raiz (RootPart)
    if root then root:Destroy() end
    
    -- 2. Foca câmera no Torso
    Workspace.CurrentCamera.CameraSubject = torso
    
    -- 3. Inicia Voo e Proteção
    startFlight(torso)
end

-- ==============================================================================
-- LÓGICA DOS BOTÕES (UI)
-- ==============================================================================

-- Botão Ativar/Desativar
ToggleBtn.MouseButton1Click:Connect(function()
    if isHybridActive then
        deactivateHybrid()
    else
        activateHybrid()
    end
end)

-- Botão Minimizar (-)
MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatIcon.Visible = true -- Mostra o ícone flutuante
end)

-- Botão Ícone Flutuante (Restaurar)
FloatIcon.MouseButton1Click:Connect(function()
    FloatIcon.Visible = false -- Esconde o ícone
    MainFrame.Visible = true  -- Mostra o menu
end)

-- Botão Fechar (X) - Para TUDO
CloseBtn.MouseButton1Click:Connect(function()
    if isHybridActive then
        deactivateHybrid() -- Desativa o modo Deus primeiro
    end
    if getgenv().HybridLoop then getgenv().HybridLoop:Disconnect() end
    ScreenGui:Destroy() -- Destroi o menu
end)

-- Auto-Reset se morrer
LocalPlayer.CharacterAdded:Connect(function()
    isHybridActive = false
    if getgenv().HybridLoop then getgenv().HybridLoop:Disconnect() end
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.Text = "ATIVAR GOD MODE"
    Status.Text = "Vulnerável"
end)

game.StarterGui:SetCore("SendNotification", {Title="Werbert God V12.5", Text="Menu Completo Carregado!", Duration=5})
