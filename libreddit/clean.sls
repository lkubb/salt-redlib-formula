# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``libreddit`` meta-state
    in reverse order, i.e. stops the libreddit services,
    removes their configuration and then removes their containers.
#}

include:
  - .service.clean
  - .config.clean
  - .package.clean
