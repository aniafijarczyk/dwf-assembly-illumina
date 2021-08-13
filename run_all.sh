#!/bin/bash
### Workflow for genome assembly

### Read config
. `pwd`/config.txt
### Read quality check with fastqc:v11.9 & multiqc:1.10
mkdir -p 01_fastqc
fq=$(ls $PE1 $PE2 $SE)
docker run --rm -t -v `pwd`:/data staphb/fastqc:0.11.9 fastqc -o ./01_fastqc $fq
docker run --rm -t -v `pwd`:/data -w '/data' ewels/multiqc:1.10 01_fastqc/*_fastqc.zip -f -o ./01_fastqc
### Trim adapters with trimmomatic :0.39
mkdir -p 02_trim
docker run --rm -v `pwd`:/data staphb/trimmomatic:0.39 \
           trimmomatic PE -phred33 $PE1 $PE2 \
           02_trim/reads_R1P.fq.gz \
           02_trim/reads_R1U.fq.gz \
           02_trim/reads_R2P.fq.gz \
           02_trim/reads_R2U.fq.gz \
           ILLUMINACLIP:${adapters}:6:20:10 MINLEN:21
rm 02_trim/reads_R?U.fq.gz
### Merging reads with bbmerge:38.91
tPE1=02_trim/reads_R1P.fq.gz
tPE2=02_trim/reads_R2P.fq.gz
docker run -v `pwd`:/data --rm my_bbmap:38.91 in1=$tPE1 in2=$tPE2 out=03_merge/reads_M.fq outu1=03_merge/reads_UM1.fq outu2=03_merge/reads_UM2.fq ihist=ihist_reads.txt
gzip -f 03_merge/reads_*.fq
### Read quality check with fastqc:v11.9
mkdir -p 04_fastqc
mPE1=03_merge/reads_UM1.fq.gz
mPE2=03_merge/reads_UM2.fq.gz
mSE=03_merge/reads_M.fq.gz
mfq=$(ls $mPE1 $mPE2 $mSE)
docker run --rm -t -v `pwd`:/data staphb/fastqc:0.11.9 fastqc -o ./04_fastqc $mfq
docker run --rm -t -v `pwd`:/data -w '/data' ewels/multiqc:1.10 04_fastqc/*_fastqc.zip -f -o ./04_fastqc
