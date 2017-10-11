project('elements', [ 'c', 'vala' ],
          license: 'GPL3+',
          version: '0.1.0',
    meson_version: '>= 0.40.1',
  default_options: [
                     'c_std=gnu11',
                     'warning_level=2',
                   ],
)

version_split = meson.project_version().split('.')
MAJOR_VERSION = version_split[0]
MINOR_VERSION = version_split[1]
MICRO_VERSION = version_split[2]

status = [
  '', '',
  'Elements @0@'.format(meson.project_version()),
  '', '',
]

# Warning message
if (version_split[1].to_int() % 2 == 1)
  status += [
    'You are building a debug version of Elements. There may be more bugs in',
    'this version that you are comfortable with.',
    '', ''
  ]
endif

status += [
  'Version ............................... : @0@'.format(meson.project_version()),
  'Build Type ............................ : @0@'.format(get_option('buildtype')),
  '',
  'Prefix ................................ : @0@'.format(get_option('prefix')),
  'Libdir ................................ : @0@'.format(join_paths(get_option('prefix'), get_option('libdir'))),
  '', ''
]

add_project_arguments([
  ['-I' + join_paths(meson.current_source_dir(), 'vapi')]
], language: 'c')

add_project_arguments([
  ['--vapidir', join_paths(meson.current_source_dir(), 'vapi')],
  ['--pkg', 'config'],
], language: 'vala')

dep_glib = dependency('glib-2.0')
dep_gobject = dependency('gobject-2.0')
dep_gio = dependency('gio-2.0')
dep_gee = dependency('gee-0.8')
dep_json = dependency('json-glib-1.0')
dep_posix = meson.get_compiler('vala').find_library('posix')

elem_deps = [
  dep_glib,
  dep_gobject,
  dep_gio,
  dep_gee,
  dep_json,
  dep_posix,
]

# Substitutions for various .in files
subst = configuration_data()

# Installation paths
pkg_datadir = join_paths(get_option('prefix'), get_option('datadir'), meson.project_name())
pkg_sysconfdir = join_paths(get_option('sysconfdir'), meson.project_name())

subst.set('bindir', join_paths(get_option('prefix'), get_option('bindir')))
subst.set('datadir', pkg_datadir)
subst.set('sysconfdir', pkg_sysconfdir)

# Create config.h
conf = configuration_data()

conf.set_quoted('PACKAGE_NAME', meson.project_name())
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('PACKAGE_STRING', '@0@-@1@'.format(meson.project_name(), meson.project_version()))

# For i18n
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())

# Write config.h
configure_file(
         output: 'config.h',
  configuration: conf,
)

gnome = import('gnome')

subdir('src')
subdir('data')
subdir('tests')

message('\n'.join(status))
