#!/bin/bash -e

localdir=${HOME}/local/

make test_wallet php5 install LOCAL_INCLUDEDIRS=-I${localdir}include LOCAL_LIBDIRS=-L${localdir}lib EXECUTABLE_INSTALL_FOLDER=${localdir}bin LIBRARY_INSTALL_FOLDER=${localdir} DYNAMIC_OTLIB=1 && (
echo ""
echo ""
echo "Done - builded for use in local dir=${localdir}" 
echo "Remember to do:   export LD_LIBRARY_PATH=${localdir}lib   before running binaries created in ${localdir}bin like ot_server or ot (client) there."
echo ""
echo ""
)
