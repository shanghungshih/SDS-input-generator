#/usr/bin

###### dependent tools/path configure

maindir="/home/shanghung/ancestral_1000g/SDS-input-generator"
vcf="taiwan_biobank_2nd_497.g.vcf.gz"
vcftools="/home/shanghung/vcftools_0.1.13"

######

dir="$maindir/annotated_vcf"
mkdir -p $dir

### vcf enrich in chr: 1-22, X, Y
enriched_vcf="$dir/${vcf/vcf.gz/enriched.vcf.gz}"
zcat $maindir/$vcf |awk '{if ($1~/#/ || $1=="chr1" || $1=="chr2" || $1=="chr3" || $1=="chr4" || $1=="chr5" || $1=="chr6" || $1=="chr7" || $1=="chr8" || $1=="chr9" || $1=="chr10" || $1=="chr11" || $1=="chr12" || $1=="chr13" || $1=="chr14" || $1=="chr15" || $1=="chr16" || $1=="chr17" || $1=="chr18" || $1=="chr19" || $1=="chr20" || $1=="chr21" || $1=="chr22" || $1=="chrX" || $1=="chrY") print $0 }' |gzip -c > $enriched_vcf


### annotation AA (taiwan_biobank_2nd_497_AA.vcf.gz)
AA_vcf="$dir/${vcf/vcf.gz/AA.vcf.gz}"
zcat $enriched_vcf | $vcftools/perl/fill-aa -a $maindir/ancestral_1000g/preprocessed_ancestor/human_ancestor_ 2>$dir/run.err | gzip -c > $AA_vcf


### filter out AA="N", "-", "." (before: , after: 15571) (taiwan_biobank_2nd_497_AA_supported.vcf.gz)
#ACTG : high-confidence call, ancestral state supproted by the other two sequences
#actg : low-confindence call, ancestral state supported by one sequence only
#N    : failure, the ancestral state is not supported by any other sequence
#-    : the extant species contains an insertion at this postion
#.    : no coverage in the alignment

AA_supported_tmp="$dir/${vcf/vcf.gz/AA_supported_tmp.vcf.gz}"
AA_supported_vcf="$dir/${vcf/vcf.gz/AA_supported.vcf.gz}"
zcat $AA_vcf |awk '{if ($1 !~ /#/) print $0}' | awk '{if ($8 ~ /AA=a/ || $8 ~ /AA=t/ || $8 ~ /AA=c/ || $8 ~ /AA=g/ || $8 ~ /AA=A/ || $8 ~ /AA=T/ || $8 ~ /AA=C/ || $8 ~ /AA=G/) print $0}' | gzip -c > $AA_supported_tmp
zcat $AA_vcf |awk '{if ($1 ~ /#/) print $0}' |gzip -c > $dir/header.vcf.gz
zcat $dir/header.vcf.gz $AA_supported_tmp > $AA_supported_vcf
rm $AA_supported_tmp $dir/header.vcf.gz
