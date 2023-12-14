function API()
    -- Création du serveur sur le port 3000
    local server = assert(require("socket").bind("*", 80))

    while true do
        -- Accepter une connexion entrante
        local client = server:accept()
        client:settimeout(10) -- Définir un délai pour la connexion

        -- Lire la requête entrante
        local request = client:receive("*l") -- Lire la première ligne (méthode, chemin, protocole)

        if request then
            -- Obtenir la méthode et le chemin de la requête
            local method, path, protocol = request:match("(%u+)%s+(.-)%s+(HTTP/%d.%d)")

            if method == "GET" and path =="/events" then
                local res = "["
                for i, v in ipairs(events) do
                    res = res .. v
                    if i ~= #events then
                        res = res .. ", "
                    end
                end
                res = res .. "]"

                local response = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: " .. #res .. "\r\n\r\n" .. res
                client:send(response)
            else
                if method == "GET" and path =="/" then
                    local file = io.open("/index.html", "r")

                    if file then
                        local content = file:read("*all")
                        file:close()
        
                        local response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: " .. #content .. "\r\n\r\n" .. content
                        client:send(response)
                    end
                else 
                    if method == "POST" and (path == "/add" or path=="/remove") then
                        -- Lire les données du corps de la requête
                        local contentLength = 0
                        local body = ""
                        repeat
                            local line, err = client:receive()
                            if line then
                                local cl = line:match("Content%-Length:%s*(%d+)")
                                if cl then
                                    contentLength = tonumber(cl)
                                end

                                body = body .. line
                            end
                        until not line or line == ""

                        -- If content-length is provided, read the body
                        if contentLength > 0 then
                            body = client:receive(contentLength)
                        end

                        if(path == "/add") then
                            -- Stocker les données dans la liste locale
                            table.insert(events, body)
                        else
                            console(body)
                            for i, v in ipairs(events) do
                                console(v)
                                if v == body then
                                    table.remove(events, i)
                                    break  -- Arrêtez la recherche dès que l'élément est trouvé et supprimé
                                end
                            end
                        end

                        -- Générer une réponse OK
                        local response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 2\r\n\r\nOK"
                        client:send(response)
                    else
                        -- Répondre avec une erreur pour toute autre requête
                        local response = "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: 2\r\n\r\nOK"
                        client:send(response)
                    end
                end
            end
        end

        -- Fermer la connexion
        client:close()
    end
end

-- Start the server in a separate thread
thread.start(API)