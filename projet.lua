-- Configure les broches I2C pour SDA et SCL
local sda = 18
local scl = 21

-- Configuration des broches I2C
i2c.setpins(0, sda, scl)

-- Adresse I2C de l'écran OLED
local i2c_address = 0x3C

-- Attache l'écran OLED
gdisplay.attach(gdisplay.SSD1306_128_64, gdisplay.LANDSCAPE_FLIP, false, i2c_address)

-- Fonction pour tronquer les chaînes de caractères si elles sont trop longues
local function truncateString(str, maxLength)
    if string.len(str) > maxLength then
        return string.sub(str, 1, maxLength-3) .. "..."
    else
        return str
    end
end

-- Fonction pour effacer l'écran et afficher l'événement
function displayEvent(event)
    -- Efface l'écran
    gdisplay.clear()

    -- Définit le type de police à utiliser
    gdisplay.setfont(gdisplay.FONT_DEFAULT)

    local date = event:match('"date"%s*:%s*"([^"]+)"')
    local description = event:match('"description"%s*:%s*"([^"]+)"')
    local lieu = event:match('"lieu"%s*:%s*"([^"]+)"')

    -- Affiche le nom de l'événement, la date, l'heure et le lieu avec troncature
    gdisplay.write({0, 0}, "Event: " .. truncateString(description, 9))
    gdisplay.write({0, 16}, "Date: " .. truncateString(date, 9))
    gdisplay.write({0, 32}, "Lieu: " .. truncateString(lieu, 9))

    -- Actualise l'écran
    gdisplay.update()
end

-- Appel de la fonction pour afficher l'événement
-- displayEvent(event)

function getTimestamp(event)
    -- Expression régulière pour extraire la date
    local datePattern = '"date"%s*:%s*"(%d+/%d+/%d+,%s*%d+:%d+:%d+ %u%u)"'
    local dateString = event:match(datePattern)

    -- Convertir la date en timestamp UNIX
    local pattern = "(%d+)/(%d+)/(%d+), (%d+):(%d+):(%d+) (%u%u)"
    local month, day, year, hour, min, sec, period = dateString:match(pattern)

    local hourOffset = period == "PM" and 12 or 0
    hour = tonumber(hour) + hourOffset

    return os.time({year = tonumber(year), month = tonumber(month), day = tonumber(day), hour = tonumber(hour), min = tonumber(min), sec = tonumber(sec)})
end

function getDate(timestamp)
    return os.date("%m/%d/%Y, %I:%M:%S %p", timestamp)
end

function parseDateString(dateString)
    local pattern = "(%d+)/(%d+)/(%d+), (%d+):(%d+):(%d+) (%u%u)"
    local month, day, year, hour, min, sec, period = dateString:match(pattern)

    local hourOffset = period == "PM" and 12 or 0
    hour = tonumber(hour) + hourOffset

    return {
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec)
    }
end

function saveEvents()
    local file = io.open("events.lua", "w")
    
    if file then
        -- Écrire le tableau dans le fichier
        file:write("events = {")
        for i, v in ipairs(myTable) do
            if type(v) == "string" then
                file:write('"' .. v .. '"')
            else
                file:write(tostring(v))
            end
    
            if i < #myTable then
                file:write(", ")
            end
        end
        file:write("}")
        
        -- Fermer le fichier
        file:close()
    end    
end