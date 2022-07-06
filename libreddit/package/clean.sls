# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as libreddit with context %}

include:
  - {{ sls_config_clean }}

Libreddit is absent:
  compose.removed:
    - name: {{ libreddit.lookup.paths.compose }}
    - volumes: {{ libreddit.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if libreddit.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ libreddit.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if libreddit.install.rootless %}
    - user: {{ libreddit.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Libreddit compose file is absent:
  file.absent:
    - name: {{ libreddit.lookup.paths.compose }}
    - require:
      - Libreddit is absent

Libreddit user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ libreddit.lookup.user.name }}
    - enable: false

Libreddit user account is absent:
  user.absent:
    - name: {{ libreddit.lookup.user.name }}
    - purge: {{ libreddit.install.remove_all_data_for_sure }}
    - require:
      - Libreddit is absent

{%- if libreddit.install.remove_all_data_for_sure %}

Libreddit paths are absent:
  file.absent:
    - names:
      - {{ libreddit.lookup.paths.base }}
    - require:
      - Libreddit is absent
{%- endif %}
