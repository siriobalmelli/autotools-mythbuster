XSLTPROC = xsltproc

XSL-NS-SS = http://docbook.sourceforge.net/release/xsl-ns/current/

all: public/index.html public/stylesheets/mythbuster.css

public/index.html: main.docbook $(wildcard *.xmli) $(wildcard examples/*) stylesheets/mythbuster.xsl
	$(XSLTPROC) \
		--xinclude \
		--stringparam base.dir public/ \
		--stringparam chunk.toc chunk.toc \
		--stringparam section.autolabel 1 \
		--stringparam collect.xref.targets "yes" \
		--stringparam toc.section.depth 1 \
		--stringparam targets.filename "$(patsubst %.xhtml,%.olinkdb,$@)" \
		--stringparam html.stylesheet stylesheets/mythbuster.css \
		--stringparam suppress.navigation 1 \
		stylesheets/mythbuster.xsl \
		$<

chunk.toc.new:
	$(XSLTPROC) \
		--output $@ \
		--xinclude \
		--stringparam chunk.section.depth 8 \
		--stringparam chunk.first.sections 1 \
		--stringparam use.id.as.filename 1 \
		$(XSL-NS-SS)/xhtml-1_1/maketoc.xsl \
		main.docbook

public/stylesheets/mythbuster.css: stylesheets/mythbuster.scss
	mkdir -p $(dir $@)
	scss -t compressed $< $@

clean:
	rm -f *~ *.olinkdb
	find public -name '*.html' -delete

.PHONY: generate chunk.toc.new clean

