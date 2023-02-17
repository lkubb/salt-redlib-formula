# vim: ft=sls


{#-
    Stops the libreddit container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as libreddit with context %}

libreddit service is dead:
  compose.dead:
    - name: {{ libreddit.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if libreddit.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ libreddit.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if libreddit.install.rootless %}
    - user: {{ libreddit.lookup.user.name }}
{%- endif %}

libreddit service is disabled:
  compose.disabled:
    - name: {{ libreddit.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if libreddit.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ libreddit.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if libreddit.install.rootless %}
    - user: {{ libreddit.lookup.user.name }}
{%- endif %}
