defmodule FrankFerreira.Blog.Post do
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
    :twitter
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
    :twitter
  ]

  def build(filename, attrs, body) do
    [year, month_day_id] = filename |> Path.rootname() |> Path.split() |> Enum.take(-2)
    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    created_at = Date.from_iso8601!("#{year}-#{month}-#{day}")

    struct!(__MODULE__, [id: id, created_at: created_at, body: body] ++ Map.to_list(attrs))
  end
end
