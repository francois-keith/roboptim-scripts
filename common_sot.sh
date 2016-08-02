#!/bin/bash

###########################################
if [ "$0" = "./DefaultCompilationScript.sh" ] || [ "$0" = "./DefaultCompilationScript" ]; then 
	echo 'This is the default script file. It should not be modified.'
	echo 'Thus, please copy it, then customize and run the copy'
	exit 1
fi

## Compilation option
if [ -d '/C/Windows' ]; then
	echo 'You are running under Windows'
	export OS_is_windows=1
	export MAKE=nmake
else
	export OS_is_windows=0
	export OS_build_rep=ubuild
	export MAKE=make
fi

# # Deal with options
# while getopts ":chlmour:" option; do
  # case "$option" in
    # h)  # it's always useful to provide some help
        # usage_message
        # exit 0
        # ;;
    # l)  DISPLAY_LIST_INSTRUCTIONS=1
        # ;;

    # c)  REMOVE_CMAKECACHE=1
		# ;;

    # m)  COMPILE_PACKAGE=1
        # UPDATE_PACKAGE=0
        # ;;
    # o)  COMPILE_PACKAGE=1
        # LOG_PACKAGE=1
        # UPDATE_PACKAGE=0
        # ;;
    # u)  COMPILE_PACKAGE=0
        # UPDATE_PACKAGE=1
        # ;;
    # r)  ROS_VERSION=$OPTARG
        # ;;
    # :)  warn "Error: -$option requires an argument"
        # usage_message
        # exit 1
        # ;;
    # ?)  warn "Error: unknown option -$option"
        # usage_message
        # exit 1
        # ;;
  # esac
# done
# shift $(($OPTIND-1))



## -- Git functions

# Variables
export gpull=0
export gpush=0
export gdiff=0
export gtag=0
export gbranch=0
export glog=0
export gsave=0
export greset=0

# Arg1: a repository folder on the local machine.
# Arg2: the distant repository url.
#
# This function tests whether the local repository exists. If it
# exists, the function pulls. Else it clones the distant repo.
function pull_package()
{
	if [ -d $1 ];  then
		echo
		echo "--- pull package "$1" ---"
		echo
		
		PREV_PWD=`pwd`
		cd $1
		git pull
		v=$?
		if ! [ $v -eq 0 ];  then
			echo "ERROR: Failure on pull " $1
			cd $PREV_PWD
			exit -1
    fi
		git submodule update
		cd $PREV_PWD
	else
		echo git clone --recursive $2 $1 
		git clone --recursive $2 $1
	fi
}

# Arg1: a repository folder on the local machine.
#
# This function tests whether the local repository exists. If it
# exists, the function pushes all branches.
function push_package()
{
	echo '   PushPackage ' $1
	if ! [ -d $1 ];  then
		echo '   The directory ' $1 ' does not exists ' 
	else
		echo
		echo "--- push package "$1" ---"
		echo
		
		PREV_PWD=`pwd`
		cd $1
		git push

		v=$?
		if ! [ $v -eq 0 ];  then
			echo "ERROR: Failure on cmake " $1
			cd $PREV_PWD
			exit -1
	    fi
		cd $PREV_PWD
	fi
}

# Arg1: a repository folder on the local machine.
#
# This function diffs a repository.
function diff_package()
{
	echo
	echo "--- diff package "$1" ---"
	echo
	
	if ! [ -d $1 ];  then
		echo "ERROR: The directory '"$1"' does not exist."
	else
		PREV_PWD=`pwd`
		cd $1
		git diff
		if [ -d cmake ]; then
			cd cmake
			git diff
			cd ../
		fi
		cd $PREV_PWD
	fi
}

# Arg1: a repository folder on the local machine.
#
# This function tags a repository.
function tag_package()
{
	echo
	echo "--- tag package "$1" ---"
	echo
	
	if ! [ -d $1 ];  then
		echo "ERROR: The directory '"$1"' does not exist."
	else
		PREV_PWD=`pwd`
		cd $1
		git tag -f LWV
		cd $PREV_PWD
	fi
}

# Arg1: a repository folder on the local machine.
#
# This function diffs a repository.
function branch_package()
{
	echo
	echo "--- diff package "$1" ---"
	echo
	
	if ! [ -d $1 ];  then
		echo "ERROR: The directory '"$1"' does not exist."
	else
		PREV_PWD=`pwd`
		cd $1
		git branch
	#	if [ -d cmake ]; then
	#		cd cmake
	#		git branch
	#		cd ../
	#	fi
		cd $PREV_PWD
	fi
}

