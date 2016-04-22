#!/bin/sh

#variables to customize:
GISDBASE=$HOME/local_data/grassdata
GISBASE=/usr/local/grass54

#nothing to change below:
if [ $# -lt 2 ] ; then
 echo "Script to calculate NDVI"
 echo "Usage:"
 echo "   ndvi.sh"
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

#Search for the necessary files to continue with calculation
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


#NDVI
r.mapcalc << EOF
 ndvi = eval( \\
 red = Image.tif.2, \\
 nir = Image.tif.3, \\
 summ = nir + red, \\
 diff = nir - red, \\
 if(summ == 0., -1., round(((1. * diff / summ) + 1.) * 255)) )
EOF

#Export file to tiff format
r.out.tiff input=ndvi output=ndvi.tiff

echo 'Done!'
