# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redlib with context %}

include:
  - {{ sls_config_file }}

Redlib service is enabled:
  compose.enabled:
    - name: {{ redlib.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if redlib.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ redlib.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Redlib is installed
{%- if redlib.install.rootless %}
    - user: {{ redlib.lookup.user.name }}
{%- endif %}

Redlib service is running:
  compose.running:
    - name: {{ redlib.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if redlib.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ redlib.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if redlib.install.rootless %}
    - user: {{ redlib.lookup.user.name }}
{%- endif %}
    - watch:
      - Redlib is installed
      - sls: {{ sls_config_file }}