# Arg1: a repository folder on the local machine.
#
# This function diffs a repository.
function reset_package()
{
	echo
	echo "--- reset package "$1" ---"
	echo
	
	if ! [ -d $1 ];  then
		echo "ERROR: The directory '"$1"' does not exist."
	else
		PREV_PWD=`pwd`
		cd $1
		git reset --hard
		cd cmake
		git reset --hard
		cd $PREV_PWD
	fi
}

# Arg1: a repository folder on the local machine.
#
# This function displays the lof of a repository
function log_package()
{
	echo
	echo "--- Log package "$1" ---"
	echo
	
	if ! [ -d $1 ];  then
		echo "ERROR: The directory '"$1"' does not exist."
	else
		PREV_PWD=`pwd`
		cd $1
		echo $1
		git branch
		git log -n 1 --pretty=oneline
		cd $PREV_PWD
	fi
}

# Arg1: a repository folder on the local machine.
# Arg2: ABSOLUTE PATH of the log file
#
# This function saves the log of a repository in $2
function save_log_package()
{
	echo
	echo "--- Save log package "$1" ---"
	echo
	
	if ! [ -d $1 ];  then
		echo "ERROR: The directory '"$1"' does not exist."
	else
		PREV_PWD=`pwd`
		cd $1
		echo $1 >> $2
		git log -n 1 --pretty=oneline >> $2
		echo '' >> $2
		cd $PREV_PWD
	fi
}

function GitHandling () 
{
  echo ---     $2/$1   ---
  if [ $gpull -eq 1 ];  then   pull_package $1 $2/$1 ; fi
  if [ $gdiff -eq 1 ];  then   diff_package $1 ;fi
  if [ $gtag  -eq 1 ];  then   tag_package $1 ;fi
  if [ $gbranch -eq 1 ]; then branch_package $1; fi
  if [ $gpush -eq 1 ];  then   push_package $1 ;fi
  if [ $glog  -eq 1 ];  then   log_package  $1 ;fi
  if [ $gsave -eq 1 ];  then   save_log_package $1 $log_filename;fi
  if [ $greset -eq 1 ];  then  reset_package $1 ;fi
}

## -- Build functions

# variables
export BuildRelease=0 # build in release
export BuildDebug=0 # build in debug
export rmcache=0  # remove cmake's cache
export rebuild=0  # rebuild the package
export mclean=0   # remove cmake's cache and rebuild the package

export build=0
export eclip=0
export vsbld=0
export vsbld_80=0
export vsbld_90=0
export gtest=0

# Arg1: a repository folder on the local machine.
# Arg2: the building mode: release, debug (...)
#
# This function tests whether the local repository exists. If it
# exists, the function cleans the packages in the given build mode (release or debug).
# Else it prints an error message.
function clean_package()
{
	echo
	echo "--- clean package "$1" ---"
	echo
	
	if ! [ -d $1 ];  then
		echo "ERROR: The directory '"$1"' does not exist."
		return 1
	fi
	
	PREV_PWD=`pwd`
	
	cd $1    
	if ! [ -d $OS_build_rep ];  then 
		cd $PREV_PWD
		return; 
	fi;
	
	cd $OS_build_rep; 
  
	if [ -d $2 ];  then
		cd $2
				
		rm -f CMakeCache.txt
		$MAKE -s clean
		v=$?
		if ! [ $v -eq 0 ];  then 
			echo "ERROR: Failure on trying to clean the " $2 " folder of " $1
			cd $PREV_PWD
		fi
	fi
	
	cd $PREV_PWD
}

