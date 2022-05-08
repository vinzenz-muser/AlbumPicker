module CreateTableRatings

import SearchLight.Migrations: create_table, column, columns, pk, add_index, drop_table, add_indices

function up()
  create_table(:ratings) do
    [
      pk()
      column(:user_id, :integer)
      column(:album_id, :integer)
      column(:value, :integer, limit=1)
      column(:comment, :string)
      column(:active_album, :integer)
    ]
  end

  add_index(:ratings, :user_id)
  add_index(:ratings, :album_id)
  add_index(:ratings, :value)
end

function down()
  drop_table(:ratings)
end

end
