#!/bin/bash


DATA_DIRECTORY=			#path to raw data directory
DATA_DIRECTORY_REF=             #if needed, path to other raw data directory
sample1=			#if needed, path to other file located in other directory
sample2=			#if needed, path to other file located in other directory
sample3=			#if needed, path to other file located in other directory
sample4=			#if needed, path to other file located in other directory
WORKING_DIRECTORY=		#path to working/output directory
SCRIPT=		                #path to script directory
HEADER=				#path to header.txt file
FASTQC_ENV=			#if needed,path to fastqc conda environment
FASTQC=				#path to fastqc version 0.11.5

#Running qc script on every fastq files
mkdir -p $WORKING_DIRECTORY/fastqc_raw_reads

cd $DATA_DIRECTORY
for dir in $(ls) ;
do
	if [[ ${dir##*.} != "txt" ]] ;
	then
		cd $dir ;
		for file in $(ls *.fastq.gz) ;
		do
			cp ${HEADER} ${WORKING_DIRECTORY}/fastqc_raw_reads/${file##*/}_fastqc.qsub ;
			echo "${FASTQC_ENV}" >> ${WORKING_DIRECTORY}/fastqc_raw_reads/${file##*/}_fastqc.qsub ;
			echo "cd ${DATA_DIRECTORY}/${dir}" >> ${WORKING_DIRECTORY}/fastqc_raw_reads/${file##*/}_fastqc.qsub ;
			echo "${FASTQC} ${file} -o ${WORKING_DIRECTORY}/fastqc_raw_reads" >> ${WORKING_DIRECTORY}/fastqc_raw_reads/${file##*/}_fastqc.qsub ;
			qsub ${WORKING_DIRECTORY}/fastqc_raw_reads/${file##*/}_fastqc.qsub ;
			
		done ;
		cd $DATA_DIRECTORY ;
		
	fi ;
done

for i in {1..4}
do
        sample=sample$i ;
        prefix=${!sample##*/} ;
        cp ${HEADER} ${WORKING_DIRECTORY}/fastqc_raw_reads/${prefix}_fastqc.qsub ;
        echo "${FASTQC_ENV}" >> ${WORKING_DIRECTORY}/fastqc_raw_reads/${prefix}_fastqc.qsub ;
	echo "cd ${DATA_DIRECTORY_REF}" >> ${WORKING_DIRECTORY}/fastqc_raw_reads/${prefix}_fastqc.qsub ;
	echo "${FASTQC_ENV} ${!sample}  -o ${WORKING_DIRECTORY}/fastqc_raw_reads" >> ${WORKING_DIRECTORY}/fastqc_raw_reads/${prefix}_fastqc.qsub ;
        qsub ${WORKING_DIRECTORY}/fastqc_raw_reads/${prefix}_fastqc.qsub ;
done

