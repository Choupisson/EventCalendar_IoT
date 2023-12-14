-- Configure les broches I2C pour SDA et SCL
local sda = 18
local scl = 21

-- Configuration des broches I2C
i2c.setpins(0, sda, scl)

-- Adresse I2C de l'écran OLED
local i2c_address = 0x3C

-- Attache l'écran OLED
gdisplay.attach(gdisplay.SSD1306_128_64, gdisplay.LANDSCAPE_FLIP, false, i2c_address)

-- Fonction pour effacer l'écran et afficher l'événement
local function displayEvent(event)
    -- Efface l'écran
    gdisplay.clear()

    -- Définit le type de police à utiliser
    gdisplay.setfont(gdisplay.FONT_DEFAULT)

    -- Affiche le nom de l'événement, la date, l'heure et le lieu
    gdisplay.write({0, 0}, "Event: " .. event.description)
    gdisplay.write({0, 16}, "Date: " .. event.date)
    gdisplay.write({0, 32}, "Time: " .. event.time)
    gdisplay.write({0, 48}, "Location: " .. event.location)

    -- Actualise l'écran
    gdisplay.update()
end

-- Exemple d'événement
local event = {
    description = "Apprendre Lua pour ESP32",
    date = "31/12/2023", -- Format DD/MM/YYYY
    time = "15:30:00",   -- Format HH:MM:SS
    location = "Salle 100"
}

-- Appel de la fonction pour afficher l'événement
displayEvent(event)
