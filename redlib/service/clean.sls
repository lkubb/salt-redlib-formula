# vim: ft=sls

{#-
    Stops the redlib container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redlib with context %}

redlib service is dead:
  compose.dead:
    - name: {{ redlib.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if redlib.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ redlib.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if redlib.install.rootless %}
    - user: {{ redlib.lookup.user.name }}
{%- endif %}

redlib service is disabled:
  compose.disabled:
    - name: {{ redlib.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if redlib.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ redlib.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if redlib.install.rootless %}
    - user: {{ redlib.lookup.user.name }}
{%- endif %}
