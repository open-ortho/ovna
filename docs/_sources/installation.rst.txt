Prima installazione
===================

Devi creare due symlink dopo aver fatto il deploy, prima che tutto funzioni.

Devi creare una cartella dove fare il deploy di tutto quello che c'e' qua
dentro, con i permessi dell'utente che ha accesso al server. Imposta anche un
gruppo, caso mai servisse aggiungere altri utenti.

.. code-block:: shell

    groupadd orthanc
    mkdir /usr/local/lib/orthanc
    chgrp orthanc /usr/local/lib/orthanc
    chmod g+rwxs orthanc/
    setfacl -Rdm g:orthanc:rwx orthanc
    ln -s /usr/local/lib/orthanc/etc/docker-compose-orthanc.service /etc/systemd/system/docker-compose-orthanc.service
    ln -s /usr/local/lib/orthanc/bin/db_backup.sh /etc/cron.hourly/orthanc-index-backup

Configurazione Reverse Proxy
----------------------------

La reverse proxy e' NGINX e si configura via WEB con `nginx-proxy-manager
<https://nginxproxymanager.com>`_, un docker. L'interfaccia di configurazione è
la 81 e user/pass di default sono

.. code-block:: shell

    admin@example.com/changeme

Una volta entrati nella configurazione, dovrai creare un utente, e impostare il
reverse proxy a mano. Sarà sufficiente creare un proxy di protocollo http a
host orthanc su porta ``8042``.

Configurazione iniziale certificati SSL
---------------------------------------

I certificati SSL si configurano plug and play, pero' per l'autenticazione o la
verifica, bisogna che la porta ``80`` sia aperta su internet per il FQDN in
questione.

Se il FQDN risolve ad un indirizzo IP pubblico, ci sono queste opzioni.

I certificati e il DB del gestore della reverse proxy si troveranno nella
cartella ``/usr/local/lib/orthanc/etc/letsencrypt`` dell host docker.

Pacs su IP pubblico
^^^^^^^^^^^^^^^^^^^

Tieni il PACS su IP pubblico, e abilita il loopback sul router. In questo caso,
bisogna assicurarsi di chiudere tutto al massimo, crittografia su tutto, incluso
Q/R su 104, eccetera. 

Altro svantaggio di questo e' che potrebbe aumentare il carico sul router,
siccome tutto il traffico verrebbe routato dal router.

Pacs su IP privato 1
^^^^^^^^^^^^^^^^^^^^

Modificare il FQDN su DNS pubblica temporaneamente per ottenere il certificato,
poi ripristina a quello privato. Tieni chiuse tutte le porte esterne sul router.

Questa opzione funziona, ma richiede la necessita' di dover intervenire ogni
volta che bisogna rinnovare il certificato, aprendo porta su router, e cambiando
indirizzo su DNS.

Indaginoso, con cadute di servizio al momento di scadenza certificati.

Pacs su IP privato 2
^^^^^^^^^^^^^^^^^^^^

1. Monta DNS interna
2. Imposta record DNS interno uguale a quello su DNS pubblica, ma con indirizzo IP interno.
3. Obbliga tutte le workstation ad utilizzare la tua DNS interna
4. Apri porta 80 per rinnovo dei certificati.

Un servizio in piu' da gestire, ma probabilmente la situazione piu' stabile a minor costo.

Certificati auto-generati/firmati
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

1. Creati il tuo CA e firmati i tuoi certificati.
2. Prova ad aggiungerli alle workstation, oppure aggiungi eccezioni.

Indaginoso, probabilmente non stabile.

Acquistare certificati SSL
^^^^^^^^^^^^^^^^^^^^^^^^^^

Configurazione indaginosa iniziale, pero' una volta fatto, e' fatto. Dovrebbero
costare sui 15EUR/anno.
