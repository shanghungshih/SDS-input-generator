#/usr/bin

###### dependent tools/path configure

maindir="/home/shanghung/ancestral_1000g/SDS-input-generator"
vcf="taiwan_biobank_2nd_497.g.vcf.gz"
individuals_list="/home/shanghung/ancestral_1000g/Nas4_list.txt"
vcftools="/home/shanghung/vcftools_0.1.13"

######

dir="$maindir/annotated_vcf"

### singletons (taiwan_biobank_2nd_497_AA_supported.singletons)
AA_supported_vcf="$dir/${vcf/vcf.gz/AA_supported.vcf.gz}"
singleton_prefix="$dir/${vcf/vcf.gz/AA_supported}"
singleton="$singleton_prefix.singletons"

if [ -e "$singleton" ]; then
  echo "singleton file is already exist."
else
  zcat $AA_supported_vcf | $vcftools/bin/vcftools --vcf - --singletons --out $singleton_prefix
fi


### generate SDS computing input file (TBB.singletons)
singletons_dir="$dir/singletons"
final_SDS_input_dir="$maindir/final_SDS_input"
mkdir -p $singletons_dir
mkdir -p $final_SDS_input_dir

### generate single sample singletons from multi-sample singletons respectively
while read line; do
  sample="SM_"$line
  split_singletons="$singletons_dir/$sample.singletons"
  grep $sample $singleton |cut -f2 > $split_singletons
done < $individuals_list


### generate TBB.singletons (input file)
python3 singletons_transpose.py $individuals_list


### split to single vcf
#bash split_multi_sample_vcf.sh


### generate TBB.testsnp (input file)
#while read line; do
#  sample="/home/shanghung/ancestral_1000g/split_vcf/taiwan_biobank_2nd_497_AA_supported.SM_$line.vcf.gz"
#
#  while read variant; do
#    if ($variant !~ /#/); then
#      printf $variant
#    fi
#  #  zcat $sample |awk '{if ($1 !~ /#/) print $8}' |rev | cut -d';' -f 1 | rev | cut -d'=' -f2 |more
#  done < $sample
##done < $sample_list
#done < "/home/shanghung/ancestral_1000g/test.txt"




# SM_NGS20140710G was deleted beacause has no singletons
# re run bash generate_SDS_input.sh

