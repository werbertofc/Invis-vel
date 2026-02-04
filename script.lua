--[[
    FE INVISIBLE SCRIPT (MÉTODO SUBTERRÂNEO)
    Criado para Werbert Hub (Baseado em métodos comuns de FE)
    
    Como funciona:
    Mantém sua 'HumanoidRootPart' (sua hitbox principal) no lugar certo para o servidor.
    Mas, localmente, empurra todas as partes visíveis (cabeça, tronco, membros, acessórios)
    para 500 studs abaixo do mapa a cada frame.
    
    Resultado: Os outros jogadores não veem seu corpo, apenas a hitbox invisível.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variável para controlar a conexão do loop, para poder desligar ao renascer
local invisibleConnection = nil

-- Função principal que aplica a invisibilidade
local function turnInvisible()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Espera o personagem carregar coisas essenciais
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not hrp or not humanoid then return end

    -- Se já tiver um loop rodando da vida passada, desconecta
    if invisibleConnection then invisibleConnection:Disconnect() end

    print("WerbertHub: Ativando Invisibilidade FE...")

    -- O Heartbeat roda a cada frame físico do jogo (super rápido)
    invisibleConnection = RunService.Heartbeat:Connect(function()
        -- Se o personagem morreu ou sumiu, para o loop
        if not char or not char.Parent or not hrp.Parent or humanoid.Health <= 0 then
            if invisibleConnection then invisibleConnection:Disconnect() end
            return
        end

        -- Varre todas as partes do personagem
        for _, part in pairs(char:GetDescendants()) do
            -- Se for uma parte física (braço, perna, cabeça) E NÃO FOR a raiz principal
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                -- Desativa colisão para não bugar o chão
                part.CanCollide = false
                
                -- Zera a velocidade para evitar que a física do jogo tente puxar de volta
                part.Velocity = Vector3.new(0, 0, 0)
                part.RotVelocity = Vector3.new(0, 0, 0)
                
                -- A MÁGICA: Teleporta a parte para 500 studs abaixo da posição real
                -- Usa CFrame para garantir que vá para baixo relativo à posição atual
                part.CFrame = hrp.CFrame * CFrame.new(0, -500, 0)
            end
            
            -- Remove/Esconde Acessórios e Rostos para garantir
            if part:IsA("Decal") or part:IsA("Texture") then -- Esconde rostos/estampas
                part.Transparency = 1
            elseif part:IsA("Accessory") or part:IsA("Hat") then -- Destroi chapéus localmente
                part:Destroy()
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then -- Desativa efeitos
                part.Enabled = false
            end
        end
    end)
    
    -- Tenta consertar a câmera para focar na Raiz, não no corpo enterrado
    workspace.CurrentCamera.CameraSubject = hrp
end

-- Ativa no personagem atual
turnInvisible()

-- Conecta para ativar automaticamente quando renascer
LocalPlayer.CharacterAdded:Connect(function(newChar)
    -- Espera um pouco para o personagem carregar antes de tentar ficar invisível
    task.wait(1.5) 
    turnInvisible()
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "WerbertHub";
    Text = "Invisibilidade FE Ativada! (Corpo movido para o subsolo)";
    Duration = 5;
})

