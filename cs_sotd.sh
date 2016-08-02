#!/bin/bash

# This script aims at downloading and compile all the packages needed to build Amelif

# -----------------------------------------------------
# -- Please customize this part to adapt to your setup.
# -----------------------------------------------------
export PATH=$PATH:/C/code/pkg-config_0.23-3_win32/bin/

# --  SoT PATHS
# Mandatory infomations
if [ -d '/C/Windows' ]; then
	export SOT_ROOT=/C/code/install/roboptimd
	export SOURCE_DIR=/C/code/software/roboptim
	export OS_build_rep=_duild
fi

# export GENERATE_DOC=OFF


export BOOST_ROOT=/C/code/install/boost_1_59_0
# export EIGEN3_INCLUDE_DIR=/C/install/eigen/include/eigen3/
export BLAS_ROOT=/C/code/install/


export PKG_CONFIG_PATH=$PKG_CONFIG_PATH";C:\code\install\roboptimd\lib\pkgconfig"
# export PKG_CONFIG_PATH=$PKG_CONFIG_PATH";C:/code\install\log4cxx\lib\pkgconfig"
# export PKG_CONFIG_PATH=$PKG_CONFIG_PATH";C:/code\install\libtool-1.5.26-bin\lib\pkgconfig"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH";C:\code\install\Ipopt-3.11.3\lib\pkgconfig"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH";C:/code\install\eigen\lib\pkgconfig"

# -----------------------------------------------------
# -- End of the customization part
# -----------------------------------------------------

###########################################
PREV_PWD=`pwd`

cd   $PREV_PWD
./packages_base.sh    $@ debug
