defmodule FrankFerreiraWeb.Timeline do
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
            <div class="-my-6">
              <!-- Item #1 -->
              <div class="relative pl-8 sm:pl-32 py-6 group">
                <!-- Purple label -->
                <div class="font-caveat font-medium text-2xl text-indigo-500 mb-1 sm:mb-0">
                  Lorem Ipsum
                </div>
                <!-- Vertical line (::before) ~ Date ~ Title ~ Circle marker (::after) -->
                <div class="flex flex-col sm:flex-row items-start mb-1 group-last:before:hidden before:absolute before:left-2 sm:before:left-0 before:h-full before:px-px before:bg-slate-300 sm:before:ml-[6.5rem] before:self-start before:-translate-x-1/2 before:translate-y-3 after:absolute after:left-2 sm:after:left-0 after:w-2 after:h-2 after:bg-indigo-600 after:border-4 after:box-content after:border-slate-50 after:rounded-full sm:after:ml-[6.5rem] after:-translate-x-1/2 after:translate-y-1.5">
                  <time class="sm:absolute left-0 translate-y-0.5 inline-flex items-center justify-center text-xs font-semibold uppercase w-20 h-6 mb-3 sm:mb-0 text-emerald-600 bg-emerald-100 rounded-full">
                    Mai, 2022
                  </time>
                  <div class="text-xl font-bold text-slate-900">
                    Primeiro emprego remoto - São Paulo
                  </div>
                </div>
                <!-- Content -->
                <div class="text-slate-500">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
                </div>
              </div>
              <!-- Item #1 -->
              <div class="relative pl-8 sm:pl-32 py-6 group">
                <!-- Purple label -->
                <div class="font-caveat font-medium text-2xl text-indigo-500 mb-1 sm:mb-0">
                  Lorem Ipsum
                </div>
                <!-- Vertical line (::before) ~ Date ~ Title ~ Circle marker (::after) -->
                <div class="flex flex-col sm:flex-row items-start mb-1 group-last:before:hidden before:absolute before:left-2 sm:before:left-0 before:h-full before:px-px before:bg-slate-300 sm:before:ml-[6.5rem] before:self-start before:-translate-x-1/2 before:translate-y-3 after:absolute after:left-2 sm:after:left-0 after:w-2 after:h-2 after:bg-indigo-600 after:border-4 after:box-content after:border-slate-50 after:rounded-full sm:after:ml-[6.5rem] after:-translate-x-1/2 after:translate-y-1.5">
                  <time class="sm:absolute left-0 translate-y-0.5 inline-flex items-center justify-center text-xs font-semibold uppercase w-20 h-6 mb-3 sm:mb-0 text-emerald-600 bg-emerald-100 rounded-full">
                    Jul, 2019
                  </time>
                  <div class="text-xl font-bold text-slate-900">
                    Primeiro emprego dos sonhos - Ananindeua
                  </div>
                </div>
                <!-- Content -->
                <div class="text-slate-500">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
                </div>
              </div>
              <!-- Item #1 -->
              <div class="relative pl-8 sm:pl-32 py-6 group">
                <!-- Purple label -->
                <div class="font-caveat font-medium text-2xl text-indigo-500 mb-1 sm:mb-0">
                  Lorem Ipsum
                </div>
                <!-- Vertical line (::before) ~ Date ~ Title ~ Circle marker (::after) -->
                <div class="flex flex-col sm:flex-row items-start mb-1 group-last:before:hidden before:absolute before:left-2 sm:before:left-0 before:h-full before:px-px before:bg-slate-300 sm:before:ml-[6.5rem] before:self-start before:-translate-x-1/2 before:translate-y-3 after:absolute after:left-2 sm:after:left-0 after:w-2 after:h-2 after:bg-indigo-600 after:border-4 after:box-content after:border-slate-50 after:rounded-full sm:after:ml-[6.5rem] after:-translate-x-1/2 after:translate-y-1.5">
                  <time class="sm:absolute left-0 translate-y-0.5 inline-flex items-center justify-center text-xs font-semibold uppercase w-20 h-6 mb-3 sm:mb-0 text-emerald-600 bg-emerald-100 rounded-full">
                    Jun, 2019
                  </time>
                  <div class="text-xl font-bold text-slate-900">
                    Fim dos estudos na UFRA - Belem
                  </div>
                </div>
                <!-- Content -->
                <div class="text-slate-500">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
                </div>
              </div>
              <!-- Item #2 -->
              <div class="relative pl-8 sm:pl-32 py-6 group">
                <!-- Purple label -->
                <div class="font-caveat font-medium text-2xl text-indigo-500 mb-1 sm:mb-0">
                  Lorem Ipsum
                </div>
                <!-- Vertical line (::before) ~ Date ~ Title ~ Circle marker (::after) -->
                <div class="flex flex-col sm:flex-row items-start mb-1 group-last:before:hidden before:absolute before:left-2 sm:before:left-0 before:h-full before:px-px before:bg-slate-300 sm:before:ml-[6.5rem] before:self-start before:-translate-x-1/2 before:translate-y-3 after:absolute after:left-2 sm:after:left-0 after:w-2 after:h-2 after:bg-indigo-600 after:border-4 after:box-content after:border-slate-50 after:rounded-full sm:after:ml-[6.5rem] after:-translate-x-1/2 after:translate-y-1.5">
                  <time class="sm:absolute left-0 translate-y-0.5 inline-flex items-center justify-center text-xs font-semibold uppercase w-20 h-6 mb-3 sm:mb-0 text-emerald-600 bg-emerald-100 rounded-full">
                    Ago, 2017
                  </time>
                  <div class="text-xl font-bold text-slate-900">
                    Fim dos estudos no IFPA - Ananindeua
                  </div>
                </div>
                <!-- Content -->
                <div class="text-slate-500">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
                </div>
              </div>
              <!-- Item #1 -->
              <div class="relative pl-8 sm:pl-32 py-6 group">
                <!-- Purple label -->
                <div class="font-caveat font-medium text-2xl text-indigo-500 mb-1 sm:mb-0">
                  Lorem Ipsum
                </div>
                <!-- Vertical line (::before) ~ Date ~ Title ~ Circle marker (::after) -->
                <div class="flex flex-col sm:flex-row items-start mb-1 group-last:before:hidden before:absolute before:left-2 sm:before:left-0 before:h-full before:px-px before:bg-slate-300 sm:before:ml-[6.5rem] before:self-start before:-translate-x-1/2 before:translate-y-3 after:absolute after:left-2 sm:after:left-0 after:w-2 after:h-2 after:bg-indigo-600 after:border-4 after:box-content after:border-slate-50 after:rounded-full sm:after:ml-[6.5rem] after:-translate-x-1/2 after:translate-y-1.5">
                  <time class="sm:absolute left-0 translate-y-0.5 inline-flex items-center justify-center text-xs font-semibold uppercase w-20 h-6 mb-3 sm:mb-0 text-emerald-600 bg-emerald-100 rounded-full">
                    Fev, 2015
                  </time>
                  <div class="text-xl font-bold text-slate-900">
                    Inicio dos estudos na UFRA - Belem
                  </div>
                </div>
                <!-- Content -->
                <div class="text-slate-500">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
                </div>
              </div>
              <!-- Item #0 -->
              <div class="relative pl-8 sm:pl-32 py-6 group">
                <!-- Purple label -->
                <div class="font-caveat font-medium text-2xl text-indigo-500 mb-1 sm:mb-0">
                  Lorem Ipsum
                </div>
                <!-- Vertical line (::before) ~ Date ~ Title ~ Circle marker (::after) -->
                <div class="flex flex-col sm:flex-row items-start mb-1 group-last:before:hidden before:absolute before:left-2 sm:before:left-0 before:h-full before:px-px before:bg-slate-300 sm:before:ml-[6.5rem] before:self-start before:-translate-x-1/2 before:translate-y-3 after:absolute after:left-2 sm:after:left-0 after:w-2 after:h-2 after:bg-indigo-600 after:border-4 after:box-content after:border-slate-50 after:rounded-full sm:after:ml-[6.5rem] after:-translate-x-1/2 after:translate-y-1.5">
                  <time class="sm:absolute left-0 translate-y-0.5 inline-flex items-center justify-center text-xs font-semibold uppercase w-20 h-6 mb-3 sm:mb-0 text-emerald-600 bg-emerald-100 rounded-full">
                    Dez, 2014
                  </time>
                  <div class="text-xl font-bold text-slate-900">
                    Inicio dos estudos no IFPA - Ananindeua
                  </div>
                </div>
                <!-- Content -->
                <div class="text-slate-500">
                  Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum
                </div>
              </div>
            </div>
          </section>
        </article>
      </header>
    </main>
    """
  end
end
