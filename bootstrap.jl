(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using AlbumPicker
push!(Base.modules_warned_for, Base.PkgId(AlbumPicker))
AlbumPicker.main()
