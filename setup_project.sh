#!/bin/bash

#set -x

script_dir=$(cd -P `dirname $0`; pwd)

if test "x${MODULE}" = "x"; then
    echo "Would you be so kind as to define the MODULE name ?"
    exit 1
fi
UPPER_MODULE=`echo ${MODULE} | tr "[:lower:]" "[:upper:]"`

if test "x${PROGRAM}" != "xbin" -a "x${PROGRAM}" != "xlib"; then
    echo "Would you be so kind as to define the PROGRAM type (lib|bin) ?"
    exit 1
fi

echo "Copying files... "
rm -rf ${MODULE}
cp -r default ${MODULE}
echo "> done"

cd ${MODULE}

echo "Parsing Templates... "
for f in `find . -name '*.template'`
do
    final_name=${f}
    final_name=${final_name//module/${MODULE}}
    final_name=${final_name/.template/}
    ${script_dir}/parse_template.awk \
	-v PROGRAM=${PROGRAM} \
	-v MODULE=${MODULE} \
	-v SUBMODULE="${SUBMODULE}" \
	-v TEST_SUBMODULE="${TEST_SUBMODULE}" \
	-v MODE=${MODE} \
	${f} > ${final_name}
    rm ${f}
done
echo "> done"

echo "Setting up links to submodules..."
for f in utility $SUBMODULE $TEST_SUBMODULE
do
    ln -s ../${f} ${f}
done
echo "> done"

rm -rf .git
git init .
git add -A

cd -
echo "Checking files... "
MODULE=${MODULE} ${script_dir}/check_project.sh
echo "> done"