# Arg1: a repository folder on the local machine.
# Arg2: the building mode: release, debug (...)
#
# This function tests whether the local repository exists. If it
# exists, the function builds the package. Else it prints an error
# message.
function build_package() 
{
	echo
	echo "--- build package "$1"  (building mode: "$2") ---"
	echo
	if ! [ -d $1 ];  then
		echo '   The directory ' $1 ' does not exists ' 
		return 1
	fi;

	PREV_PWD=`pwd`
	
    cd $1
    
	if ! [ -d $OS_build_rep ];  then  
		mkdir $OS_build_rep; 
	fi; 	
	cd $OS_build_rep;
	
	if ! [ -d $2 ];   then  mkdir $2;   fi;
	cd $2;
	
	if [ $rmcache -eq 1 ]; then
		echo 
		echo "1.#INFO: removing the cache"
		rm -f CMakeCache.txt
	fi

	if [ $OS_is_windows -eq 1 ]; then
		cmake -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=$2 -DCMAKE_INSTALL_PREFIX=${SOT_ROOT} -DGENERATE_DOC=${GENERATE_DOC} -DCXX_DISABLE_WERROR=1   ../..
	    v=$?
	else	
		cmake -DCMAKE_BUILD_TYPE=$2 -DCMAKE_INSTALL_PREFIX=${SOT_ROOT} -DSMALLMATRIX="jrl-mathtools" -DHRP2_MODEL_DIRECTORY="${HRP2_MODEL_DIRECTORY}"  -DHRP2_CONFIG_DIRECTORY="${HRP2_CONFIG_DIRECTORY}"   -DBoostNumericBindings_INCLUDE_DIR="${BOOST_SANDBOX}" -DUSE_COLLISION=OFF -DGENERATE_DOC=${GENERATE_DOC}  -DCXX_DISABLE_WERROR=1 ../..
		v=$?
    fi

	v=$?
	if ! [ $v -eq 0 ];  then
		echo "ERROR: Failure on cmake " $1
		cd $PREV_PWD
		exit -1
    fi 
	
  	if [ $rebuild -eq 1 ];  then
		echo
		echo "1.#INFO: forcing rebuild"
		echo
		$MAKE -s clean
		v=$?
		if ! [ $v -eq 0 ];  then 
			echo "ERROR: Failure on trying to clean " $1 " for rebuild"
		fi
	fi
	
	
    ${MAKE} -s install 
    v=$?
    if ! [ $v -eq 0 ];  then 
		echo "ERROR: Failure on trying to install " $1
		cd $PREV_PWD
		exit -1
    fi
	
	cd $PREV_PWD
}

# function testg() {
    # echo
    # echo "--- build package "$1"  (building mode: "$2") ---"
    # echo
    # if ! [ -d $1 ];  then
        # echo '   The directory ' $1 ' does not exists '
        # return 1
    # fi;

    # PREV_PWD=`pwd`
   
    # cd $1
   
    # if ! [ -d $OS_build_rep ];  then 
        # mkdir $OS_build_rep;
    # fi;    
    # cd $OS_build_rep;
   
    # if ! [ -d $2 ];   then  mkdir $2;   fi;
    # cd $2;
   
    # # test
    # if [ -d /Users/ ]; then 
	    # export DYLD_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$DYLD_LIBRARY_PATH	    
    # else
	    # export PATH_OLD=$PATH;
	    # export PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$BOOST_ROOT/lib/:$PATH
	    # export PATH=/C/Users/François/code/Libraries/log4cxx/lib:$PATH
		# export PATH=/C/Users/François/code/Libraries/libtool-1.5.26-bin/bin:$PATH
    # fi;
    # ctest -E experimental
    # if ! [ -d /Users/ ]; then 
    	# export PATH=$PATH_OLD;
    # fi;
    # # end test

    # cd $PREV_PWD
# }



function testg() {
    echo
    echo "--- build package "$1"  (building mode: "$2") ---"
    echo
    if ! [ -d $1 ];  then
        echo '   The directory ' $1 ' does not exists '
        return 1
    fi;

    PREV_PWD=`pwd`
   
    cd $1
    # OS_build_rep=_v14-64
    if ! [ -d $OS_build_rep ];  then 
        mkdir $OS_build_rep;
    fi;    
    cd $OS_build_rep;
   
    if ! [ -d $2 ];   then  mkdir $2;   fi;
    cd $2;
   
    # test
    if [ -d /Users/ ]; then 
      export DYLD_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$DYLD_LIBRARY_PATH      
    else
      # export LD_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$LD_LIBRARY_PATH      
      # export DL_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$DL_LIBRARY_PATH
      export LTDL_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$LTDL_LIBRARY_PATH      
      export LTLD_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$LTLD_LIBRARY_PATH      
      # export LD_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$LD_LIBRARY_PATH      
      # export DL_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$DL_LIBRARY_PATH
      export LTDL_LIBRARY_PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/roboptim-core:$SOT_ROOT/lib/plugin/:$LTDL_LIBRARY_PATH        
      echo $LTDL_LIBRARY_PATH
      
      export PATH_OLD=$PATH;
      export PYTHONPATH=$SOT_ROOT/lib/python2.7/site-packages:$PYTHONPATH
      export PATH=`pwd`/src:$SOT_ROOT/lib:$SOT_ROOT/lib/plugin/:$BOOST_ROOT/lib/:$PATH
      export PATH=`pwd`/src/RelWithDebInfo:$PATH
      export PATH=`pwd`/src/Release:$PATH
      # export PATH="C:/code/install/Ipopt-3.11.3/lib":$PATH

      export PATH=/C/code/install/log4cxx/lib:$PATH
      export PATH=$SOT_ROOT/bin:$PATH
      export PATH=/C/code/install/libtool-1.5.26-bin/bin:$PATH
    fi;
    ctest -C $2
    if ! [ $? -eq 0 ];  then
			echo "ERROR: Failure on ctest " $1
			cd $PREV_PWD
			exit -1
    fi


    if ! [ -d /Users/ ]; then 
      export PATH=$PATH_OLD;
    fi;
    
    # end test

    cd $PREV_PWD
}

