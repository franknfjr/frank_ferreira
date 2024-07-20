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
            <h2 class="relative w-full font-heading text-navy-900 leading-tight sm:leading-tight lg:leading-tight 2xl:leading-tight text-3xl sm:text-4xl lg:text-[2.75rem] dark:text-white">
              Hardware
            </h2>
            <p>
              <%= gettext(
                "Here are some of the hardware devices I use in my daily life, whether it's for studying programming or leisure."
              ) %>
            </p>
            <p>
              <%= gettext(
                "Soon, I'll create a route `/hardware/:device` to provide detailed explanations of the specifications and configurations that I use."
              ) %>
            </p>

            <ul class="max-w-md space-y-1 text-gray-500 list-disc list-inside dark:text-gray-400">
              <li>
                13-inch MacBook Air with M2 chip
              </li>
              <li>
                Dell Universal Dock - UD22
              </li>
              <li>
                Monitor Dell P2719H
              </li>
              <li>
                Dell Pro Wireless Keyboard and Mouse – KM5221W
              </li>
              <li>
                QuadCast S – USB Condenser Gaming Microphone
              </li>
              <li>
                Generic Headset
              </li>
            </ul>

            <h2 class="relative w-full font-heading text-navy-900 leading-tight sm:leading-tight lg:leading-tight 2xl:leading-tight text-3xl sm:text-4xl lg:text-[2.75rem] dark:text-white">
              Software
            </h2>
            <p>
              <%= gettext(
                "The same train of thought as before, and here are some of the software applications I use on a daily basis."
              ) %>
            </p>
            <ul class="max-w-md space-y-1 text-gray-500 list-disc list-inside dark:text-gray-400">
              <li>
                Zed Editor
              </li>
              <li>
                XCode
              </li>
              <li>
                CleanShot X
              </li>
              <li>
                iTerm 2
              </li>
              <li>
                Postico 2
              </li>
              <li>
                Calendar.app <%= gettext("(default apple)") %>
              </li>
              <li>
                Mail.app <%= gettext("(default apple)") %>
              </li>
              <li>
                Notion
              </li>
            </ul>
          </section>
        </article>
      </header>
    </main>
    """
  end
end
