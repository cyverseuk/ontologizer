#!/bin/bash

function debug {
  echo "creating debugging directory"
mkdir .debug
for word in ${rmthis}
  do
    if [[ "${word}" == *.sh ]] || [[ "${word}" == lib ]]
      then
        mv "${word}" .debug;
      fi
  done
}

rmthis=`ls`
echo ${rmthis}

ARGSU=" ${calculation} ${dot} ${ignore} ${mtc} ${maxAlpha} ${maxBeta} ${mcmcSteps} ${annotation} ${resamplingsteps} ${sizetolerance} "
ASSOCIATIONU="${association}"
GOU="${go}"
POPULATIONU="${population}"
STUDYSETU="${studyset}"
INPUTSU="${ASSOCIATIONU}, ${GOU}, ${POPULATIONU}, ${STUDYSETU} "
echo "Association file is " "${ASSOCIATIONU}"
echo "GO file is " "${GOU}"
echo "Population file is " "${POPULATIONU}"
echo "Study set is " "${STUDYSETU}"
echo "Input files are " "${INPUTSU}"
echo "Arguments are " "${ARGSU}"

CMDLINEARG="ontologizer ${ARGSU} --association ${ASSOCIATIONU} --go ${GOU} --population ${POPULATIONU} --studyset ${STUDYSETU} --outdir output"

echo ${CMDLINEARG};

chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyverseuk/ontologizer:v2.1 >> lib/condorSubmitEdit.htc ######
echo executable               =  ./launch.sh >> lib/condorSubmitEdit.htc #####
echo arguments                          = ${CMDLINEARG} >> lib/condorSubmitEdit.htc
echo transfer_input_files = ${INPUTSU}, launch.sh >> lib/condorSubmitEdit.htc
#echo transfer_output_files = output >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/ontologizer/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
