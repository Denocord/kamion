#!/bin/sh
function test_directory {
    pathToFile=$1
    expectedParentDir=$2
    if [[ ! -f $pathToFile ]] 
    then
        return 1
    fi

    real=$(realpath $pathToFile)
    if [[ $real != ${expectedParentDir}* ]] 
    then
        return 1
    fi

    return 0
}