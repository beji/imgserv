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
#     config :imgserv_web, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:imgserv_web, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :imgserv_web,
  swarm_sup: ImgservWorker.WorkerSupervisor,
  # :redis, :ets, :none
  cache_type: :ets,
  cors_allowed: "*",
  cache_ttl: 10

config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]

config :logger, :console, metadata: [:request_id, :module, :line]


# config :peerage,
#   via: Peerage.Via.List,
#   node_list: [
#     :"web@127.0.0.1",
#     :"worker1@127.0.0.1",
#     :"worker2@127.0.0.1",
#     :"worker3@127.0.0.1"
#   ]

config :libcluster,
  topologies: [
    local: [
      strategy: Cluster.Strategy.Epmd,
      # config: [hosts: [:"web@127.0.0.1", :"worker1@127.0.0.1", :"worker2@127.0.0.1", :"worker3@127.0.0.1"]],
      config: [hosts: [:"web@127.0.0.1", :"db@127.0.0.1"]]
    ]
  ]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
