defmodule FrankFerreira.Blog do
  alias FrankFerreira.Blog.Post

  defmodule NotFoundError do
    defexception [:message, plug_status: 404]
  end

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:frank_ferreira, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang],
    earmark_options: [
      postprocessor: &FrankFerreira.Markdown.post_processor/1,
      code_class_prefix: "language-"
    ]

  # The @posts variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all posts by descending date.
  @posts Enum.sort_by(@posts, & &1.created_at, {:desc, Date})

  # Let's also get all tags
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_posts, do: @posts
  def all_tags, do: @tags

  def published_posts(locale),
    do: Enum.filter(all_posts(), &(&1.published == true and &1.language == locale))

  def recent_posts(locale, num \\ 5) do
    published_posts(locale)
    |> Enum.take(num)
  end

  def get_post_by_id!(id, locale) do
    Enum.find(all_posts(), &(&1.id == id and &1.language == locale)) ||
      raise NotFoundError, "post with id=#{id} not found"
  end

  def get_posts_by_tag!(tag) do
    case Enum.filter(all_posts(), &(tag in &1.tags)) do
      [] -> raise NotFoundError, "posts with tag=#{tag} not found"
      posts -> posts
    end
  end
end
