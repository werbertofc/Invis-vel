--[[
    WERBERT GOD V11 - IY STYLE (ROOT DELETE)
    Criado por: @werbert_ofc
    
    A TÉCNICA DO INFINITE YIELD:
    1. Remove a 'HumanoidRootPart' (A Hitbox Mestra).
    2. Isso quebra 95% dos scripts de dano do servidor.
    3. Ativa um sistema de movimentação artificial (Fly/Noclip) 
       porque sem a Raiz, o personagem não anda nativamente.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Limpeza
if getgenv().WerbertUI then getgenv().WerbertUI:Destroy() end
if getgenv().FlyLoop then getgenv().FlyLoop:Disconnect() end

local isGodActive = false
local speed = 25 -- Velocidade de movimento

-- Variáveis de Movimento
local keys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}

-- ==============================================================================
-- INTERFACE ESTILO IY (PRETO/BRANCO MINIMALISTA)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertGodV11"
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
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 0) -- Quadrado estilo IY
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1
Stroke.Parent = MainFrame

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 5)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0,0,0,5)
Title.BackgroundTransparency = 1
Title.Text = "Infinite God (IY Style)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = MainFrame

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

-- Botão Ativar
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.Text = "Activate No-Root"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSans
ToggleBtn.TextSize = 18
ToggleBtn.Parent = MainFrame

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0.75, 0)
Status.BackgroundTransparency = 1
Status.Text = "Status: Vulnerable"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.SourceSans
Status.TextSize = 16
Status.Parent = MainFrame

makeDraggable(MainFrame)

-- ==============================================================================
-- LÓGICA DE MOVIMENTO (FLY/NOCLIP)
-- Necessário porque sem RootPart não dá pra andar
-- ==============================================================================

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
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

local function startMovement(part)
    getgenv().FlyLoop = RunService.RenderStepped:Connect(function(deltaTime)
        if not part or not part.Parent then return end
        
        local camCF = Workspace.CurrentCamera.CFrame
        local moveVector = Vector3.new(0, 0, 0)
        
        if keys.W then moveVector = moveVector + camCF.LookVector end
        if keys.S then moveVector = moveVector - camCF.LookVector end
        if keys.A then moveVector = moveVector - camCF.RightVector end
        if keys.D then moveVector = moveVector + camCF.RightVector end
        if keys.Space then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if keys.Shift then moveVector = moveVector - Vector3.new(0, 1, 0) end
        
        -- Normaliza para não correr mais rápido na diagonal
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * speed * deltaTime * 5
            part.CFrame = part.CFrame + moveVector
        end
        
        part.Velocity = Vector3.new(0,0,0) -- Anula física do jogo
        part.RotVelocity = Vector3.new(0,0,0)
    end)
end

-- ==============================================================================
-- LÓGICA GOD MODE (DELETAR ROOT)
-- ==============================================================================

local function activateGod()
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    local hum = char:FindFirstChild("Humanoid")
    
    if not root or not torso then return end
    
    isGodActive = true
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    ToggleBtn.Text = "GOD ACTIVE (NO ROOT)"
    Status.Text = "Hitbox Deleted | Flying"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    -- 1. DELETAR ROOT (O SEGREDO)
    root:Destroy()
    
    -- 2. AJUSTAR CÂMERA (Porque ela seguia o Root)
    Workspace.CurrentCamera.CameraSubject = torso
    
    -- 3. INICIAR MOVIMENTO ARTIFICIAL
    -- O personagem vai parecer que está "flutuando/voando"
    startMovement(torso)
    
    -- 4. DESATIVAR ESTADOS DE MORTE
    if hum then
        hum.PlatformStand = true -- Evita que ele tente levantar sozinho e bugue
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
end

local function deactivateGod()
    -- A única forma de voltar é resetar, pois deletamos uma peça vital
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
    end
    
    if getgenv().FlyLoop then getgenv().FlyLoop:Disconnect() end
    isGodActive = false
    ToggleBtn.Text = "Activate No-Root"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Text = "Resetting..."
end

-- ==============================================================================
-- BOTÕES
-- ==============================================================================

ToggleBtn.MouseButton1Click:Connect(function()
    if isGodActive then
        deactivateGod()
    else
        activateGod()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    if getgenv().FlyLoop then getgenv().FlyLoop:Disconnect() end
    ScreenGui:Destroy()
end)

LocalPlayer.CharacterAdded:Connect(function()
    isGodActive = false
    if getgenv().FlyLoop then getgenv().FlyLoop:Disconnect() end
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.Text = "Activate No-Root"
    Status.Text = "Vulnerable"
end)

game.StarterGui:SetCore("SendNotification", {Title="Infinite God", Text="Loaded! (Root Delete Method)", Duration=5})
