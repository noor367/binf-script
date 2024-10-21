#!/usr/local/bin/bash

echo 'testing cut feature'
#wget    -O TEST.fasta -q 'https://rest.uniprot.org/uniprotkb/search?query=gene_exact:EGF(reviewed:true)%20AND%20(taxonomy_id:40674)&format=fasta&'

sed -i 's/>.*OS=/>/g' TEST.fasta
sed -i 's/OX.*//g' TEST.fasta
sed -i 's/\b\(.\)/\u\1/g' TEST.fasta
sed -i 's/[[:blank:]]//g' TEST.fasta
awk '(/^/ && s[$0]++) {$0=$0""s[$0]}1;' TEST.fasta > temp.fasta
mv  -f temp.fasta TEST.fasta
