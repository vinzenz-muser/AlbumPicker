module Albums

using Ratings, Users, SearchLight

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Album

@kwdef mutable struct Album <: AbstractModel
  id::DbId = DbId()
  title::String = ""
  artist::String = ""
  year::Int64 = 0
  list_entry::String = ""
  list_id::Int64 = 0
  image_url::String = ""
end

function get_open_album_ids(user::Users.User)
  given_ratings = find(Ratings.Rating, user_id=user.id)
  given_ids = Set([rating.album_id for rating in given_ratings])
  albums = all(Albums.Album)
  albums_ids = Set([i.id for i in albums])
  possible_ids = setdiff(albums_ids, given_ids)
  return [album for album in albums if album.id in possible_ids]
end

end
