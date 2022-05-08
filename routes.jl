using Genie, Genie.Router, Genie.Requests
using AlbumsController, RatingsController, GenieAuthentication

route("/", named=:home) do;
    if !authenticated()
        return AlbumsController.index()
    end

    return AlbumsController.show_user()
end

route("/save_rating", method = POST, named=:save_rating) do; @authenticated!
    value = parse(Int64, postpayload(:value, -1))
    AlbumsController.save_rating(
        value, postpayload(:comment, "")
    )
end

route("/skip_album", named=:skip) do; @authenticated!
    AlbumsController.skip()
end

route("/dont_do", named=:dontdo) do; @authenticated!
    AlbumsController.dont_do()
end

route("/list", named=:listrating) do; @authenticated! 
    RatingsController.list_rating()
end

route("/rating/delete/:id", named=:delrating) do; @authenticated! 
    RatingsController.delete_rating(payload(:id))
end