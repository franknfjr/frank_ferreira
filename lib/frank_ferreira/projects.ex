defmodule FrankFerreira.Projects do
  @moduledoc """
  Single source of truth for the projects shown across the site.

  Both the Projects index (`FrankFerreiraWeb.ProjectsLive`) and the home page
  "Recently shipped" section read from here, so the two never drift apart.

  A project can carry `highlight: true` to be pinned and featured on the home
  page (rendered with a 🔥). This is a manual, editorial flag: it does not
  follow any date logic, you set it by hand on whatever launch you want to push.
  """

  import FrankFerreiraWeb.Gettext

  @doc "Every project, newest editorial order first."
  def list do
    [
      %{
        id: "serpent",
        name: "Serpent",
        date: ~D[2026-05-23],
        image: "/images/serpent.svg",
        description:
          gettext(
            "Retro 8-bit snake game for Android with skins, ranking, and chiptune soundtrack — currently in Play Store review."
          ),
        full_description:
          gettext(
            "Serpent revisits the classic Nokia snake with chiptune music synthesized in real time, unlockable skins, achievements, and a global ranking. Free, offline-first, no login. Built natively for Android and currently under Play Store review. This entry is the landing page for the game."
          ),
        url: "https://serpent.frankferreira.com.br",
        github: nil,
        tech: [
          %{name: "Android", logo: "android.com"},
          %{name: "Kotlin", logo: "kotlinlang.org"},
          %{name: "HTML", logo: "/images/html5-logo.svg"}
        ]
      },
      %{
        id: "parazao-da-memoria",
        name: "Parazão da Memória",
        date: ~D[2026-05-07],
        image: "/images/parazaodamemoria.png",
        description:
          gettext(
            "Pará-themed memory card game with sound, speech, and haptics. Built with Expo and React Native; an Android release is on the way."
          ),
        full_description:
          gettext(
            "Parazão da Memória is a memory card game themed around Pará. It pairs cards with sound effects, spoken cues, and haptic feedback for a tactile feel, built with Expo and React Native (TypeScript). The Expo build is done and an Android release for the Play Store is on the way."
          ),
        url: "https://parazaodamemoria.frankferreira.com.br",
        github: nil,
        tech: [
          %{name: "Expo", logo: "expo.dev"},
          %{name: "React Native", logo: "reactnative.dev"},
          %{name: "TypeScript", logo: "typescriptlang.org"}
        ]
      },
      %{
        id: "hugo-andre-personal",
        name: "Hugo André Personal",
        date: ~D[2026-03-20],
        image: "/images/hugoandrepersonal.png",
        description:
          gettext("Personal trainer website for body transformation programs for women 40+."),
        full_description:
          gettext(
            "Professional website developed for Hugo André Personal, a personal trainer with 15+ years of experience specializing in body transformation for women 40+. Features training programs, workout details, and WhatsApp integration for client contact. Built with React and Vite, deployed on Vercel."
          ),
        url: "https://hugoandrepersonal.com.br",
        github: nil,
        tech: [
          %{name: "React", logo: "react.dev"},
          %{name: "Vite", logo: "vite.dev"},
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "entregador-das-galaxias",
        name: "Entregador das Galaxias",
        date: ~D[2026-03-06],
        image: "/images/entregadordasgalaxias.png",
        description:
          gettext(
            "Educational space delivery game built as a fun challenge for kids with trending themes in Brazil."
          ),
        full_description:
          gettext(
            "Entregador das Galaxias is an educational browser game created as a challenge for my niece Sofia, combining trending themes in Brazil 2026 in a playful and non-violent format. Built with pure HTML, CSS, and JavaScript, it features a space delivery adventure designed to be fun and relevant for kids."
          ),
        url: "https://entregadordasgalaxias.frankferreira.com.br",
        github: "https://github.com/franknfjr/entregador-das-galaxias",
        tech: [
          %{name: "HTML", logo: "/images/html5-logo.svg"},
          %{name: "CSS", logo: "/images/css3-logo.svg"},
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "circuito-das-plantas",
        name: "Circuito das Plantas",
        date: ~D[2026-03-06],
        image: "/images/circuitodasplantas.png",
        description:
          gettext(
            "Product catalog and showcase for requesting plants, seedlings, and gardening products."
          ),
        full_description:
          gettext(
            "Product catalog and showcase developed for Circuito das Plantas, a plant shop offering a wide variety of plants, seedlings, and gardening products. A modern, responsive application built with React and Vite, featuring a product catalog and showcase for requesting products."
          ),
        url: "https://circuitodasplantas.com.br",
        github: nil,
        tech: [
          %{name: "React", logo: "react.dev"},
          %{name: "Vite", logo: "vite.dev"},
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "bruna-caroline",
        name: "Bruna Caroline",
        date: ~D[2026-03-05],
        image: nil,
        description:
          gettext(
            "Professional website for psychologist Bruna Caroline with online and in-person psychotherapy services."
          ),
        full_description:
          gettext(
            "Professional website developed for psychologist Bruna Caroline, offering online and in-person psychotherapy services. A modern, responsive single-page application built with React and Vite, deployed on Vercel."
          ),
        url: "https://brunacaroline.com.br",
        github: nil,
        tech: [
          %{name: "React", logo: "react.dev"},
          %{name: "Vite", logo: "vite.dev"},
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "mario-artur",
        name: "Mario Artur",
        date: ~D[2026-03-04],
        image: "/images/marioartur.png",
        description:
          gettext(
            "Landing page for football player Mario Artur with player profile and career info."
          ),
        full_description:
          gettext(
            "Landing page developed for football player Mario Artur (Lateral / Meio Campista). A modern, responsive single-page application built with React and Vite, featuring the player's profile, career highlights, and contact information."
          ),
        url: "https://marioartur.com",
        github: nil,
        tech: [
          %{name: "React", logo: "react.dev"},
          %{name: "Vite", logo: "vite.dev"},
          %{name: "JavaScript", logo: "javascript.dev.br"}
        ]
      },
      %{
        id: "tarefinhas",
        name: "Tarefinhas",
        date: ~D[2026-02-14],
        image: "/images/tarefinhas.png",
        description:
          gettext(
            "Mobile task management app with custom categories, filters, and confetti celebrations."
          ),
        full_description:
          gettext(
            "Tarefinhas is a mobile task management app for Android, designed to organize tasks in a simple and fun way. Built with React Native and Expo, it features custom categories, task filtering, and confetti celebrations for completed tasks."
          ),
        url: "https://tarefinhas.frankferreira.com.br",
        github: nil,
        tech: [
          %{name: "React Native", logo: "reactnative.dev"},
          %{name: "Expo", logo: "expo.dev"},
          %{name: "TypeScript", logo: "typescriptlang.org"}
        ]
      },
      %{
        id: "agenda-letiva",
        name: "Agenda Letiva",
        date: ~D[2025-12-01],
        image: "/images/agendaletiva.png",
        highlight: true,
        description:
          gettext(
            "School management platform for student assessments, grades, and academic scheduling."
          ),
        full_description:
          gettext(
            "School management platform developed for Agenda Letiva, providing tools for managing student assessments, grades, and academic scheduling. Built with Elixir, Phoenix, and LiveView, offering a real-time, responsive interface for educators and administrators."
          ),
        url: "https://agendaletiva.com.br",
        github: nil,
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"},
          %{name: "LiveView", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "voce-decide",
        name: "VoceDecide",
        date: ~D[2024-12-03],
        image: nil,
        description:
          gettext("Real-time interactive voting app for live presentations and talks."),
        full_description:
          gettext(
            "VoceDecide is a real-time interactive voting application designed for live presentations and talks. Built with Elixir, Phoenix, and LiveView, it allows the audience to vote and decide what happens next during a presentation."
          ),
        url: "https://voce-decide.fly.dev",
        github: "https://github.com/franknfjr/voce_decide",
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"},
          %{name: "LiveView", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "voter-system",
        name: gettext("Voter Intentions System"),
        date: ~D[2024-08-07],
        image: nil,
        description: gettext("Platform for collecting and analyzing voter preference data."),
        full_description:
          gettext(
            "The Voter Intentions System is a digital platform designed to facilitate the collection and analysis of data related to voters' preferences in a specific political context."
          ),
        url: nil,
        github: nil,
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "mdown-ex",
        name: "Mdown_ex",
        date: ~D[2023-09-15],
        image: nil,
        description: gettext("Converts Markdown files to HTML and Livebook using Elixir."),
        full_description:
          gettext(
            "The Markdown in Elixir project converts Markdown files to HTML and Livebook using the Elixir language, leveraging its efficiency and scalability. It provides a flexible solution for developers to format text quickly and effectively in various online and data development contexts."
          ),
        url: "https://github.com/franknfjr/md2livemd",
        github: "https://github.com/franknfjr/md2livemd",
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"}
        ]
      },
      %{
        id: "healthcare",
        name: gettext("Healthcare"),
        date: ~D[2019-12-01],
        image: nil,
        description:
          gettext("Dashboard for patient appointments, medications, and hospital indicators."),
        full_description:
          gettext(
            "The 'Healthcare' app provides a comprehensive overview of patient appointments, medications, phone calls, surgeries, financial transactions, and other relevant data, offering healthcare professionals a detailed insight into daily hospital indicators for better management and decision-making."
          ),
        url: nil,
        github: nil,
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"},
          %{name: "LiveView", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "cdn",
        name: "CDN",
        date: ~D[2019-08-01],
        image: nil,
        description: gettext("Internal content delivery network for file management."),
        full_description:
          gettext(
            "The CDN (Content Delivery Network) system developed in Elixir was initially designed for internal file management. Using the Elixir language, the system offered an efficient and scalable solution to manage content distribution, optimizing access and file delivery across a network."
          ),
        url: nil,
        github: nil,
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"}
        ]
      },
      %{
        id: "elixir-phoenix",
        name: gettext("Introduction to Elixir and Phoenix"),
        date: ~D[2018-06-25],
        image: nil,
        description:
          gettext("Educational repository for Elixir and Phoenix mini-course at UFRA."),
        full_description:
          gettext(
            "Repository for the Elixir and Phoenix mini-course, provided by the Applied Computing Laboratory at UFRA, functioning as a central repository for educational materials tailored to students and tech enthusiasts keen on exploring the dynamic realms of Elixir and Phoenix development."
          ),
        url: "https://github.com/franknfjr/elixir-phoenix",
        github: "https://github.com/franknfjr/elixir-phoenix",
        tech: [
          %{name: "Elixir", logo: "elixir-lang.org"},
          %{name: "Phoenix", logo: "phoenixframework.org"}
        ]
      },
      %{
        id: "irrisusten",
        name: gettext("IrriSusten"),
        date: ~D[2018-04-29],
        image: "/images/irrisusten.png",
        description:
          gettext(
            "Information system to manage plantation irrigation with web and mobile interfaces."
          ),
        full_description:
          gettext(
            "The study introduces Irrisusten, an information system to manage plantation irrigation. It automates agricultural production control and reduces water wastage. It features web and mobile interfaces, utilizing physical components like Arduino Uno, sensors, relays, and Bluetooth modules."
          ),
        url: "https://sol.sbc.org.br/index.php/wcama/article/view/2941",
        github: "https://github.com/franknfjr/irrisusten",
        tech: [
          %{name: "Arduino", logo: "arduino.cc"},
          %{name: "Sensors", logo: "sensortechcanada.com"},
          %{name: "Bluetooth", logo: "bluetooth.com"}
        ]
      }
    ]
  end

  @doc """
  Projects for the home page "Recently shipped" strip.

  Any project flagged `highlight: true` is pinned first (that is the 🔥 launch),
  and the remaining slots are filled with the most recently dated projects.
  """
  def featured(limit \\ 3) do
    {pinned, rest} = Enum.split_with(list(), &(&1[:highlight] == true))
    rest = Enum.sort_by(rest, & &1.date, {:desc, Date})

    (pinned ++ rest)
    |> Enum.uniq_by(& &1.id)
    |> Enum.take(limit)
  end
end
