# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as libreddit with context %}

include:
  - {{ sls_config_file }}

Libreddit service is enabled:
  compose.enabled:
    - name: {{ libreddit.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if libreddit.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ libreddit.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Libreddit is installed
{%- if libreddit.install.rootless %}
    - user: {{ libreddit.lookup.user.name }}
{%- endif %}

Libreddit service is running:
  compose.running:
    - name: {{ libreddit.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if libreddit.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ libreddit.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if libreddit.install.rootless %}
    - user: {{ libreddit.lookup.user.name }}
{%- endif %}
    - watch:
      - Libreddit is installed
