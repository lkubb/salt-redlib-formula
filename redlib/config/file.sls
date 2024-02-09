# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redlib with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Redlib environment files are managed:
  file.managed:
    - names:
      - {{ redlib.lookup.paths.config_redlib }}:
        - source: {{ files_switch(
                        ["redlib.env", "redlib.env.j2"],
                        config=redlib,
                        lookup="redlib environment file is managed",
                        indent_width=10,
                     )
                  }}
      - {{ salt["file.dirname"](redlib.lookup.paths.compose) | path_join("seccomp-redlib.json") }}:
        - source: {{ files_switch(
                        ["seccomp-redlib.json"],
                        config=redlib,
                        lookup="redlib seccomp file is managed",
                        indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ redlib.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ redlib.lookup.user.name }}
    - require_in:
      - Redlib is installed
    - context:
        redlib: {{ redlib | json }}
