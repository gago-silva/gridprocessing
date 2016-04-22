#!/bin/sh

#variables to customize:
GISDBASE=$HOME/local_data/grassdata
GISBASE=/usr/local/grass54
MAP=$1
LOCATION=$2

#nothing to change below:
if [ $# -lt 2 ] ; then
 echo "Script to create a new LOCATION from a raster data set"
 echo "Usage:"
 echo "   create_location.sh rasterfile location_name"
 echo "Edited by UNOSAT, February 2008"
 exit 1
fi

#generate temporary LOCATION:
TEMPDIR=$$.tmp
mkdir -p $GISDBASE/$TEMPDIR/temp

#save existing $HOME/.grassrc5
if test -e $HOME/.grassrc54 ; then
   mv $HOME/.grassrc54 /tmp/$TEMPDIR.grassrc54
fi

#
echo "LOCATION_NAME: $TEMPDIR"  >  $HOME/.grassrc54
echo "MAPSET: temp"             >> $HOME/.grassrc54
echo "DIGITIZER: none"          >> $HOME/.grassrc54
echo "GISDBASE: $GISDBASE"      >> $HOME/.grassrc54

export GISBASE=$GISBASE
export GISRC=$HOME/.grassrc54
export PATH=$PATH:$GISBASE/scripts:$GISBASE/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GISBASE/lib


# import raster map into new location:
r.in.gdal -e -o -k in=$MAP out=$MAP location=$LOCATION
if [ $? -eq 1 ] ; then
  echo "An error occured. Stop."
  exit 1
fi

echo temp


#clean up temporary directory
rmdir $GISDBASE/$TEMPDIR/temp/
rmdir $GISDBASE/$TEMPDIR/

#restore saved $HOME/.grassrc5
if test -f /tmp/$TEMPDIR.grassrc5 ; then
   mv /tmp/$TEMPDIR.grassrc5 $HOME/.grassrc5
fi

echo "Success!"



