-- Servicios
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Guardar spawn/base
local spawnPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new(0,5,0)

-- GUI simple y movible
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TPGui"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 160)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderColor3 = Color3.fromRGB(255,255,255)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "NSX SCRIPT"
title.Font = Enum.Font.Arcade
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.TextScaled = true

-- Status
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,-20,0,25)
status.Position = UDim2.new(0,10,0,40)
status.Text = " Esperando..."
status.Font = Enum.Font.Arcade
status.TextColor3 = Color3.fromRGB(255,255,255)
status.BackgroundTransparency = 1
status.TextScaled = true

-- Botón TP
local btnTP = Instance.new("TextButton", frame)
btnTP.Size = UDim2.new(1,-40,0,45)
btnTP.Position = UDim2.new(0,20,0,70)
btnTP.Text = "Activar Autoguiado"
btnTP.Font = Enum.Font.Arcade
btnTP.TextScaled = true
btnTP.TextColor3 = Color3.fromRGB(0,0,0)
btnTP.BackgroundColor3 = Color3.fromRGB(255,255,255)
btnTP.BorderSizePixel = 2
btnTP.BorderColor3 = Color3.fromRGB(255,255,255)

-- Cerrar GUI
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,25,0,20)
close.Position = UDim2.new(1,-30,0,5)
close.Text = "X"
close.Font = Enum.Font.Arcade
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(255,255,255)
close.TextColor3 = Color3.fromRGB(0,0,0)
close.BorderSizePixel = 2
close.BorderColor3 = Color3.fromRGB(255,255,255)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- CONFIG TP AJUSTADO
local STEP_DISTANCE = 3     -- más rápido
local STEP_DELAY = 0.08     -- estable y seguro
local LINE_DISTANCE = 2     -- distancia para girar hacia la base

-- Función TP inteligente y segura
local function smartTP(hrp, enemyBasePos)
    -- Decidir dirección al salir de la base enemiga
    local direction
    if spawnPos.X < enemyBasePos.X then
        direction = Vector3.new(-1,0,0) -- izquierda
    else
        direction = Vector3.new(1,0,0) -- derecha
    end

    local reachedLine = false

    while true do
        local hrpPos = hrp.Position

        -- Chequear si ya llegó frente a la línea de tu base
        if not reachedLine then
            if math.abs(hrpPos.X - spawnPos.X) <= LINE_DISTANCE then
                reachedLine = true
                -- Cambiar dirección hacia tu base
                direction = (spawnPos - hrpPos).Unit
            end
        else
            -- Revisar si llegó exactamente a tu base
            if (hrpPos - spawnPos).Magnitude <= STEP_DISTANCE then
                hrp.CFrame = CFrame.new(spawnPos.X, spawnPos.Y, spawnPos.Z)
                break
            end
        end

        -- Avanzar un mini paso
        local stepPos = hrpPos + direction * STEP_DISTANCE
        hrp.CFrame = CFrame.new(stepPos.X, hrpPos.Y, stepPos.Z)
        task.wait(STEP_DELAY)
    end
end

-- Botón ejecuta TP
btnTP.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        status.Text = "❌ HumanoidRootPart not found!"
        return
    end

    status.Text = "Auto Guiado En Progreso..."
    local enemyBasePos = hrp.Position + hrp.CFrame.LookVector * 50 -- ejemplo de base enemiga
    smartTP(hrp, enemyBasePos)
    status.Text = "Llegaste!"
end)

print("💀 Smart TP cargado: velocidad ajustada y más estable")