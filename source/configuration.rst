Configuration
=============

Ovena configurations are in :code:`/etc`. 


Chainging IP Address or hostname
--------------------------------

This is a Debian distribution, and you can follow Debian procedures to change IP address and hostname.

The recommended use of ovena is to use two NICs or LANs, one for administration (ssh), the other for the orthanc services. When doing so, this requires to explicitly set the various services to listen to the correct IP address.

* Use :code:`hostnamectl set-hostname <newhostname>`
* Edit :code:`/etc/hosts`
* Edit :code:`/etc/ovena/docker-compose.yml` and change the :code:`ports` directives accordingly.
* Edit :code:`/etc/ssh/sshd_config` to set the `ListenAddress` with the new IP address.

Configurazione dei client
-------------------------

Per le Query Retrieve tradizionali, bisogna configurare ogni client con
indirizzo IP e AE Title che coincida qui nelle configurazioni.

Per aggiungere/rimuovere/modificare, si trova tutto in

.. code-block::

    orthanc.json