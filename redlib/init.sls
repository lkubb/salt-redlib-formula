# vim: ft=sls

{#-
    *Meta-state*.

    This installs the redlib containers,
    manages their configuration and starts their services.
#}

include:
  - .package
  - .config
  - .service
