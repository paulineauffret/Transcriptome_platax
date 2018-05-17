#!/bin/bash


#Global variables
ASSEMBLY=	          #path to transcriptome assembly fasta file (resulting from step 05)
WORKING_DIRECTORY=	  #path to working/output directory
INPUT=		          #path to raw fastq files list file
SCRIPT=                   #path to script directory
HEADER=			  #path to header.txt file

#BWA variables
BWA="bwa"   		#path to BWA version 0.7.15
BWA_ENV=		#if needed path to bwa 0.7.15 conda environment
NB_CPU=32
INDEX=1                 #boolean : if 1 index already built, else 0

source $INPUT

TAG="remap_assembly_trinity_PE_norm_10samples_BWA_${ASSEMBLY##*/}"

mkdir -p $WORKING_DIRECTORY/$TAG

cd $WORKING_DIRECTORY/$TAG

#create bwa index if not existing
if [[ $INDEX == 0 ]]
then
        cp ${HEADER} ${SCRIPT}/create_bwa_index_${ASSEMBLY##*/}.qsub ;
	echo "${BWA_ENV}" >> ${SCRIPT}/create_bwa_index_${ASSEMBLY##*/}.qsub ;
	echo "time ${BWA} index $ASSEMBLY" >> ${SCRIPT}/create_bwa_index_${ASSEMBLY##*/}.qsub ;
        qsub ${SCRIPT}/create_bwa_index_${ASSEMBLY##*/}.qsub ;
else


#Running bwa
mkdir -p $WORKING_DIRECTORY/$TAG

cd $WORKING_DIRECTORY/$TAG

#BWA
for i in {1..18}
do
        R1=LEFT_$i ;
        R2=RIGHT_$i ;
        temp=${!R1##*/} ;
        prefix=${temp%%_R1*} ;
        cp ${HEADER} ${SCRIPT}/remapping_BWA_${ASSEMBLY##*/}_${prefix}.qsub ;
        echo "${BWA_ENV}" >> ${SCRIPT}/remapping_BWA_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "time ${BWA} mem -t ${NB_CPU} -M ${ASSEMBLY} ${!R1} ${!R2} > ${WORKING_DIRECTORY}/${TAG}/${prefix}.bam" >> ${SCRIPT}/remapping_BWA_${ASSEMBLY##*/}_${prefix}.qsub ;
        qsub ${SCRIPT}/remapping_BWA_${ASSEMBLY##*/}_${prefix}.qsub ;
done

fi

