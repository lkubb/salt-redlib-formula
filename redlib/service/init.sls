# vim: ft=sls

{#-
    Starts the redlib container services
    and enables them at boot time.
    Has a dependency on `redlib.config`_.
#}

include:
  - .running
