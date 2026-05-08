PLUGIN_NAME  := zellij-autoname-pane
TARGET       := wasm32-wasip1
WASM         := target/$(TARGET)/release/$(PLUGIN_NAME).wasm
INSTALL_DIR  := $(HOME)/.config/zellij/plugins
INSTALL_PATH := $(INSTALL_DIR)/$(PLUGIN_NAME).wasm
LAYOUT_DIR   := $(HOME)/.config/zellij/layouts
LAYOUT_PATH  := $(LAYOUT_DIR)/default.kdl

.PHONY: build install update clean reload layout help

help:
	@echo "Targets:"
	@echo "  build    Build the release WASM artifact"
	@echo "  install  Copy the WASM into $(INSTALL_DIR)"
	@echo "  update   build + install (rebuild and replace the installed plugin)"
	@echo "  reload   Same as update; restart your Zellij session to pick it up"
	@echo "  layout   Add the plugin pane to $(LAYOUT_PATH)"
	@echo "  clean    cargo clean"

build:
	cargo build --release --target $(TARGET)

install: build
	mkdir -p $(INSTALL_DIR)
	cp $(WASM) $(INSTALL_PATH)
	@echo "Installed to $(INSTALL_PATH)"

update: install

reload: update

layout:
	@mkdir -p $(LAYOUT_DIR)
	@if [ -f $(LAYOUT_PATH) ] && grep -q "$(PLUGIN_NAME).wasm" $(LAYOUT_PATH); then \
		echo "$(LAYOUT_PATH) already references $(PLUGIN_NAME).wasm — nothing to do."; \
		exit 0; \
	fi
	@if [ ! -f $(LAYOUT_PATH) ]; then \
		printf 'Create %s with the plugin pane? [y/N] ' "$(LAYOUT_PATH)"; \
		read ans; \
		case "$$ans" in \
			y|Y|yes|YES) \
				printf 'layout {\n    pane\n    pane size=1 borderless=true {\n        plugin location="file:%s"\n    }\n}\n' "$(INSTALL_PATH)" > $(LAYOUT_PATH); \
				echo "Wrote $(LAYOUT_PATH)"; \
				;; \
			*) echo "Aborted."; exit 1;; \
		esac; \
	else \
		echo "$(LAYOUT_PATH) exists. Add this pane as a sibling of your top-level panes:"; \
		echo ""; \
		echo "    pane size=1 borderless=true {"; \
		echo "        plugin location=\"file:$(INSTALL_PATH)\""; \
		echo "    }"; \
		echo ""; \
		printf 'Append a NEW default-layout snippet next to it as %s.autoname-pane.kdl? [y/N] ' "$(LAYOUT_PATH)"; \
		read ans; \
		case "$$ans" in \
			y|Y|yes|YES) \
				printf 'layout {\n    pane\n    pane size=1 borderless=true {\n        plugin location="file:%s"\n    }\n}\n' "$(INSTALL_PATH)" > $(LAYOUT_PATH).autoname-pane.kdl; \
				echo "Wrote $(LAYOUT_PATH).autoname-pane.kdl (merge it into your default.kdl manually)."; \
				;; \
			*) echo "No file written.";; \
		esac; \
	fi

clean:
	cargo clean
