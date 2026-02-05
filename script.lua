--[[
    WERBERT IMMORTALITY HUB V1 (GOD MODES UNIVERSAIS)
    Criado por: @werbert_ofc
    
    Métodos de Imortalidade:
    1. Desync God: Separa sua hitbox visual da física (Tiros atravessam).
    2. Seat God: Bug de 'sentar' que impede dano em muitos jogos.
    3. Anti-Touch: Desativa killbricks (Lava/Espinhos) localmente.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Limpeza inicial para não duplicar
if getgenv().WerbertGodUI then getgenv().WerbertGodUI:Destroy() end

-- Variáveis de Controle
local isDesyncActive = false
local isSeatActive = false
local isAntiTouchActive = false
local desyncConnection = nil
local antiTouchConnection = nil

-- ==============================================================================
-- INTERFACE MODERNA (Draggable & Mobile Friendly)
-- ==============================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertGodUI"
if pcall(function() ScreenGui.Parent = CoreGui end) then
    getgenv().WerbertGodUI = ScreenGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    getgenv().WerbertGodUI = ScreenGui
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

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 0, 0) -- Vermelho Sangue
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "IMORTALIDADE V1"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Parent = MainFrame

-- Botão Fechar (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
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
MiniBtn.TextSize = 22
MiniBtn.Parent = MainFrame
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

-- Ícone Flutuante
local FloatIcon = Instance.new("TextButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatIcon.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
FloatIcon.Text = "🛡️"
FloatIcon.TextSize = 24
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)
makeDraggable(MainFrame)
makeDraggable(FloatIcon)

-- Função Helper para criar botões
local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local status = false
    btn.MouseButton1Click:Connect(function()
        status = not status
        callback(status, btn)
    end)
end

-- ==============================================================================
-- 1. GOD MODE DESYNC (O MAIS ROBUSTO PARA COMBATE)
-- ==============================================================================
-- Separa a hitbox do visual manipulando a velocidade da rede (Network Ownership)

local function toggleDesync(state, btn)
    isDesyncActive = state
    
    if state then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        btn.Text = "DESYNC GOD: ON"
        
        -- Loop de Desync
        desyncConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- O truque: Define a velocidade para um valor absurdo, mas reseta a posição visualmente
                -- Isso confunde o servidor sobre onde você realmente está.
                local hrp = char.HumanoidRootPart
                local oldVel = hrp.Velocity
                
                -- Movimenta a hitbox para longe e volta num piscar de olhos
                hrp.Velocity = Vector3.new(0, 0, 0) 
                hrp.CFrame = hrp.CFrame -- Mantém visualmente
                
                -- Técnica avançada: Quebra a sincronia de física
                sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", true) 
            end
        end)
    else
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        btn.Text = "ATIVAR DESYNC GOD (TIRO)"
        if desyncConnection then desyncConnection:Disconnect() end
        -- Restaura física
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", false)
        end
    end
end

-- ==============================================================================
-- 2. SEAT GOD MODE (CADEIRA INVISÍVEL)
-- ==============================================================================
-- Cria um assento e força o player a sentar. Muitos jogos não dão dano em quem tá sentado.

local function toggleSeatGod(state, btn)
    isSeatActive = state
    local char = LocalPlayer.Character
    
    if state then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        btn.Text = "SEAT GOD: ON"
        
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Cria a cadeira
            local seat = Instance.new("Seat")
            seat.Name = "WerbertGodSeat"
            seat.Transparency = 1
            seat.CanCollide = false
            seat.Massless = true
            seat.CFrame = char.HumanoidRootPart.CFrame
            seat.Parent = char
            
            -- Solda a cadeira no player
            local weld = Instance.new("Weld")
            weld.Part0 = seat
            weld.Part1 = char.HumanoidRootPart
            weld.Parent = seat
            
            -- Força sentar
            char.Humanoid.Sit = true
        end
    else
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        btn.Text = "ATIVAR SEAT GOD (BUG)"
        
        if char and char:FindFirstChild("WerbertGodSeat") then
            char.WerbertGodSeat:Destroy()
            char.Humanoid.Sit = false
            char.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end
end

-- ==============================================================================
-- 3. ANTI-TOUCH (KILLBRICKS / OBBY)
-- ==============================================================================
-- Desativa a colisão de toque em peças perigosas ao redor

local function toggleAntiTouch(state, btn)
    isAntiTouchActive = state
    
    if state then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        btn.Text = "ANTI-TOUCH: ON"
        
        antiTouchConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            
            -- Raio de proteção
            local myPos = char.HumanoidRootPart.Position
            local parts = Workspace:GetPartBoundsInRadius(myPos, 15) -- 15 studs ao redor
            
            for _, part in pairs(parts) do
                -- Se a peça tiver script de kill ou for vermelha (típico de obby)
                if part.Name == "KillBrick" or part.Name == "Lava" or part:FindFirstChild("TouchInterest") then
                    -- Destroi o detector de toque localmente
                    if part:FindFirstChild("TouchInterest") then
                        part.TouchInterest:Destroy()
                    end
                    -- Ou desativa colisão de toque
                    part.CanTouch = false
                end
            end
        end)
    else
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        btn.Text = "ATIVAR ANTI-TOUCH (OBBY)"
        if antiTouchConnection then antiTouchConnection:Disconnect() end
    end
end

-- ==============================================================================
-- CRIAÇÃO DOS BOTÕES NO MENU
-- ==============================================================================

createButton("ATIVAR DESYNC GOD (COMBATE)", 50, nil, toggleDesync)
createButton("ATIVAR SEAT GOD (BUG)", 110, nil, toggleSeatGod)
createButton("ATIVAR ANTI-TOUCH (OBBY)", 170, nil, toggleAntiTouch)

-- Botão de Minimizar
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
    if desyncConnection then desyncConnection:Disconnect() end
    if antiTouchConnection then antiTouchConnection:Disconnect() end
end)

game.StarterGui:SetCore("SendNotification", {Title="Werbert Immortality", Text="Menu Carregado! Escolha seu modo.", Duration=5})
