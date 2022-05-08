module CreateTableAlbums

import SearchLight.Migrations: create_table, column, columns, pk, add_index, drop_table, add_indices

function up()
  create_table(:albums) do
    [
      pk()
      column(:title, :string, limit=1000)
      column(:artist, :string, limit=1000)
      column(:year, :integer, limit=4)
      column(:list_entry, :string, limit=1000)
      column(:list_id, :integer, limit=4)
      column(:image_url, :string, limit=1000)
    ]
  end

  add_index(:albums, :title)
  add_index(:albums, :artist)
  add_index(:albums, :year)
  add_index(:albums, :list_id)
end

function down()
  drop_table(:albums)
end

end
