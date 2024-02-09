# vim: ft=sls

{#-
    Removes the redlib containers
    and the corresponding user account and service units.
    Has a depency on `redlib.config.clean`_.
    If ``remove_all_data_for_sure`` was set, also removes all data.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redlib with context %}

include:
  - {{ sls_config_clean }}

{%- if redlib.install.autoupdate_service %}

Podman autoupdate service is disabled for Redlib:
{%-   if redlib.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ redlib.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

Redlib is absent:
  compose.removed:
    - name: {{ redlib.lookup.paths.compose }}
    - volumes: {{ redlib.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if redlib.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ redlib.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if redlib.install.rootless %}
    - user: {{ redlib.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Redlib compose file is absent:
  file.absent:
    - name: {{ redlib.lookup.paths.compose }}
    - require:
      - Redlib is absent

{%- if redlib.install.podman_api %}

Redlib podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman.socket
    - user: {{ redlib.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ redlib.lookup.user.name }}

Redlib podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman.socket
    - user: {{ redlib.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ redlib.lookup.user.name }}
{%- endif %}

Redlib user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ redlib.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ redlib.lookup.user.name }}

Redlib user account is absent:
  user.absent:
    - name: {{ redlib.lookup.user.name }}
    - purge: {{ redlib.install.remove_all_data_for_sure }}
    - require:
      - Redlib is absent
    - retry:
        attempts: 5
        interval: 2

{%- if redlib.install.remove_all_data_for_sure %}

Redlib paths are absent:
  file.absent:
    - names:
      - {{ redlib.lookup.paths.base }}
    - require:
      - Redlib is absent
{%- endif %}
