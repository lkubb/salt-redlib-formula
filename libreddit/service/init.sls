# vim: ft=sls

{#-
    Starts the libreddit container services
    and enables them at boot time.
    Has a dependency on `libreddit.config`_.
#}

include:
  - .running
