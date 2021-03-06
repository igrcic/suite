#!/bin/bash

# load common functions
. "$( cd "$( dirname "$0" )" && pwd )"/functions 

set -x

DIST_ROOT=/var/www/suite

# build category
build_cat=`init_build_cat $CAT`

# build name
build_name=`init_build_name $NAME`

# set up the maven repository for this particular branch/tag/etc...
#TODO: fix dist_path logic and how it relates to maven repo, etc...
MVN_SETTINGS=`init_mvn_repo $MVN_REPO`
if [ -z $MAVEN_OPTS ]; then
  export MAVEN_OPTS=-Xmx256m
fi

# checkout the requested revision to build
cd git
if [ ! -z $REV ]; then
  git checkout $REV

  # if this rev is a tag don't pull
  if [ "$( git tag | grep $REV )" != $REV ]; then
     git pull origin $REV
  fi

  git submodule update --init --recursive
fi

# extract the actual revision number
export build_rev=`get_rev .`

build_info="-Dbuild.date=$BUILD_ID -Dbuild.revision=$build_rev"

gs_externals="geoserver/externals"
gs_rev=`get_submodule_rev $gs_externals/geoserver`
gs_branch=`get_submodule_branch $gs_externals/geoserver`
gt_rev=`get_submodule_rev $gs_externals/geotools`
gt_branch=`get_submodule_branch $gs_externals/geotools`
gwc_rev=`get_submodule_rev $gs_externals/geowebcache`
gwc_branch=`get_submodule_branch $gs_externals/geowebcache`

# only use first seven chars
build_rev=${build_rev:0:7}

echo "building $build_rev ($REV) with maven settings $MVN_SETTINGS"

dist=$DIST_ROOT/$build_cat/$build_rev
if [ ! -e $dist ]; then
  mkdir -p $dist
fi

echo "exporting artifacts to: $dist"

full_build="-Dfull"
if [ "$FULL_BUILD" == "no" ] || [ "$FULL_BUILD" == "false" ]; then
  full_build=""
fi

# perform a full build
$MVN -s $MVN_SETTINGS $full_build -Dmvn.exec=$MVN -Dmvn.settings=$MVN_SETTINGS $build_info -Dgs.flags="-Dbuild.commit.id=$gs_rev -Dbuild.branch=$gs_branch -DGit-Revision=$gt_rev -Dgt.Git-Revision=$gt_rev" $BUILD_FLAGS clean install
checkrv $? "maven install"

# clean out old assembly artifacts, usually maven clean does this but it could
# be skipped if this not a full build
rm target/*.zip

$MVN -s $MVN_SETTINGS initialize assembly:attached $build_info
checkrv $? "maven assembly"

#$MVN -s $MVN_SETTINGS -Dmvn.exec=$MVN -Dmvn.settings=$MVN_SETTINGS $build_info deploy -DskipTests
#checkrv $? "maven deploy"

# copy the new artifacts into place
cp target/*.zip $dist

# alias the build with the build name
dist_alias=$DIST_ROOT/$build_cat/$build_name
[ -e $dist_alias ] && [ rm -rf $dist_alias ]
mkdir -p $dist_alias
for f in `ls $dist`; do
  g=`echo $f | sed "s/\(opengeosuite-\)[0-9a-z]\+\(-.*\)/\1$build_name\2/g"`
  ln -sf $dist/$f $dist_alias/$g
done

# Archive build if requested
if [ "$ARCHIVE_BUILD" == "true" ]; then
  dist_arch=$DIST_ROOT/archive/$build_name
  [ -e $dist_arch ] && [ rm -rf $dist_arch ];
  cp -r $dist $dist_arch
else
  ARCHIVE_BUILD="false"
fi

# clean up old artifacts
pushd $dist/..

# keep around last two builds (plus the last alias we created)
ls -t | tail -n +3 | xargs rm -rf
popd

# start_remote_job <url> <name>
function start_remote_job() {
   curl -k --connect-timeout 10 "$1/buildWithParameters?CAT=${build_cat}&REV=${REV}&NAME=${build_name}&ARCHIVE_BUILD=${ARCHIVE_BUILD}"
   checkrv $? "trigger $2 with ${build_cat} r${rev}"
}

WIN=192.168.50.40
OSX=192.168.50.35

# start the build of the OSX installer
#start_remote_job http://$OSX:8080/job/osx-installer "osx installer"

# start the build of the Windows installer
#start_remote_job http://$WIN:8080/hudson/job/windows-installer "win installer"

echo "Done."
