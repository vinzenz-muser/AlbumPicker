module Ratings

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export Rating

@kwdef mutable struct Rating <: AbstractModel
  id::DbId = DbId()
  user_id::Int64 = 0
  album_id::Int64 = 0
  value::Int64 = 0
  comment::String = ""
end

end
