SUBDIRS = \
	config \
	icons

desktopdir = $(datadir)/applications
desktop_in_files = elements.desktop.in
desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)

CLEANFILES = \
	$(desktop_DATA)

EXTRA_DIST = \
	$(desktop_in_files)
