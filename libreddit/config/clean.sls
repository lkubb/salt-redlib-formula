# vim: ft=sls

{#-
    Removes the configuration of the libreddit containers
    and has a dependency on `libreddit.service.clean`_.

    This does not lead to the containers/services being rebuilt
    and thus differs from the usual behavior.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as libreddit with context %}

include:
  - {{ sls_service_clean }}

Libreddit environment files are absent:
  file.absent:
    - names:
      - {{ libreddit.lookup.paths.config_libreddit }}
    - require:
      - sls: {{ sls_service_clean }}
