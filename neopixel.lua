neomonth = neopixel.attach(neopixel.WS2812B, pio.GPIO23,8)
neoday = neopixel.attach(neopixel.WS2812B, pio.GPIO22 ,8)
neohour = neopixel.attach(neopixel.WS2812B, pio.GPIO19 ,8)

pio.pin.setdir(pio.OUTPUT,pio.GPIO4)

function max(a, b)
    if a > b then
        return a
    else
        return b
    end
end

function allumer_neopixel(neo, n, r, g, b) 
    if neo == "hour" then
        for i = 0, 8 do
            neohour:setPixel(i, 0, 0, 0)
        end
        for i = 0, n do
            neohour:setPixel(i, r//8*(i), g//8*(i), b//8*(i))
        end
        neohour:update()
    end
    if neo == "day" then
        for i = 0, 8 do
            neoday:setPixel(i, 0, 0, 0)
        end
        for i = 0, n do
            neoday:setPixel(i, r//8*(i), g//8*(i), b//8*(i))
        end
        neoday:update()
    end
    if neo == "month" then
        for i = 0, 8 do
            neomonth:setPixel(i, 0, 0, 0)
        end
        for i = 0, n do
            neomonth:setPixel(i, r//8*(i), g//8*(i), b//8*(i))
        end
        neomonth:update()
    end 
end

function neopixelExec(currentEvent)
    if timeSet then

        local eventTimestamp = getTimestamp(currentEvent)
        local currentTime = new_timestamp + old_timestamp - os.time() 

        difheure = (eventTimestamp - currentTime) / 3600

        difjour = (eventTimestamp - currentTime) / 86400

        difmois =  (eventTimestamp - currentTime) /2592000

        allumer_neopixel("month", 8 - math.floor(difmois/3)*2 ,128,0,128)

        allumer_neopixel("day", 8 - math.floor(difjour/4) ,0,255,0)

        allumer_neopixel("hour", 8 - math.floor(difheure/3) ,255,0,0)
    end
end

function basicAlert()
    pio.pin.sethigh(pio.GPIO4)
    tmr.delayms(250)
    pio.pin.setlow(pio.GPIO4)
    
    -- for j = 0,8 do
        -- neomonth:setPixel(j,0,0,0)
        -- neoday:setPixel(j,0,0,0)
        -- neohour:setPixel(j,0,0,0)
    -- end
    -- neomonth:update()
    -- neoday:update()
    -- neohour:update()
    -- nb = math.random(0,8)
    -- for j = 0,nb do
        -- neomonth:setPixel(j,math.random(0,255),math.random(0,255),math.random(0,255))
        -- neoday:setPixel(j,math.random(0,255),math.random(0,255),math.random(0,255))
        -- neohour:setPixel(j,math.random(0,255),math.random(0,255),math.random(0,255))
    -- end
    -- neomonth:update()
    -- neoday:update()
    -- neohour:update()
end

function alert()
    i = 0
    while i < 10 do
        pcall(function()
            basicAlert()
        end)
        tmr.delayms(250)
        i = i + 1
    end
    
    -- pcall(function()
        -- for j = 0,8 do
            -- neomonth:setPixel(j,0,0,0)
            -- neoday:setPixel(j,0,0,0)
            -- neohour:setPixel(j,0,0,0)
        -- end
        -- neomonth:update()
        -- neoday:update()
        -- neohour:update()
    -- end)
end