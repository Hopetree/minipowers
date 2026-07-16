.PHONY: help install install-all list uninstall

CLAUDE_SKILLS := $(HOME)/.claude/skills
SOURCE_DIR := skills

# Catch-all for skill name arguments — does nothing on its own
%:
	@:

# Default target
help:
	@echo "Minipowers — Skills Plugin"
	@echo ""
	@echo "Usage:"
	@echo "  make install <name>          Install a specific skill"
	@echo "  make install-all             Install all skills"
	@echo "  make uninstall <name>        Remove a specific skill"
	@echo "  make list                    List available skills"
	@echo ""
	@echo "Examples:"
	@echo "  make install git-conventions"
	@echo "  make install review-and-sync"
	@echo "  make uninstall git-conventions"
	@echo ""
	@echo "Target directory: $(CLAUDE_SKILLS)"

# Install a specific skill: make install <name>
install:
	@skill="$(filter-out $@,$(MAKECMDGOALS))"; \
	if [ -z "$$skill" ]; then \
		echo "Error: skill name required. Usage: make install <name>"; \
		echo ""; \
		$(MAKE) list; \
		exit 1; \
	fi; \
	if [ ! -d "$(SOURCE_DIR)/$$skill" ]; then \
		echo "Error: skill '$$skill' not found in $(SOURCE_DIR)/"; \
		echo ""; \
		$(MAKE) list; \
		exit 1; \
	fi; \
	echo "Installing $$skill..."; \
	rm -rf "$(CLAUDE_SKILLS)/$$skill"; \
	cp -r "$(SOURCE_DIR)/$$skill" "$(CLAUDE_SKILLS)/$$skill"; \
	echo "✅ $$skill installed to $(CLAUDE_SKILLS)/$$skill"

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

# Remove a specific skill: make uninstall <name>
uninstall:
	@skill="$(filter-out $@,$(MAKECMDGOALS))"; \
	if [ -z "$$skill" ]; then \
		echo "Error: skill name required. Usage: make uninstall <name>"; \
		exit 1; \
	fi; \
	if [ -d "$(CLAUDE_SKILLS)/$$skill" ]; then \
		rm -rf "$(CLAUDE_SKILLS)/$$skill"; \
		echo "✅ $$skill removed from $(CLAUDE_SKILLS)"; \
	else \
		echo "$$skill is not installed."; \
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
