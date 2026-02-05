--[[
    WERBERT GOD MODE - STANDALONE (SOLO)
    Criado por: @werbert_ofc
    
    CARACTERÍSTICAS:
    - Este script é INDEPENDENTE. Não entra em conflito com outros menus.
    - Tecnologia: Omega V13 (Root Delete + Phantom + Health Lock).
    - Controles: Menu Completo (Minimizar/Fechar/Arrastar).
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ==============================================================================
-- LIMPEZA EXCLUSIVA (Só fecha se for ele mesmo)
-- ==============================================================================
if getgenv().WerbertGodSoloUI then getgenv().WerbertGodSoloUI:Destroy() end
if getgenv().GodSoloLoop then getgenv().GodSoloLoop:Disconnect() end

local isGodActive = false
local flySpeed = 50 
local keys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

-- ==============================================================================
-- INTERFACE (ROXO ÚNICO)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertGodMode_Solo"
if pcall(function() ScreenGui.Parent = CoreGui end) then
    getgenv().WerbertGodSoloUI = ScreenGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    getgenv().WerbertGodSoloUI = ScreenGui
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

-- JANELA
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.5, -125, 0.8, 0) -- Posição mais baixa pra não atrapalhar
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(150, 0, 255)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- TÍTULO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "GOD MODE: SOLO"
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = MainFrame

-- BOTÕES DE JANELA
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
MiniBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 20
MiniBtn.Parent = MainFrame
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

-- BOTÃO TOGGLE
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 60)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
ToggleBtn.Text = "ATIVAR IMORTALIDADE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- STATUS
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0.75, 0)
Status.BackgroundTransparency = 1
Status.Text = "Status: Normal"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Parent = MainFrame

-- ÍCONE FLUTUANTE
local FloatIcon = Instance.new("TextButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.9, -60, 0.5, 0) -- Canto direito
FloatIcon.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
FloatIcon.Text = "Ω"
FloatIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatIcon.Font = Enum.Font.GothamBlack
FloatIcon.TextSize = 24
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FloatIcon).Color = Color3.fromRGB(255, 255, 255)
Instance.new("UIStroke", FloatIcon).Thickness = 2

makeDraggable(MainFrame)
makeDraggable(FloatIcon)

-- ==============================================================================
-- LÓGICA DE MOVIMENTO (WASD + Voo)
-- ==============================================================================

UserInputService.InputBegan:Connect(function(i,g) if not g then if keys[i.KeyCode.Name] ~= nil then keys[i.KeyCode.Name]=true end end end)
UserInputService.InputEnded:Connect(function(i) if keys[i.KeyCode.Name] ~= nil then keys[i.KeyCode.Name]=false end end)

local function startGodLoop(part)
    getgenv().GodSoloLoop = RunService.RenderStepped:Connect(function(dt)
        if not part or not part.Parent then return end
        
        -- VOO
        local cam = Workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        
        if keys.W then move = move + cam.LookVector end
        if keys.S then move = move - cam.LookVector end
        if keys.A then move = move - cam.RightVector end
        if keys.D then move = move + cam.RightVector end
        if keys.Space then move = move + Vector3.new(0,1,0) end
        if keys.Shift then move = move - Vector3.new(0,1,0) end
        
        if move.Magnitude > 0 then
            move = move.Unit * flySpeed * dt * 5
            part.CFrame = part.CFrame + move
        end
        part.Velocity = Vector3.new(0,0,0)
        
        -- PROTEÇÃO (Phantom + Health)
        local char = LocalPlayer.Character
        if char then
            for _, limb in pairs(char:GetChildren()) do
                if limb:IsA("BasePart") then
                    limb.CanCollide = false
                    limb.CanTouch = false
                    limb.CanQuery = false
                    if limb:FindFirstChild("TouchInterest") then limb.TouchInterest:Destroy() end
                end
            end
            local h = char:FindFirstChild("Humanoid")
            if h then 
                h.Health = h.MaxHealth 
                h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        end
    end)
end

-- ==============================================================================
-- LÓGICA ATIVAR/DESATIVAR
-- ==============================================================================

local function activate()
    local char = LocalPlayer.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not torso then return end
    
    isGodActive = true
    
    -- DELETA A RAIZ (Chave da Imortalidade)
    if root then root:Destroy() end
    
    Workspace.CurrentCamera.CameraSubject = torso
    
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    ToggleBtn.Text = "IMORTAL: ATIVO"
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    Status.Text = "Raiz Deletada | Fantasma"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    startGodLoop(torso)
    game.StarterGui:SetCore("SendNotification", {Title="Werbert God", Text="Ativado! (Solo)", Duration=3})
end

local function deactivate()
    if getgenv().GodSoloLoop then getgenv().GodSoloLoop:Disconnect() end
    isGodActive = false
    
    -- Reseta Personagem
    local char = LocalPlayer.Character
    if char then
        local h = char:FindFirstChild("Humanoid")
        if h then h.Health = 0 end
    end
    
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
    ToggleBtn.Text = "ATIVAR IMORTALIDADE"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Text = "Resetando..."
end

-- ==============================================================================
-- EVENTOS DOS BOTÕES
-- ==============================================================================

ToggleBtn.MouseButton1Click:Connect(function()
    if isGodActive then deactivate() else activate() end
end)

MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false; FloatIcon.Visible = true
end)

FloatIcon.MouseButton1Click:Connect(function()
    FloatIcon.Visible = false; MainFrame.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    if isGodActive then deactivate() end
    ScreenGui:Destroy()
end)

LocalPlayer.CharacterAdded:Connect(function()
    isGodActive = false
    if getgenv().GodSoloLoop then getgenv().GodSoloLoop:Disconnect() end
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
    ToggleBtn.Text = "ATIVAR IMORTALIDADE"
    Status.Text = "Vulnerável"
end)
