using Albums, JSON3, SearchLight

function seed()
    open("db/seeds/albums/albumlist") do f
        i = 1
        while !eof(f)
            i += 1
            s = readline(f)
            split_line = split(s, " ")
            id = parse(Int64,split_line[1][1:end-1])

            title::String = "unknown"
            artist::String = "unknown"
            image_url::String = ""
            year::Int64 = 0
            list_entry::String = s
            list_id::Int64 = id

            if isfile("albums/$id.json")
                album_dict = JSON3.read(read("db/seeds/albums/$id.json"))
                title = album_dict[:name]
                artist = join([i[:name] for i ∈ album_dict[:artists]], ", ")
                image_url = album_dict[:images][1][:url]
                if album_dict[:release_date_precision] == "year"
                    year = parse(Int64, album_dict[:release_date])  
                else
                    year = parse(Int64, split(album_dict[:release_date], "-")[1])  
                end
            end

            album = Album(
                title = title,
                artist = artist,
                year = year,
                list_entry = list_entry,
                list_id = list_id,
                image_url = image_url
            )

            save(album)
        end
    end
end