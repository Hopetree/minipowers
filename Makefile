.PHONY: help install install-all list uninstall

CLAUDE_SKILLS := $(HOME)/.claude/skills
SOURCE_DIR := skills

# Default target
help:
	@echo "Minipowers — Skills Plugin"
	@echo ""
	@echo "Usage:"
	@echo "  make install SKILL=<name>    Install a specific skill"
	@echo "  make install-all             Install all skills"
	@echo "  make uninstall SKILL=<name>  Remove a specific skill"
	@echo "  make list                    List available skills"
	@echo ""
	@echo "Examples:"
	@echo "  make install SKILL=git-conventions"
	@echo "  make install SKILL=review-and-sync"
	@echo ""
	@echo "Target directory: $(CLAUDE_SKILLS)"

# Install a single skill
install:
	@if [ -z "$(SKILL)" ]; then \
		echo "Error: SKILL argument required. Usage: make install SKILL=<name>"; \
		echo ""; \
		echo "Available skills:"; \
		$(MAKE) list; \
		exit 1; \
	fi
	@if [ ! -d "$(SOURCE_DIR)/$(SKILL)" ]; then \
		echo "Error: skill '$(SKILL)' not found in $(SOURCE_DIR)/"; \
		echo ""; \
		$(MAKE) list; \
		exit 1; \
	fi
	@echo "Installing $(SKILL)..."
	@rm -rf "$(CLAUDE_SKILLS)/$(SKILL)"
	@cp -r "$(SOURCE_DIR)/$(SKILL)" "$(CLAUDE_SKILLS)/$(SKILL)"
	@echo "✅ $(SKILL) installed to $(CLAUDE_SKILLS)/$(SKILL)"

# Install all skills
install-all:
	@for dir in $(SOURCE_DIR)/*/; do \
		name=$$(basename "$$dir"); \
		echo "Installing $$name..."; \
		rm -rf "$(CLAUDE_SKILLS)/$$name"; \
		cp -r "$$dir" "$(CLAUDE_SKILLS)/$$name"; \
	done
	@echo ""
	@echo "✅ All skills installed to $(CLAUDE_SKILLS)"

# Uninstall a single skill
uninstall:
	@if [ -z "$(SKILL)" ]; then \
		echo "Error: SKILL argument required. Usage: make uninstall SKILL=<name>"; \
		exit 1; \
	fi
	@if [ -d "$(CLAUDE_SKILLS)/$(SKILL)" ]; then \
		rm -rf "$(CLAUDE_SKILLS)/$(SKILL)"; \
		echo "✅ $(SKILL) removed from $(CLAUDE_SKILLS)"; \
	else \
		echo "$(SKILL) is not installed."; \
	fi

# List available skills
list:
	@echo "Available:"
	@for dir in $(SOURCE_DIR)/*/; do \
		name=$$(basename "$$dir"); \
		installed=""; \
		if [ -d "$(CLAUDE_SKILLS)/$$name" ]; then \
			installed="  ✅ installed"; \
		fi; \
		echo "  $$name$$installed"; \
	done
