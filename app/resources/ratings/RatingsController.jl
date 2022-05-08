module RatingsController

using GenieAuthentication, Genie.Renderer.Html, Genie.Exceptions, SearchLight, Albums, Users, Ratings

function list_rating()
    user = findone(Users.User, id=get_authentication())
    ratings = find(Ratings.Rating, user_id=user.id)
    rated_albums = []
    dropped_albums = []
    
    for rating in ratings
        album = findone(Albums.Album, id=rating.album_id)
        if rating.value == -1
            push!(dropped_albums, (rating, album))
        else
            push!(rated_albums, (rating, album))
        end
    end
    html(:ratings, :list, dropped_albums=dropped_albums, rated_albums=rated_albums)
end

function delete_rating(id)
    user = findone(Users.User, id=get_authentication())
    rating = findone(Ratings.Rating, id=id, user_id=user.id)
    SearchLight.delete(rating)
    redirect(:listrating)
end

end