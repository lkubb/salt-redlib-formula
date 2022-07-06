# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as libreddit with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Libreddit user account is present:
  user.present:
{%- for param, val in libreddit.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ libreddit.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Libreddit user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ libreddit.lookup.user.name }}
    - enable: {{ libreddit.install.rootless }}

Libreddit paths are present:
  file.directory:
    - names:
      - {{ libreddit.lookup.paths.base }}
    - user: {{ libreddit.lookup.user.name }}
    - group: {{ libreddit.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ libreddit.lookup.user.name }}

Libreddit compose file is managed:
  file.managed:
    - name: {{ libreddit.lookup.paths.compose }}
    - source: {{ files_switch(['docker-compose.yml', 'docker-compose.yml.j2'],
                              lookup='Libreddit compose file is present'
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ libreddit.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        libreddit: {{ libreddit | json }}

Libreddit is installed:
  compose.installed:
    - name: {{ libreddit.lookup.paths.compose }}
{%- for param, val in libreddit.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in libreddit.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ libreddit.lookup.paths.compose }}
{%- if libreddit.install.rootless %}
    - user: {{ libreddit.lookup.user.name }}
    - require:
      - user: {{ libreddit.lookup.user.name }}
{%- endif %}