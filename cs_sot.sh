#!/bin/bash

# This script aims at downloading and compile all the packages needed to build Amelif

# -----------------------------------------------------
# -- Please customize this part to adapt to your setup.
# -----------------------------------------------------
export PATH=$PATH:/C/code/pkg-config_0.23-3_win32/bin/
# --  SoT PATHS
# Mandatory infomations
if [ -d '/C/Windows' ]; then
	export SOT_ROOT=/C/code/install/roboptim
	export SOURCE_DIR=/C/code/software/roboptim
	export OS_build_rep=_build
else
	if [ $LETS_GO_PYTHON -eq 1 ]; then
	    export SOT_ROOT=/Users/François/Documents/devel/SoT-python
    else
	    export SOT_ROOT=/Users/François/Documents/devel/SoT
	fi;
    export SOURCE_DIR=/Users/François/Documents/devel-src/Sot/
fi


export BOOST_ROOT=/C/code/install/boost_1_59_0
export BLAS_ROOT=/C/code/install/

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH";C:\code\install\roboptim\lib\pkgconfig"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH";C:\code\install\Ipopt-3.11.3\lib\pkgconfig"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH";C:\code\install\eigen\lib\pkgconfig"

# -----------------------------------------------------
# -- End of the customization part
# -----------------------------------------------------

###########################################
PREV_PWD=`pwd`

cd 	$PREV_PWD
./packages_base.sh    $@
