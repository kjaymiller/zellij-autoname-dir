PLUGIN_NAME := zellij-autoname-pane
TARGET      := wasm32-wasip1
WASM        := target/$(TARGET)/release/$(PLUGIN_NAME).wasm
INSTALL_DIR := $(HOME)/.config/zellij/plugins
INSTALL_PATH := $(INSTALL_DIR)/$(PLUGIN_NAME).wasm

.PHONY: build install update clean reload help

help:
	@echo "Targets:"
	@echo "  build    Build the release WASM artifact"
	@echo "  install  Copy the WASM into $(INSTALL_DIR)"
	@echo "  update   build + install (rebuild and replace the installed plugin)"
	@echo "  reload   Same as update; restart your Zellij session to pick it up"
	@echo "  clean    cargo clean"

build:
	cargo build --release --target $(TARGET)

install: build
	mkdir -p $(INSTALL_DIR)
	cp $(WASM) $(INSTALL_PATH)
	@echo "Installed to $(INSTALL_PATH)"

update: install

reload: update

clean:
	cargo clean
