#!/bin/sh -e

VERSION=$2

DIR=apache-poi-$VERSION
TAR=../libapache-poi-java_$VERSION.orig.tar.xz
TAG=REL_`echo $VERSION | sed "s/\./_/g"`_FINAL

# Checkout the code from svn
svn export http://svn.apache.org/repos/asf/poi/tags/$TAG $DIR

# Fetch the OOXML schemas from the ECMA site.
# These files are available to all interested parties without
# restriction according to the ECMA bylaws:
# http://www.ecma-international.org/memento/Ecmabylaws.htm#art9.4
wget 'http://www.ecma-international.org/publications/files/ECMA-ST/Office%20Open%20XML%201st%20edition%20Part%204%20(PDF).zip'
unzip 'Office Open XML 1st edition Part 4 (PDF).zip' OfficeOpenXML-XMLSchema.zip
unzip OfficeOpenXML-XMLSchema.zip -d $DIR/ooxml-xsds
rm *.zip

wget 'http://www.ecma-international.org/publications/files/ECMA-ST/Office%20Open%20XML%201st%20edition%20Part%202%20(PDF).zip'
unzip 'Office Open XML 1st edition Part 2 (PDF).zip' OpenPackagingConventions-XMLSchema.zip
unzip OpenPackagingConventions-XMLSchema.zip -d $DIR/ooxml-xsds
rm *.zip

mkdir -p $DIR/ooxml-lib
wget -P $DIR/ooxml-lib http://dublincore.org/schemas/xmls/qdc/2003/04/02/dc.xsd
wget -P $DIR/ooxml-lib http://dublincore.org/schemas/xmls/qdc/2003/04/02/dcterms.xsd
wget -P $DIR/ooxml-lib http://dublincore.org/schemas/xmls/qdc/2003/04/02/dcmitype.xsd
wget -P $DIR/ooxml-lib http://www.w3.org/TR/2002/REC-xmldsig-core-20020212/xmldsig-core-schema.xsd
wget -P $DIR/ooxml-lib http://uri.etsi.org/01903/v1.3.2/XAdES.xsd
wget -P $DIR/ooxml-lib http://uri.etsi.org/01903/v1.4.1/XAdESv141.xsd

XZ_OPT=--best tar cJf $TAR -X debian/orig-tar.exclude $DIR
rm -rf $DIR
