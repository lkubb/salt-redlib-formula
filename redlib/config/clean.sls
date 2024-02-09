# vim: ft=sls

{#-
    Removes the configuration of the redlib containers
    and has a dependency on `redlib.service.clean`_.

    This does not lead to the containers/services being rebuilt
    and thus differs from the usual behavior.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redlib with context %}

include:
  - {{ sls_service_clean }}

Redlib environment files are absent:
  file.absent:
    - names:
      - {{ redlib.lookup.paths.config_redlib }}
      - {{ salt["file.dirname"](redlib.lookup.paths.compose) | path_join("seccomp-redlib.json") }}
    - require:
      - sls: {{ sls_service_clean }}