function ebuild() {
    echo
    echo "--- Create Eclipse project for "$1"  (building mode: "$2") ---"
    echo
    
    PREV_PWD=`pwd`

  if ! [ -d $1 ];  then
    echo '   The directory ' $1 ' does not exists ' 
  else
  	# Creating the project *outside* the src repository
	if ! [ -d ${SOURCE_DIR}/eclipse/ ];  then 
		mkdir ${SOURCE_DIR}/eclipse/		
	fi
	cd ${SOURCE_DIR}/eclipse/
	
	#creating the folder corresponding to the current project
	if ! [ -d $1 ];  then mkdir $1; fi
    cd $1
    
	if ! [ -d $2 ];   then  mkdir $2;   fi;
	cd $2;
	pwd

	if [ $rmcache -eq 1 ]; then
		echo 
		echo "1.#INFO: removing the cache"
		rm -f CMakeCache.txt
	fi
	
	cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=$2 -DSOT_ROOT=${SOT_ROOT} -DCMAKE_INSTALL_PREFIX=${SOT_ROOT} -DGENERATE_DOC=${GENERATE_DOC} ${SOURCE_DIR}/$1
	v=$?
    if [ ! $v ];  then
      echo "Failure on cmake " $1
      exit -1
    fi 
    cd $PREV_PWD
  fi
}

function vsbuild_80() {
	echo
	echo "--- Create Visual Studio 14 2005 project for "$1"  (building mode: "$2") ---"
	echo
	
	if ! [ -d $1 ];  then
		echo '   The directory ' $1 ' does not exists ' 
		return 1
	fi
	
	PREV_PWD=`pwd`

    cd $1
    if ! [ -d _v14-64 ];  then	mkdir _v14-64;	fi;	cd _v14-64

	if ! [ -d $2 ];   then  mkdir $2;   fi;
	cd $2;

	if [ $rmcache -eq 1 ]; then
		echo 
		echo "1.#INFO: removing the cache"
		rm -f CMakeCache.txt
	fi
	
	cmake -G"Visual Studio 14 Win64" -DCMAKE_INSTALL_PREFIX=${SOT_ROOT} -DCMAKE_BUILD_TYPE=$2 ../..

	v=$?
    # if ! [ $v -eq 0 ];  then
      # echo "Failure on cmake " $1
	  # cd $PREV_PWD
      # exit -1
    # fi 
    cd $PREV_PWD
}

function vsbuild_90() {
	echo
	echo "--- Create Visual Studio 9 2008 project for "$1"  (building mode: "$2") ---"
	echo

	if ! [ -d $1 ];  then
		echo '   The directory ' $1 ' does not exists ' 
		return;
	fi

	PREV_PWD=`pwd`

    cd $1
    if ! [ -d vsbld_90 ];  then	mkdir vsbld_90;	fi; cd vsbld_90

	if ! [ -d $2 ];   then  mkdir $2;   fi;
	cd $2;

	if [ $rmcache -eq 1 ]; then
		echo 
		echo "1.#INFO: removing the cache"
		rm -f CMakeCache.txt
	fi
    
	cmake -G"Visual Studio 9 2008" -DCMAKE_BUILD_TYPE=$2 -DCMAKE_INSTALL_PREFIX=${SOT_ROOT} -DSMALLMATRIX="jrl-mathtools" -DHRP2_MODEL_DIRECTORY=${HRP2_MODEL_DIRECTORY}  -DHRP2_CONFIG_DIRECTORY=${HRP2_CONFIG_DIRECTORY}   -DBoostNumericBindings_INCLUDE_DIR=${BOOST_SANDBOX} -DUSE_COLLISION=OFF -DGENERATE_DOC=${GENERATE_DOC} -DEIGEN3_INCLUDE_DIR=${EIGEN3_INCLUDE_DIR} ../..

	v=$?
    if ! [ $v -eq 0 ];  then
		echo "Failure on cmake " $1
		cd $PREV_PWD
		exit -1
    fi 
	cd $PREV_PWD
}

