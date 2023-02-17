Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``libreddit``
^^^^^^^^^^^^^
*Meta-state*.

This installs the libreddit containers,
manages their configuration and starts their services.


``libreddit.package``
^^^^^^^^^^^^^^^^^^^^^
Installs the libreddit containers only.
This includes creating systemd service units.


``libreddit.config``
^^^^^^^^^^^^^^^^^^^^
Manages the configuration of the libreddit containers.
Has a dependency on `libreddit.package`_.


``libreddit.service``
^^^^^^^^^^^^^^^^^^^^^
Starts the libreddit container services
and enables them at boot time.
Has a dependency on `libreddit.config`_.


``libreddit.clean``
^^^^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``libreddit`` meta-state
in reverse order, i.e. stops the libreddit services,
removes their configuration and then removes their containers.


``libreddit.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the libreddit containers
and the corresponding user account and service units.
Has a depency on `libreddit.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``libreddit.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the libreddit containers
and has a dependency on `libreddit.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``libreddit.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the libreddit container services
and disables them at boot time.


