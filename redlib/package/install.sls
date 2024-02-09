# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redlib with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

Redlib user account is present:
  user.present:
{%- for param, val in redlib.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ redlib.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Redlib user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ redlib.lookup.user.name }}
    - enable: {{ redlib.install.rootless }}
    - require:
      - user: {{ redlib.lookup.user.name }}

Redlib paths are present:
  file.directory:
    - names:
      - {{ redlib.lookup.paths.base }}
    - user: {{ redlib.lookup.user.name }}
    - group: {{ redlib.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ redlib.lookup.user.name }}

{%- if redlib.install.podman_api %}

Redlib podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
    - user: {{ redlib.lookup.user.name }}
    - require:
      - Redlib user session is initialized at boot

Redlib podman API is available:
  compose.systemd_service_running:
    - name: podman.socket
    - user: {{ redlib.lookup.user.name }}
    - require:
      - Redlib user session is initialized at boot
{%- endif %}

Redlib compose file is managed:
  file.managed:
    - name: {{ redlib.lookup.paths.compose }}
    - source: {{ files_switch(
                    ["docker-compose.yml", "docker-compose.yml.j2"],
                    config=redlib,
                    lookup="Redlib compose file is present",
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ redlib.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - makedirs: true
    - context:
        redlib: {{ redlib | json }}

Redlib is installed:
  compose.installed:
    - name: {{ redlib.lookup.paths.compose }}
{%- for param, val in redlib.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in redlib.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ redlib.lookup.paths.compose }}
{%- if redlib.install.rootless %}
    - user: {{ redlib.lookup.user.name }}
    - require:
      - user: {{ redlib.lookup.user.name }}
{%- endif %}

{%- if redlib.install.autoupdate_service is not none %}

Podman autoupdate service is managed for Redlib:
{%-   if redlib.install.rootless %}
  compose.systemd_service_{{ "enabled" if redlib.install.autoupdate_service else "disabled" }}:
    - user: {{ redlib.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if redlib.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
