ifeq ($(V),1)
  Q =
else
  Q = @
endif

TEST_FLAGS=

PHONY=

PHONY+=shell
shell:
	$(Q)yarn dev

PHONY+=test
test:
	$(Q)yarn test $(TEST_FLAGS)

.PHONY: $(PHONY)