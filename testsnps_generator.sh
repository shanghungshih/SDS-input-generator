#/usr/bin

###### dependent tools/path configure

maindir="/home/shanghung/ancestral_1000g/SDS-input-generator"
vcf="taiwan_biobank_2nd_497.g.vcf.gz"
individuals_list="/home/shanghung/ancestral_1000g/Nas4_list.txt"
bcftools="/home/shanghung/bcftools-1.9/bcftools"

######

singleton_prefix="$dir/${vcf/vcf.gz/AA_supported}"
singleton="$singleton_prefix.singletons"

singletons_dir="$dir/singletons"
final_SDS_input_dir="$maindir/final_SDS_input"


### split to single vcf
#raw_vcf=("$AA_supported_vcf")

dir="$maindir/annotated_vcf/split_vcf"
mkdir -p $dir

AA_supported_vcf="$maindir/annotated_vcf/${vcf/vcf.gz/AA_supported.vcf.gz}"

#for file in ${raw_vcf[*]}; do
for individual in `$bcftools query -l $AA_supported_vcf`; do
  $bcftools view -c1 -Oz -s $individual -o "$dir/${vcf/vcf.gz/AA_supported.$individual.vcf.gz}" $AA_supported_vcf
done
#done





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

