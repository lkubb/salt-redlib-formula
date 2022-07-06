# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as libreddit with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Libreddit environment files are managed:
  file.managed:
    - names:
      - {{ libreddit.lookup.paths.config_libreddit }}:
        - source: {{ files_switch(['libreddit.env', 'libreddit.env.j2'],
                                  lookup='libreddit environment file is managed',
                                  indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ libreddit.lookup.user.name }}
    - makedirs: True
    - template: jinja
    - require:
      - user: {{ libreddit.lookup.user.name }}
    - watch_in:
      - Libreddit is installed
    - context:
        libreddit: {{ libreddit | json }}
