elem_sources = [
  'camera.vala',
  'level.vala',
  'player.vala',
  'primitives.vala',
  'world.vala',
]

elem_app_sources = [
  'main.vala',
  'menu.vala',
]

elem_lib = library('elements', elem_sources,
  dependencies: elem_deps,
   vala_header: 'elements.h',
       install: false,
)

executable('elements', elem_sources + elem_app_sources,
       install: true,
  dependencies: elem_deps,
)

elem = declare_dependency(include_directories: include_directories('.'),
  link_with: elem_lib,
)
