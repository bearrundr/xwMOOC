## ========================================
## Commands for both workshop and lesson websites.

# Settings
MAKEFILES=Makefile $(wildcard *.mk)
JEKYLL=jekyll
DST=_site

# Controls
.PHONY : commands clean files
all : commands

## commands       : show all commands.
commands :
	@grep -h -E '^##' ${MAKEFILES} | sed -e 's/## //g'

## serve          : run a local server.
serve :
	${JEKYLL} serve --config _config.yml,_config_dev.yml

## site           : build files but do not run a server.
site :
	${JEKYLL} build --config _config.yml,_config_dev.yml

## clean          : clean up junk files.
clean :
	@rm -rf ${DST}
	@rm -rf .sass-cache
	@find . -name .DS_Store -exec rm {} \;
	@find . -name '*~' -exec rm {} \;
	@find . -name '*.pyc' -exec rm {} \;
	@find . -name __pycache__ -exec rm {} \;

## ----------------------------------------
## Commands specific to workshop websites.

.PHONY : workshop-check

## workshop-check : check workshop homepage.
workshop-check :
	bin/workshop-check index.html

## ----------------------------------------
## Commands specific to lesson websites.

.PHONY : lesson-check lesson-files lesson-fixme lesson-single

# Lesson source files in the order they appear in the navigation menu.
SRC_FILES = \
  index.md \
  CONDUCT.md \
  setup.md \
  $(wildcard _episodes/*.md) \
  reference.md \
  $(wildcard _extras/*.md) \
  LICENSE.md

# Generated lesson files in the order they appear in the navigation menu.
HTML_FILES = \
  ${DST}/index.html \
  ${DST}/conduct/index.html \
  ${DST}/setup/index.html \
  $(patsubst _episodes/%.md,${DST}/%/index.html,$(wildcard _episodes/*.md)) \
  ${DST}/reference/index.html \
  $(patsubst _extras/%.md,${DST}/%/index.html,$(wildcard _extras/*.md)) \
  ${DST}/license/index.html

## lesson-check   : validate lesson Markdown.
lesson-check :
	bin/lesson-check -s . -p bin/markdown-ast.rb

## lesson-files   : show expected names of generated files for debugging.
lesson-files :
	@echo 'source:' ${SRC_FILES}
	@echo 'generated:' ${HTML_FILES}

## lesson-fixme   : show FIXME markers embedded in source files.
lesson-fixme :
	@fgrep -i -n FIXME ${SRC_FILES} || true

#-------------------------------------------------------------------------------
# Include extra commands if available.
#-------------------------------------------------------------------------------

-include commands.mk
