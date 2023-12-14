neomonth = neopixel.attach(neopixel.WS2812B, pio.GPIO23,8)
neoday = neopixel.attach(neopixel.WS2812B, pio.GPIO22 ,8)
neohour = neopixel.attach(neopixel.WS2812B, pio.GPIO19 ,8)

function neopixelExec(event)
    if time ~= 0 then
        local date_str = event:match('"date":"(.-)"')

        local month, day, year, time, period = date_str:match("(%d+)/(%d+)/(%d+),(%d+:%d+:%d+) ([APMapm]+)")

        local hour, minute, second = time:match("(%d+):(%d+):(%d+)")
        if period:lower() == "pm" then
            hour = hour + 12
        end

        local dateInfo = parseDateString(getDate(time))

        local annee = dateInfo.year
        local mois = dateInfo.month
        local jour = dateInfo.day
        local heure = dateInfo.hour
        local minutes = dateInfo.min
        local seconde = dateInfo.sec

        function max(a, b)
            if a > b then
                return a
            else
                return b
            end
        end

        function allumer_neopixel(neo, n, r, g, b) 
        if neo == "hour" then
            for i = 0, n-1 do
                neohour:setPixel(i, r//8*(i+1), g//8*(i+1), b//8*(i+1))
            end
        end
        if neo == "day" then
            for i = 0, n-1 do
                neoday:setPixel(i, r//8*(i+1), g//8*(i+1), b//8*(i+1))
            end
        end
        if neo == "month" then
            for i = 0, n-1 do
                neomonth:setPixel(i, r//8*(i+1), g//8*(i+1), b//8*(i+1))
            end
        end
            neopixel:update()
        end

        function main()
            

            local difmois = max(0, (year-annee)*12 + (month - mois)%12)
            allumer_neopixels("month", 8 - (difmois//3*2) ,128,0,128)

            if difmois == 0 then
                local difjour = max(0, (day - jour)%31)
                allumer_neopixels("day", 8 - (difjour//4) ,0,255,0)

                if difjour == 0 then
                    local difheure = max(0, (hour - heure)%24)
                    allumer_neopixels("hour", 8 - (difheure//3) ,255,0,0)
                end
            end
        end

        main()
    end
end