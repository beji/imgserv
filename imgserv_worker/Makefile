ifeq ($(V),1)
  Q =
else
  Q = @
endif

PHONY=
NAME=worker
HOST=127.0.0.1

PHONY+=shell
shell:
	$(Q)iex --name $(NAME)1@$(HOST) -S mix

PHONY+=subprocess
subprocess:
	$(Q)elixir --name $(NAME)@$(HOST) -S mix run --no-halt

PHONY+=shell2
shell2:
	$(Q)iex --name $(NAME)2@$(HOST) -S mix

PHONY+=subprocess2
subprocess2:
	$(Q)elixir --name $(NAME)2@$(HOST) -S mix run --no-halt

PHONY+=shell3
shell3:
	$(Q)iex --name $(NAME)3@$(HOST) -S mix

PHONY+=subprocess3
subprocess3:
	$(Q)elixir --name $(NAME)3@$(HOST) -S mix run --no-halt

.PHONY: $(PHONY)