#!/bin/bash

WD=					#path to working directory containing bam files from step 06 
SCRIPT=			                #path to script directory
HEADER=					#path to header.txt file
SAMTOOLS="samtools"			#path to samtools 1.4.1
SAMTOOLS_ENV=				#if needed, path to samtools conda environment
SAM_PARMS="-F 4 -F 256 -q 5 -f 2"	#samtools filtering parameters
TAG="F4_F256_q5_f2"			#tag for filtered bam files
QSUB="qsub -q omp"			#qsub command line

cd $WD

mkdir -p ${WD}/filtered_bam

#Create batch files for bam filtering of every bam file in working directory
for file in $(ls *.bam)
do
	cp ${HEADER} ${WD}/filter_${file}.qsub ;
	echo "${SAMTOOLS_ENV}" >> ${WD}/filter_${file}.qsub ;
	echo "${SAMTOOLS} view -b ${SAM_PARMS} ${WD}/${file} > ${WD}/filtered_bam/${file%.*}_${TAG}.bam " >> ${WD}/filter_${file}.qsub ;
	echo "${SAMTOOLS} flagstat ${WD}/filtered_bam/${file%.*}_${TAG}.bam > ${WD}/filtered_bam/${file%.*}_${TAG}.bam.flagstat " >> ${WD}/filter_${file}.qsub ;
	${QSUB} ${WD}/filter_${file}.qsub ;
done

