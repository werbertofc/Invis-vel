--[[
    WERBERT GOD V7 - MODO ESTATUA (CORPO NULO)
    Criado por: @werbert_ofc
    
    LÓGICA SUPREMA:
    - Se você aceita ficar parado, nós DELETAMOS seu corpo físico.
    - Mantemos apenas a 'HumanoidRootPart' (invisível e ancorada) para o servidor não te matar.
    - Sem braços, sem pernas, sem cabeça = SEM HITBOX.
    - Impossível de acertar tiro ou facada.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Limpeza
if getgenv().WerbertUI then getgenv().WerbertUI:Destroy() end

local isStatueActive = false

-- ==============================================================================
-- INTERFACE MODERNA (MINIMALISTA)
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WerbertGodV7"
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
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5) -- Preto Absoluto
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 255, 255) -- Branco
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "GOD V7: CORPO NULO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "ATIVAR MODO ESTATUA"
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
Status.Text = "Status: Corpo Inteiro"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Parent = MainFrame

-- Ícone
local FloatIcon = Instance.new("TextButton")
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FloatIcon.Text = "🗿"
FloatIcon.TextSize = 24
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)

makeDraggable(MainFrame)
makeDraggable(FloatIcon)

-- ==============================================================================
-- LÓGICA DO CORPO NULO (DELETAR TUDO)
-- ==============================================================================

local function activateStatue()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end -- Precisa da raiz pra não morrer pro server
    
    isStatueActive = true
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    ToggleBtn.Text = "ESTATUA: ON (IMORTAL)"
    Status.Text = "Corpo Deletado (Intangível)"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    
    -- 1. ANCORAR A RAIZ (Para não cair no void ao perder as pernas)
    hrp.Anchored = true
    hrp.CFrame = hrp.CFrame -- Trava na posição atual
    
    -- 2. DESMEMBRAMENTO TOTAL
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Accessory") then
            -- NÃO DELETAR A ROOTPART (Senão você morre)
            if part.Name ~= "HumanoidRootPart" then
                part:Destroy() -- Deleta Braços, Pernas, Cabeça, Chapéus
            end
        end
    end
    
    -- 3. ESCONDER A RAIZ (Ficar totalmente invisível)
    hrp.Transparency = 1
    hrp.CanCollide = false
    
    -- Opcional: Remove o rosto se sobrar
    local head = char:FindFirstChild("Head")
    if head then head:Destroy() end
    
    game.StarterGui:SetCore("SendNotification", {Title="GOD V7", Text="Seu corpo físico foi removido!", Duration=3})
end

local function resetCharacter()
    -- Para voltar ao normal, a única forma é resetar o personagem (morrer de propósito)
    -- Pois não tem como "recriar" pernas deletadas.
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.Health = 0 -- Reseta para voltar a ter corpo
        end
    end
    
    isStatueActive = false
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "ATIVAR MODO ESTATUA"
    Status.Text = "Reiniciando..."
end

-- ==============================================================================
-- BOTÕES
-- ==============================================================================

ToggleBtn.MouseButton1Click:Connect(function()
    if isStatueActive then
        -- Se já está ativo, o botão serve para resetar e voltar ao normal
        resetCharacter()
    else
        activateStatue()
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

-- Reativar botões ao renascer
LocalPlayer.CharacterAdded:Connect(function()
    isStatueActive = false
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "ATIVAR MODO ESTATUA"
    Status.Text = "Corpo: Sólido"
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

game.StarterGui:SetCore("SendNotification", {Title="Werbert God V7", Text="Modo Estátua Carregado!", Duration=5})
