neomonth = neopixel.attach(neopixel.WS2812B, pio.GPIO23,8)
neoday = neopixel.attach(neopixel.WS2812B, pio.GPIO22 ,8)
neohour = neopixel.attach(neopixel.WS2812B, pio.GPIO19 ,8)


local json_str = '{"date":"12/21/2023, 11:11:00 
AM","description":"11","lieu":"111111"}' -- importer date de l'evenement

-- Extraction date
local date_str = json_str:match('"date":"(.-)"')

local month, day, year, time, period = date_str:match("(%d+)/(%d+)/(%d+), 
(%d+:%d+:%d+) ([APMapm]+)")

local hour, minute, second = time:match("(%d+):(%d+):(%d+)")
if period:lower() == "pm" then
    hour = hour + 12
end

-- Date actuelle (mois, jour, heure)
local dateactuelle = --importer date actuelle
  année, mois, jour, heure, minutes, seconde = --mise sous le format 
utilisable de dateactuelle

function max(a, b)
    if a > b then
        return a
    else
        return b
    end
end

function allumer_neopixel(neo, n, r, g, b) 
  if neo = "hour"
    for i = 0, n-1 do
        neohour:setPixel(i, r//8*(i+1), g//8*(i+1), b//8*(i+1))
  end
  if neo = "day"
    for i = 0, n-1 do
        neoday:setPixel(i, r//8*(i+1), g//8*(i+1), b//8*(i+1))
  end
  if neo = "month"
    for i = 0, n-1 do
        neomonth:setPixel(i, r//8*(i+1), g//8*(i+1), b//8*(i+1))
  end
    neopixel:update()
end

function main()
    

    local difmois = max(0, (year-année)*12 + (month - mois)%12)
    allumer_neopixels("month", 8 - (difmois//3*2) ,128,0,128)

    if difmois == 0 then
        local difjour = max(0, (day - jour)%31) --ca va casser pour 
fevrier mais osef
        allumer_neopixels("day", 8 - (difjour//4) ,0,255,0)

        if difjour == 0 then
            local difheure = max(0, (hour - heure)%24)
            allumer_neopixels("hour", 8 - (difheure//3) ,255,0,0)
        end
    end
end

main()
