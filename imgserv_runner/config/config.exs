# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :imgserv_runner, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:imgserv_runner, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :imgserv_runner,
  separator: "| ",
  colors: [:cyan, :yellow, :magenta, :red, :green, :blue],
  worker_config: [
    %{
      id: "imgserv_db",
      worker_id: :runner_db,
      use_wrapper: false,
      command: System.find_executable("make"),
      args: ["-C", Path.expand("../imgserv_db"), "subprocess"]
    },
    %{
      id: "imgserv_worker1",
      worker_id: :runner_worker1,
      use_wrapper: false,
      command: System.find_executable("make"),
      args: ["-C", Path.expand("../imgserv_worker"), "subprocess"]
    },
    %{
      id: "imgserv_worker2",
      worker_id: :runner_worker2,
      use_wrapper: false,
      command: System.find_executable("make"),
      args: ["-C", Path.expand("../imgserv_worker"), "subprocess2"]
    },
    %{
      id: "imgserv_worker3",
      worker_id: :runner_worker3,
      use_wrapper: false,
      command: System.find_executable("make"),
      args: ["-C", Path.expand("../imgserv_worker"), "subprocess3"]
    },
    %{
      id: "imgserv_web",
      worker_id: :runner_web,
      use_wrapper: false,
      command: System.find_executable("make"),
      args: ["-C", Path.expand("../imgserv_web"), "subprocess"]
    },
    %{
      id: "imgserv_admin",
      worker_id: :runner_admin,
      use_wrapper: true,
      command: System.find_executable("make"),
      args: ["-C", Path.expand("../imgserv_admin")]
    }
  ]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
