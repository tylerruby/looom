json.array!(@filtered_friends) do |friend|
  json.id friend["id"]
  json.name friend["name"]
end