function BuildHandling () 
{
    export mode=RELEASE
    if [ $BuildRelease -eq 1 ];	then  export mode=RELEASE;fi
    if [ $BuildDebug -eq 1 ];	then  export mode=Debug;fi
    if [ $mclean -eq 1 ];	then   	clean_package   $1 $mode;fi
    if [ $eclip -eq 1 ];	then	ebuild          $1 $mode;fi
    if [ $vsbld_80 -eq 1 ];	then	vsbuild_80      $1 $mode;fi
    if [ $vsbld_90 -eq 1 ];	then	vsbuild_90      $1 $mode;fi
    if [ $build -eq 1 ];	then   	build_package   $1 $mode;fi
    if [ $gtest -eq 1 ];	then   	testg   $1 $mode;fi
}

# Guess what this function does.
function print_help() {
 echo "This script allow performing operation on all the packages belonging to the amelif project, namely:
	Core:		amelif, CMakeModules, afscripts
	Plugins:	afstate-pkg, afscene-pkg, afglut-pkg, af7coll-pkg,  af7dyn-pkg
	MainPrograms:	aftuto-pgm, af7coll-pgm, af7dyn-pgm, af7tuto-pgm
	
  Options available: 
  -git options :
pull	Pull or clone (if nec.) all packages (git pull / clone)
push	Push all packages (git push)
diff	Apply git diff on all packages
log		Display the last commit log of all packages

  -build options :
rmcache		Remove the cmake cache

build		Build and install all packages using make/nmake (in Package_Name/ubuild or Package_Name/wbuild)
rebuild		Force rebuild

vsbld_80	Create the Visual studio 8 2005 project for all packages (in Package_Name/vsbld_80)
vsbld_90	Create the Visual studio 9 2008 project for all packages (in Package_Name/vsbld_90)
eclipse		Create the eclipse project for all packages (in Package_Name/ebuild)

clean		Clean the build directory (= rmcache + make clean)

help 	Display this help
*    	Pull and build all packages using make/nmake (resp. unix/win32)"
}


###########################################
#####  What do you want to do ?

if ! [ $#  -ne 1 ]; then
	 export gpull=1;
	 export build=1;
fi

for ARG in $@
do
	case $ARG in
	# git options
	pull)
		echo "Pull only"
		export gpull=1
	;;
	push)
		echo "Push only"
		export gpush=1
	;;
	tag)
		echo "Tag"
		export gtag=1
	;;
	diff)
		echo "Diff only"
		export gdiff=1
	;;
	branch)
		echo "Branch"
		export gbranch=1
	;;
	log)
		echo "Current logs of the packages"
		export glog=1
	;; 
	save)
		echo "Save current state"
		export gsave=1
	;; 
	reset_hard)
		echo "Reset hard"
		export greset=1
	;;

	# compilation options
	clean)
		echo "Clean solutions"
		export mclean=1
		export rmcache=1
	;;
	build)
		echo "Build only"
		export build=1
		;;
	eclipse)
		echo "Construct the project for eclipse"
		export eclip=1
	;;
	mbuild)
		echo "Please precise the version of Visual Studio you want to use:"
		echo " vsbld_80 for Visual Studio 8 2005"
		echo " vsbld_90 for Visual Studio 9 2008"
	;; 
	vsbld)
		echo "Please precise the version of Visual Studio you want to use:"
		echo " vsbld_80 for Visual Studio 8 2005"
		echo " vsbld_90 for Visual Studio 9 2008"
	;; 
	vsbld_80)
		echo "Construct the project for Visual Studio 8 2005"
		export vsbld_80=1
	;;
	vsbld_90)
		echo "Construct the project for Visual Studio 9 2008"
		export vsbld_90=1
	;;
	test)
		echo "Testing the projects"
		export gtest=1
	;;

	help)
		print_help
		exit
		;;
	rmcache)
		if [ $build -eq 1 ] || [ $vsbld_80 -eq 1 ] || [ $vsbld_90 -eq 1 ]; then
			export rmcache=1
			fi
		;;
	rebuild)
		if [ $build -eq 1 ] || [ $vsbld_80 -eq 1 ] || [ $vsbld_90 -eq 1 ]; then
			export rebuild=1
		fi
		;;
	release)
		echo "Compilation in Release mode"
		export BuildRelease=1
		export BuildDebug=0
		;;
	debug)
		echo "Compilation in Debug mode"
		export BuildRelease=0
		export BuildDebug=1
		;;
	*)
		echo "unknown option " $ARG
		;;
	esac
done

# This script assumes that a ssh-agent is working.

###########################################
#####  Back to business

