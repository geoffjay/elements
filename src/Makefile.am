#SUBDIRS = lib

bin_PROGRAMS = elements

VALAFLAGS = \
	-H $(srcdir)/libelements.h -C -c --thread \
	--vapidir=$(srcdir)/../vapi -X -g \
	@VALA_PACKAGES@ --pkg config

elements_CFLAGS = \
	-DPACKAGE_DATA_DIR=\""$(datadir)"\" \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	@PACKAGE_CFLAGS@ \
	$(AM_CFLAGS) \
	$(GLIB_CFLAGS) \
	$(GEE_CFLAGS) \
	$(GSL_CFLAGS) \
	$(SDL_CFLAGS) \
	$(XML_CFLAGS)

elements_LDADD = \
	@PACKAGE_LIBS@ \
	$(GLIB_LIBS) \
	$(GEE_LIBS) \
	$(GSL_LIBS) \
	$(SDL_LIBS) \
	$(XML_LIBS)

elements_headers = \
	common.h \
	elements.h \
	libelements.h

elements_SOURCES = \
	main.vala

CLEANFILES = \
	*.stamp \
	stamp-h1 \
	$(srcdir)/libelements.h
