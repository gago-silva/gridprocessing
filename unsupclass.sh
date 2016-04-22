#!/bin/sh

#variables to customize:
GISDBASE=$HOME/local_data/grassdata
GISBASE=/usr/local/grass54

#nothing to change below:
if [ $# -lt 2 ] ; then
 echo "Unsupervised Classification using modules: i.cluster and i.maxlik"
 echo "Usage:"
 echo "   unsup.sh"
 echo "Edited by UNOSAT, February 2008"
 exit 1
fi

export GISBASE=$GISBASE
export GISRC=$HOME/.grassrc54
export PATH=$PATH:$GISBASE/scripts:$GISBASE/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GISBASE/lib

cd $HOME/local_data/

#Define map region
g.region raster=Image.tif.2 


echo "$GISDBASE/$LOCATION/$MAPSET/cell"


#Search for the necessary files to continue with calculation
eval `g.findfile element=cell mapset=PERMANENT file=Image.tif.1`
if [ ! "$file" ]
then
    echo "$file - cell file not found" 
    ok=no
fi

eval `g.findfile element=cell mapset=PERMANENT file=Image.tif.2`
if [ ! "$file" ]
then
    echo "$file - cell file not found" 
    ok=no
fi

eval `g.findfile element=cell mapset=PERMANENT file=Image.tif.3`
if [ ! "$file" ]
then
    echo "$file - cell file not found" 
    ok=no
fi

eval `g.findfile element=cell mapset=PERMANENT file=Image.tif.4`
if [ ! "$file" ]
then
    echo "$file - cell file not found" 
    ok=no
fi

eval `g.findfile element=cell mapset=PERMANENT file=Image.tif.5`
if [ ! "$file" ]
then
    echo "$file - cell file not found" 
    ok=no
fi

eval `g.findfile element=cell mapset=PERMANENT file=Image.tif.6`
if [ ! "$file" ]
then
    echo "$file - cell file not found" 
    ok=no
fi

eval `g.findfile element=cell mapset=PERMANENT file=Image.tif.7`
if [ ! "$file" ]
then
    echo "$file - cell file not found" 
    ok=no
fi

eval `g.findfile element=cell mapset=PERMANENT file=Image.tif.8`
if [ ! "$file" ]
then
    echo "$file - cell file not found" 
    ok=no
fi

#Create Image Group and Subgroup
i.group group=Image subgroup=Image input=Image.tif.1,Image.tif.2,Image.tif.3,Image.tif.4,Image.tif.5,Image.tif.6,Image.tif.7,Image.tif.8

#Create spectral signatures for land cover types 
i.cluster group=Image subgroup=Image sigfile=Sig classes=6

#Classification of the cell spectral reflectances in imagery data based on the spectral signature information
i.maxlik  group=Image subgroup=Image sigfile=Sig class=unsupclass

#Export file to tiff format
r.out.tiff input=unsupclass output=unsupclass.tif



echo 'Done!'
