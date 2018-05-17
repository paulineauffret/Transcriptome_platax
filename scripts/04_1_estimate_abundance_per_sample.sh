#!/bin/bash


#Global variables
ASSEMBLY=						#path to transcriptome assembly fasta file (resulting from step 03_2)
TAG="${ASSEMBLY##*/}_estimate_abundance_per_sample"
WORKING_DIRECTORY=					#path to working/output directory
INPUT=							#path to raw fastq files list file
SCRIPT=							#path to script directory
HEADER=							#path to header.txt file

#Trinity variables
TRINITY_AEA="align_and_estimate_abundance.pl"		#path to Trinity align_and_estimate_abundance.pl script (../trinityrnaseq-2.5.1/util)
TRINITY_ENV=						#if needed path to trinity version 2.5.1 conda environment
SEQ_TYPE="fq"						#fastq input files
NB_CPU=8
MAX_MEM="100G"
EST_METHOD="RSEM"
ALN_METHOD="bowtie2"
bowtie2_RSEM="\"--no-mixed --no-discordant --end-to-end --gbar 1000 -k 200 \" "
#ref="--prep_reference"					#needed if reference not already existing
ref=""							#needed if reference already existing

source $INPUT

mkdir -p $WORKING_DIRECTORY/$TAG

cd $WORKING_DIRECTORY/$TAG

#Run trinity align_and_estimate_abundance.pl script on fastq files
for i in {1..18}
do
	R1=LEFT_$i ;
	R2=RIGHT_$i ;
	temp=${!R1##*/} ;
        prefix=${temp%%_R1*} ;
	cp ${HEADER} ${SCRIPT}/${TAG}_$prefix.qsub ;
	echo "${TRINITY_ENV}" >>  ${SCRIPT}/${TAG}_$prefix.qsub ;
	echo "mkdir -p $WORKING_DIRECTORY/$TAG/$prefix" >>  ${SCRIPT}/${TAG}_$prefix.qsub ;
	echo "time ${TRINITY_AEA} --transcripts $ASSEMBLY --seqType $SEQ_TYPE --left ${!R1} --right ${!R2} --est_method $EST_METHOD --aln_method $ALN_METHOD --bowtie2_RSEM $bowtie2_RSEM --thread_count $NB_CPU --trinity_mode  $ref --output_dir $WORKING_DIRECTORY/$TAG/$prefix " >>  ${SCRIPT}/${TAG}_$prefix.qsub ;
	qsub ${SCRIPT}/${TAG}_$prefix.qsub ;
done








