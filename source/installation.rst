First Installation
===================


# Create a minimal debian Installation
# Download latest release from https://api.github.com/repos/open-ortho/ovena/tarball
# Unpack
# Run ``./ovena-install.sh``

.. code-block:: shell

    curl --output ovena.tgz -L "https://api.github.com/repos/open-ortho/ovena/tarball"

    # Unpack and run install script
    tar zxvf ./ovena.tgz
    cd ovena
    ./ovena-install.sh 
