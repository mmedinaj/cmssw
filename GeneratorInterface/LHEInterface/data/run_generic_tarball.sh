#!/bin/bash

#script to run generic lhe generation tarballs
#kept as simply as possible to minimize need
#to update the cmssw release
#(all the logic goes in the run script inside the tarball
# on frontier)
#J.Bendavid

echo "   ______________________________________     "
echo "         Running Generic Tarball/Gridpack     "
echo "   ______________________________________     "

repo=${1}
echo "%MSG-MG5 repository = $repo"

name=${2} 
echo "%MSG-MG5 gridpack = $name"

nevt=${3}
echo "%MSG-MG5 number of events requested = $nevt"

rnum=${4}
echo "%MSG-MG5 random seed used for the run = $rnum"

LHEWORKDIR=`pwd`

if [[ -d lheevent ]]
    then
    echo 'lheevent directory found'
    echo 'Setting up the environment'
    rm -rf lheevent
fi
mkdir lheevent; cd lheevent

# retrieve the wanted gridpack from the official repository 
fn-fileget -c `cmsGetFnConnect frontier://smallfiles` ${repo}/${name}_tarball.tar.gz 

#check the structure of the tarball
tar xzf ${name}_tarball.tar.gz ; rm -f ${name}_tarball.tar.gz ;

#generate events (call for 1 core always for now until hooks to set number of cores are implemented upstream)
./runcmsgrid.sh $nevt $rnum 1

mv cmsgrid_final.lhe $LHEWORKDIR/${name}_final.lhe

cd $LHEWORKDIR

#cleanup working directory (save space on worker node for edm output)
rm -rf lheevent

exit 0

