using HTTP, JSON3, Base64

function get_album(query::String, token)
    headers = Dict(
        "Authorization" => "Bearer $(token)",
        "Content-Type" => "application/json"
    )
    escaped = HTTP.escapeuri(query)
    response = HTTP.get("https://api.spotify.com/v1/search?q=$escaped&type=album", headers)
    response = copy(JSON3.read(String(response.body)))
    try
        return response[:albums][:items][1]
    catch
        return nothing
    end
end

function get_album_by_id(id, token)
    headers = Dict(
        "Authorization" => "Bearer $(token)",
        "Content-Type" => "application/json"
    )
    response = HTTP.get("https://api.spotify.com/v1/albums/$id", headers)
    response = copy(JSON3.read(String(response.body)))
    return response
end

headers = Dict(
    "Authorization" => "Basic $(Base64.base64encode("f6775bde068b4c31b39eb53423ab8133:331cad304a6d4b4492b38b299e059975"))",
    "Content-Type" => "application/x-www-form-urlencoded"
)

ans = HTTP.post("https://accounts.spotify.com/api/token", headers, "grant_type=client_credentials")
token = JSON3.read(String(ans.body))[:access_token]
not_found = []

begin
    id_list = Dict{Int64, String}()

    open("idlist") do f
        while !eof(f)
            s = readline(f)
            split_line = split(s, " ")
            id = parse(Int,split_line[1][1:end-1])
            spotify_id = split_line[2]
            id_list[id] = spotify_id
        end
    end

    open("albumlist") do f
        i = 1
        while !eof(f)
            i += 1
            s = readline(f)
            split_line = split(s, " ")
            id = parse(Int,split_line[1][1:end-1])

            if isfile("albums/$id.json")
                continue
            end

            album = nothing

            if id ∈ keys(id_list)
                album = get_album_by_id(id_list[id], token)
            else
                query = join(split_line[2:end]," ")
                query = replace(query, r"\((.*?)\)" => "", r"19[5-9][0-9]" => "",  r"20[0-2][0-9]" => "")
                query = replace(query, "-" => "")
                @show query
                album = get_album(query, token)
            end

            sleep(0.25)
    
            if !isnothing(album)
                album[:list_entry] = s
                open("albums/$id.json", "w") do io
                    JSON3.pretty(io, album)
                end
            else
                open("notfound", "a") do io
                    write(io, s)
                    write(io, "\n")
                end
            end
        end
    end
end