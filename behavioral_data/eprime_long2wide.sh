#!/bin/sh

# generic unix script to convert e-prime 2 long format .txt file to wide format .txt file
# Theo G.M. van Erp, 2009/11/20
# Please report bugs along with sample data to vanerp@psych.ucla.edu
# Requires SUSE linux
# requires as input a long format e-prime .txt file

# 
if [ $# -lt 1 ]; then
   echo 
   echo This is a generic unix script to convert an e-prime 2 long format .txt file
   echo to a wide format .txt file. It requires as input an e-prime 2 long format .txt file.
   echo It will write as output a clean_ and wide_ file. The clean_ file is a long format .txt 
   echo file without unreadable characters, and the wide_ file has the e-prime data in column 
   echo format. Any missing data is replaced with the string NaN.
   echo
   echo Example:
   echo eprime_long2wide.sh my_eprime2_task.txt
   echo
   echo "Please report bugs along with sample data to Theo G.M. van Erp (vanerp@psych.ucla.edu)."
   echo
   exit 1
else
   EPRIME_FILE=$1
fi

# Setting to avoid "tr: Illegal byte sequence" error when running script on on mac OS X 10.5.8 
export LC_ALL=C

# remove non-readable characters from e-prime txt file
if [ -f ${EPRIME_FILE} ]; then
   tr -cd "[:print:]\t\n" < ${EPRIME_FILE} > clean_${EPRIME_FILE} 
else echo "${EPRIME_FILE} does not exist"
     exit 1;
fi

# For Start Up Info:
# 1. Find Header Start
# 2. Find Header End
# 3. converted all logged varaibles to a wide format
Subject=`cat -n clean_${EPRIME_FILE} | grep "Subject:" | awk -F: ' { print $2 } ' | head -1`
echo Subject: $Subject
Visit=`cat -n clean_${EPRIME_FILE} | grep "Visit:" | awk -F: ' { print $2 } ' | head -1`
echo Visit: $Visit
Session=`cat -n clean_${EPRIME_FILE} | grep "Session:" | awk -F: ' { print $2 } ' | head -1`
echo Session: $Session
Experiment=`cat -n clean_${EPRIME_FILE} | grep "Experiment:" | awk -F: ' { print $2 } ' | head -1`
echo Experiment: $Experiment
SessionDate=`cat -n clean_${EPRIME_FILE} | grep "SessionDate:" | awk -F: ' { print $2 } ' | head -1` 
echo SessionDate: $SessioDate
SessionTime=`cat -n clean_${EPRIME_FILE} | grep "SessionTime:" | awk -FTime: ' { print $2 } ' | head -1`
DisplayRefreshRate=`cat -n clean_${EPRIME_FILE} | grep "Display.RefreshRate:" | awk -F: ' { print $2 } ' | head -1`
echo DisplayRefreshRate: $DisplayRefreshRate

# For Task Related Variables:
# 1. find LogFrame Start
# 2. find LogFrame End
# 3. convert all logged variables to a wide format

# 1. find LogFrame Start
LogFrameStart=`cat -n clean_${EPRIME_FILE} | grep "LogFrame Start" | head -1 | awk ' { print $1 } '`
LogFrameStartPlus1=`expr ${LogFrameStart} + 1`

# 2. find LogFrame End
LogFrameEnd=`cat -n clean_${EPRIME_FILE} | grep "LogFrame End" | head -1 |  awk ' { print $1 } '`
LogFrameEndMinus1=`expr ${LogFrameEnd} - 1`

# 3. compute number of logged variables
N_LOGGED_VARIABLES=`expr ${LogFrameEnd} - ${LogFrameStart} - 1`
echo Number of logged variables in between lines ${LogFrameStart} and ${LogFrameEnd} is: ${N_LOGGED_VARIABLES}

# Make list of logged variables
cat clean_${EPRIME_FILE} | head -${LogFrameEndMinus1} | tail -${N_LOGGED_VARIABLES} | awk -F: ' { print $1 } '
LoggedVariables=`cat clean_${EPRIME_FILE} | head -${LogFrameEndMinus1} | tail -${N_LOGGED_VARIABLES} | awk -F: ' { print $1 } ' | sort`
echo ${LoggedVariables} | sed 's/ /,/g'
echo ""

# count the number of trials
# I am currently basing this on Sample, but will need to check this for robustness.
N_TRIALS=`grep Sample clean_${EPRIME_FILE} | awk -F: ' { print $2 } ' | sort -g | tail -1`

echo The number of trials is: $N_TRIALS

# create wide_${EPRIME_FILE}

trial=1
LoggedVariableValue=""
InitialLoggedVariables="Subject Visit Session Experiment SessionDate DisplayRefreshRate"
InitialLoggedVariableValues=${Subject},${Visit},${Session},${Experiment},${SessionDate},${DisplayRefreshRate}

FirstLoggedVariable=`echo $LoggedVariables | awk ' { print $1 } '`

echo ${InitialLoggedVariables} ${LoggedVariables} | sed 's/ /,/g' 
echo ${InitialLoggedVariables} ${LoggedVariables} | sed 's/ /,/g' > wide_${EPRIME_FILE}
while [ ${trial} -le ${N_TRIALS} ]; do
   LoggedVariableValues=$InitialLoggedVariableValues                                                                                                                                             
   for LoggedVariable in ${LoggedVariables}; do
     LoggedVariableValue=`grep ${LoggedVariable}: clean_${EPRIME_FILE} | awk -F: ' { print $2 } ' | head -${trial} | tail -1`
    if [ -z "$LoggedVariableValue" ]; then
       LoggedVariableValue=NaN;
     fi
#     if [ $LoggedVariable == $FirstLoggedVariable ]; then
#	LoggedVariableValues=`echo $LoggedVariableValue`
#     else
#	LoggedVariableValues=`echo $LoggedVariableValues,$LoggedVariableValue`
#     fi     
   LoggedVariableValues=`echo $LoggedVariableValues,"$LoggedVariableValue"`
   done
   echo $LoggedVariableValues
   echo $LoggedVariableValues >> wide_${EPRIME_FILE}
   #LoggedVariableValues=$InitialLoggedVariableValues
   trial=`expr $trial + 1`
done

