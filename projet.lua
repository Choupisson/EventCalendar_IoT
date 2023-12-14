-- Configure les broches I2C pour SDA et SCL
local sda = 18
local scl = 21

-- Configuration des broches I2C
i2c.setupins(0, sda, scl)

-- Adresse I2C de l'écran OLED
local i2c_address = 0x3C

-- Attache l'écran OLED
gdisplay.attach(gdisplay.SSD1306_128_64, gdisplay.LANDSCAPE_FLIP, false, i2c_address)

-- Fonction pour tronquer les chaînes de caractères si elles sont trop longues
local function truncateString(str, maxLength)
    if string.len(str) > maxLength then
        return string.sub(str, 1, 12) .. "..."
    else
        return str
    end
end

-- Fonction pour effacer l'écran et afficher l'événement
local function displayEvent(event)
    -- Efface l'écran
    gdisplay.clear()

    -- Définit le type de police à utiliser
    gdisplay.setfont(gdisplay.FONT_DEFAULT)

    -- Affiche le nom de l'événement, la date, l'heure et le lieu avec troncature
    gdisplay.write({0, 0}, "Event: " .. truncateString(event.description, 15))
    gdisplay.write({0, 16}, "Date: " .. truncateString(event.date, 15))
    gdisplay.write({0, 32}, "Lieu: " .. truncateString(event.lieu, 15))

    -- Actualise l'écran
    gdisplay.update()
end

-- Exemple d'événement
local event = {
    description = "Caravane",
    date = "12/21/2023, 11:11:00 AM", -- Format MM/DD/YYYY, HH:MM:SS AM/PM
    lieu = "Salle D010"
}

-- Appel de la fonction pour afficher l'événement
displayEvent(event)
