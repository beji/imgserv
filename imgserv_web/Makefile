ifeq ($(V),1)
  Q =
else
  Q = @
endif

PHONY=
NAME=web
HOST=127.0.0.1

PHONY+=shell
shell:
	$(Q)iex --name $(NAME)@$(HOST) -S mix

PHONY+=subprocess
subprocess:
	$(Q)elixir --name $(NAME)@$(HOST) -S mix run --no-halt

PHONY+=redis
redis:
	$(Q)docker-compose up -d

PHONY+=redis_stop
redis_stop:
	$(Q)docker-compose stop
	$(Q)docker-compose rm -f

.PHONY: $(PHONY)