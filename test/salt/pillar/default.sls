# -*- coding: utf-8 -*-
# vim: ft=yaml
---
libreddit:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: libreddit
      remove_orphans: true
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/libreddit
      compose: docker-compose.yml
      config_libreddit: libreddit.env
    user:
      groups: []
      home: null
      name: libreddit
      shell: /usr/sbin/nologin
      uid: null
    containers:
      libreddit:
        image: docker.io/spikecodes/libreddit:latest
  install:
    rootless: true
    remove_all_data_for_sure: false
  config:
    autoplay_videos: false
    comment_sort: confidence
    front_page: default
    hide_hls_notification: false
    layout: card
    port: 3417
    post_sort: hot
    show_nsfw: false
    theme: system
    use_hls: false
    wide: false

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://libreddit/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   libreddit-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Libreddit environment file is managed:
      - libreddit.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
