#!/bin/bash
. ./common_sot.sh

# Go to root.
if ! [ -d ${SOURCE_DIR} ]; then mkdir ${SOURCE_DIR};fi
if ! [ -d ${SOURCE_DIR} ]; then echo 'the folder \"'${SOURCE_DIR}'\" does not exist. Please create it';exit;fi

cd ${SOURCE_DIR}


inst_array[index]="install_pkg log4cxxWin32/cmake  git://github.com/gergondet"
let "index= $index + 1"

inst_array[index]="install_pkg ltdl-win32  git://github.com/gergondet"
let "index= $index + 1"

inst_array[index]="install_pkg roboptim-core  git://github.com/roboptim"
# inst_array[index]="install_pkg roboptim-core git://github.com/francois-keith"
# inst_array[index]="install_pkg rc git://github.com/francois-keith"
let "index= $index + 1"

# inst_array[index]="install_pkg roboptim-core-python git://github.com/roboptim"
# let "index= $index + 1"

# inst_array[index]="install_pkg roboptim-core-manifold git://github.com/roboptim"
# let "index= $index + 1"

# inst_array[index]="install_pkg roboptim-analysis git://github.com/roboptim"
# let "index= $index + 1"

# inst_array[index]="install_pkg roboptim-core-plugin-ipopt git://github.com/roboptim"
# let "index= $index + 1"

inst_array[index]="install_pkg roboptim-core-plugin-eigen git://github.com/roboptim"
let "index= $index + 1"

# inst_array[index]="install_pkg qhull https://github.com/qhull/"
# let "index= $index + 1"

# inst_array[index]="install_pkg roboptim-capsule git://github.com/roboptim"
# let "index= $index + 1"


# # # inst_array[index]="install_pkg roboptim-core-plugin-qpoases git://github.com/roboptim"
# # # let "index= $index + 1"

# inst_array[index]="install_pkg roboptim-trajectory git://github.com/roboptim"
# let "index= $index + 1"

# inst_array[index]="install_pkg roboptim-tutorial git://github.com/roboptim"
# let "index= $index + 1"


# inst_array[index]="install_pkg plop"
# let "index= $index + 1"


install_pkg()
{
  GitHandling   $@
  BuildHandling $@
}

install_level=$1

run_instructions()
{
  echo "run instructions from $install_level to ${#inst_array[@]}"
  for ((lindex=$install_level; lindex<${#inst_array[@]} ; lindex++ ))
  do
      echo
      echo "Eval ("$lindex"):" ${inst_array[$lindex]}
      ${inst_array[$lindex]}
  done
}

run_instructions
exit 0

