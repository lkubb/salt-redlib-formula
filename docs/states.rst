Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``redlib``
^^^^^^^^^^
*Meta-state*.

This installs the redlib containers,
manages their configuration and starts their services.


``redlib.package``
^^^^^^^^^^^^^^^^^^
Installs the redlib containers only.
This includes creating systemd service units.


``redlib.config``
^^^^^^^^^^^^^^^^^
Manages the configuration of the redlib containers.
Has a dependency on `redlib.package`_.


``redlib.service``
^^^^^^^^^^^^^^^^^^
Starts the redlib container services
and enables them at boot time.
Has a dependency on `redlib.config`_.


``redlib.clean``
^^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``redlib`` meta-state
in reverse order, i.e. stops the redlib services,
removes their configuration and then removes their containers.


``redlib.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the redlib containers
and the corresponding user account and service units.
Has a depency on `redlib.config.clean`_.
If ``remove_all_data_for_sure`` was set, also removes all data.


``redlib.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the redlib containers
and has a dependency on `redlib.service.clean`_.

This does not lead to the containers/services being rebuilt
and thus differs from the usual behavior.


``redlib.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Stops the redlib container services
and disables them at boot time.


