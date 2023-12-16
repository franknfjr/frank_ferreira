defmodule FrankFerreiraWeb.UsesLive do
  use FrankFerreiraWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <main role="main" class="container mx-auto px-4 sm:px-6 lg:px-8 py-14 md:py-20">
      <header class="max-w-[44rem] 2xl:max-w-3xl mx-auto mb-14 sm:mb-16">
        <article class="xl:grid grid-cols-auto-span-auto items-start sm:text-lg leading-relaxed">
          <section class="relative max-w-[44rem] 2xl:max-w-3xl mx-auto">
            <h1 class="relative w-full font-heading text-navy-900 leading-tight sm:leading-tight lg:leading-tight 2xl:leading-tight text-3xl sm:text-4xl lg:text-[2.75rem]">
              Hardware
            </h1>
            <p>
              Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
            </p>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-1.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-2.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-3.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-4.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-5.jpg"
                  alt=""
                />
              </div>
            </div>

            <h1 class="relative w-full font-heading text-navy-900 leading-tight sm:leading-tight lg:leading-tight 2xl:leading-tight text-3xl sm:text-4xl lg:text-[2.75rem]">
              Software
            </h1>
            <p>
              Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
            </p>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-1.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-2.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-3.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-4.jpg"
                  alt=""
                />
              </div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src="https://flowbite.s3.amazonaws.com/docs/gallery/square/image-5.jpg"
                  alt=""
                />
              </div>
            </div>
          </section>
        </article>
      </header>
    </main>
    """
  end
end
