defmodule FrankFerreira.Blog.Post do
  @words_per_minute 200

  @enforce_keys [
    :id,
    :author,
    :title,
    :body,
    :description,
    :tags,
    :created_at,
    :updated_at,
    :published,
    :twitter,
    :language,
    :read_minutes
  ]
  defstruct [
    :id,
    :author,
    :title,
    :body,
    :description,
    :tags,
    :created_at,
    :updated_at,
    :published,
    :twitter,
    :language,
    :read_minutes
  ]

  def build(filename, attrs, body) do
    {:ok, document} = Floki.parse_document(body)

    word_count = Floki.text(document) |> String.split(" ") |> Enum.count()
    read_minutes = ceil(word_count / @words_per_minute)

    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    created_at = Date.from_iso8601!("#{year}-#{month}-#{day}")

    {id, language} =
      cond do
        String.ends_with?(id, "-en_US") ->
          id = String.replace(id, "-en_US", "")
          {id, "en"}

        true ->
          {id, "br"}
      end

    struct!(
      __MODULE__,
      [id: id, created_at: created_at, body: body, language: language, read_minutes: read_minutes] ++
        Map.to_list(attrs)
    )
  end
end
