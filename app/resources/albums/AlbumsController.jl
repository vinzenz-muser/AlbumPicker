module AlbumsController

using  Genie.Renderer.Html, Genie.Exceptions, SearchLight, Albums, Users, Ratings, GenieAuthentication

function index()
    html(:albums, :index, albums=rand(Album))
end

function show_user()
    user = findone(Users.User, id=get_authentication())

    if user.active_album == 0
        max_id = maximum([album.id.value for album ∈ all(Album)])
        user.active_album = rand(1:max_id)
        save!(user)
    end

    album = find(Album, id=user.active_album)

    html(:albums, :index, albums=album)
end

function save_rating(value, comment)
    user = findone(Users.User, id=get_authentication())
    rating = Rating(user_id=user.id, album_id=user.active_album, value=value, comment=comment)
    save(rating)
    possible_albums = Albums.get_open_album_ids(user)

    new_album = rand(possible_albums)
    user.active_album = new_album.id
    
    save!(user)
    
    redirect(:home)
end

function skip()
    user = findone(Users.User, id=get_authentication())
    possible_albums = Albums.get_open_album_ids(user)
    new_album = rand(possible_albums)
    user.active_album = new_album.id
    
    save!(user)
    
    redirect(:home)
end

function dont_do()
    save_rating(-1, "")
    redirect(:home)
end

function what()
    html(:albums, :what)
end

end