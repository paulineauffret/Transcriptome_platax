import sys

#Given one transcriptome fasta file and a list of transcripts ID, get the sequences of these transcripts
#preliminary cmd line : grep ">" longest_orfs.cds | cut -f1 -d " " | cut -f1 -d "." | cut -f2 -d ">" | uniq  > longest_orfs.cds_transcripts_ID.txt
#cmd line : python 03_2_getFasta.py Trinity.fasta longest_orfs.cds_transcripts_ID.txt  Trinity.predict_orf_m100.fasta

fileIN=open(sys.argv[1], "rU") 	#transcriptome fasta file resulting from step 02
fileID=open(sys.argv[2], "rU")	#IDs list to get fasta sequence one ID per line
fileOUT=open(sys.argv[3], "w")	#out file

ref=dict()

line=fileIN.readline()
seq=""
id=""
nbSeq=0
while line :
	if line.startswith(">") :
		if nbSeq!=0 :
			ref[str(id)]=str(seq)
		id=line.split(" ")[0].replace(">","")
		seq=""
		nbSeq=nbSeq+1
	else :
		seq=seq+line
	line=fileIN.readline()
ref[str(id)]=str(seq)

print("There are "+str(nbSeq)+" sequences in the input transcriptome.")
#print(ref)
#print(len(ref.keys()))


dup=dict()
line=fileID.readline()
while(line) :
	line=line.replace("\n","").replace(">","")
	if str(line) != "" :
		if not ref.has_key(line) :
			print("Error : sequence "+str(line)+" not found in input transcriptome.")	
		elif not dup.has_key(line) :
			fileOUT.write(">"+line+"\n")
			fileOUT.write(ref[line])
	dup[str(line)]=1
	line=fileID.readline()



#When finished run TrinityStats
