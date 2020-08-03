module Matrix
  struct Typing
    JSON.mapping(
      room: String,
      user_ids: Array(String)
    )
  end
end
