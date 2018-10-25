#output.tax if result file from blastn from step 10
#transcriptome_platax_40278.fa file is the version of transcriptome from step 5
#you can find get_transcript_sequence.py at  https://github.com/paulineauffret/ToolKit/blob/master/get_transcript_sequence.py

#Get Bacteria and "N/A" kingdoms hits in blastn output
grep "Bacteria" output.tax > output_bacteria.tax
grep "N/A" output.tax > output_NA.tax

#Get uniq transcripts ID
cut -f1 output_bacteria.tax | uniq > tr_names_bact.txt
cut -f1 output_NA.tax | uniq > tr_names_na.txt
cat tr_names_bact.txt tr_names_na.txt | sort | uniq > tr_names_bact_na.txt

#Get all transcrptome transcripts ID and reformat
grep ">" transcriptome_platax_40278.fa > tr_names.txt
cut -f1 -d " " tr_names.txt > tmp
rm tr_names.txt
mv tmp tr_names.txt
sed -i "s/>//g" tr_names.txt

#Remove Bacteria and N/A transcripts from transcriptome and get a new clean transcriptome
grep -v -f tr_names_bact_na.txt tr_names.txt > tr_names_to_keep.txt
python get_transcript_sequence.py transcriptome_platax_40278.fa tr_names_to_keep.txt transcriptome_platax_40130.fa

#Trinity assembly stats on new transcriptome
##Load trinity conda env if needed
TrinityStats.pl transcriptome_platax_40130.fa > transcriptome_platax_40130.fa.stats
