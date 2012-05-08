#!/bin/bash -e
MAKE_OPT="-j 2" 
PREFIX="${HOME}/local" # <-- where to install files

echo "Will download, build and install into PREFIX=$PREFIX (edit this script to change this)"
mkdir -p $PREFIX
mkdir -p other-software ; cd other-software # change DIR
echo "Using proxy settings (if nothing here or not correct then install e.g. TOR and set up http_proxy=http://127.0.0.1:8123 all_proxy=socks://127.0.0.1:9050/ https_proxy=https://127.0.0.1:8123 no_proxy=localhost,127.0.0.0/8 or similar, with export in .bashrc or alike shell setup"
set -x
env | grep -i proxy

function title() {
	echo "---------------------------------------------------------------"
	echo -- $*
	echo "---------------------------------------------------------------"
}

function dir_for_lib() {
	title "$1" ; echo "Dir for lib $1" ;	dir="$1" ; rm -rf "$1" ; mkdir "$1"
	cd "$1" # DIR change!
}

function get_http() {
	echo "Get http: $*" ; url1=$1 ; fname=$2 ; url=$1$2 
	wget $url && echo "Downloaded"
}

function start_lib_no_download() {
	dir_for_lib "$1"
}

function start_lib() {
	dir_for_lib "$1" ; shift ; get_http $*
}

function install_openssl() {
	start_lib openssl "http://www.openssl.org/source/" "openssl-1.0.0d.tar.gz" "c273e884ad8d342c334c3a25dc63a790061e23e0df0c240e57c09535f49ce3da0d061792473b6953ca06c9e868832e108935ceb9512381cff1e4a58e7c0704af"
	gunzip openssl-1.0.0d.tar.gz ; tar -xf openssl-1.0.0d.tar ; cd openssl-1.0.0d
	./config  -m64 shared  --prefix=${PREFIX}
	make  # -j is buggy here
	make install
}

function install_msgpack {
	start_lib msgpack "http://msgpack.org/releases/cpp/" "msgpack-0.5.7.tar.gz" "66a1c55b1acee3b13c8ec76f234ae81a0a854789611a17bd32e3bf8004718a65e943569a2038b1f2b3e45aefaf52155391a717c855097aabafed7b20075a1a67"
	gunzip msgpack-0.5.7.tar.gz ; tar -xf msgpack-0.5.7.tar ;	cd msgpack-0.5.7/
	./configure --prefix=${PREFIX}
	make $MAKE_OPT ; make install
}

function install_protobuf {
	start_lib "protobuf" "http://protobuf.googlecode.com/files/" "protobuf-2.4.1.tar.gz" "f38c6e7ab79115472ce2c8e8bcccb09e38364e3e6bd183c6b01857adde69fd2b5cf0aecc93edf008c9b3354784ae77bfbad60057e9305d0815458926e9d5f321"
	gunzip protobuf-2.4.1.tar.gz ; tar -xf protobuf-2.4.1.tar ; cd protobuf-2.4.1/
	./configure --prefix=${PREFIX} ; make $MAKE_OPT ; make install
}

function install_zeromq {
	start_lib "zeromq" "http://download.zeromq.org/" "zeromq-2.2.0.tar.gz" "e1e61eabfbc059e03ebc34ef8395fb8666a26aa377c89f5c8785e4f43cfb2b522ac203d0aa130602a9cc7578b730b65db69447e2ba293fd3c17528f8fbd5bc97"
	gunzip zeromq-2.2.0.tar.gz ;	tar -xf zeromq-2.2.0.tar ; 	cd zeromq-2.2.0/ ;	./configure --prefix=${PREFIX}
	make $MAKE_OPT ; make install
}

function install_chaiscript {
	start_lib_no_download "chaiscript" 
	# TODO point to a fixed git revision of chaiscript
	# the version used was: 41b0c7768c74d73f6510f5f92df875b27b71abae
	
# "https://github.com/downloads/ChaiScript/ChaiScript/" "chaiscript-3.1.0-Source.tar.bz2" "6b70678b4dcfb98b204ed3b78f4ce067780803edb019ebe967142686efed662981474bb9489ed6955d2f950d6116e80fedfccdc9d0660d795ef6d5adbc1981a5"
#	bunzip2 chaiscript-3.1.0-Source.tar.bz2 
#	tar -xf chaiscript-3.1.0-Source.tar 
#	cd chaiscript-3.1.0-Source/

	git clone https://github.com/ChaiScript/ChaiScript/ ; cd ChaiScript

	cmake -DCMAKE_INSTALL_PREFIX:PATH=${PREFIX} ; make ; make install
}

( install_openssl )
( install_msgpack )
( install_protobuf )
( install_zeromq )
( install_chaiscript )


