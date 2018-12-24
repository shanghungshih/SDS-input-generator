#/usr/bin

###### dependent tools/path configure

maindir="/home/shanghung/ancestral_1000g/SDS-input-generator"
samtools="/home/shanghung/samtools-1.9/samtools"
bgzip="/home/shanghung/htslib-1.9/bgzip"

######

rootdir="$maindir/ancestral_1000g"
mkdir -p $rootdir

### ancestor from 1000g ("." means no ancestral information, while "-" means lineage-specific (not present in ancestor, only in human))
wget -P $rootdir ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/analysis_results/supporting/ancestral_alignments//human_ancestor_GRCh37_e59.README
wget -P $rootdir ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/analysis_results/supporting/ancestral_alignments//human_ancestor_GRCh37_e59.tar.bz2
cd $rootdir
tar jxvf human_ancestor_GRCh37_e59.tar.bz2


### preprocessing (ex. 1 to chr1)
dir="$rootdir/preprocessed_ancestor"
mkdir -p $dir

pre=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y)

for id in ${pre[*]}; do
    sed 's,^>.*,>chr'$id',' "$rootdir/human_ancestor_GRCh37_e59/human_ancestor_"$id".fa" > $dir/"human_ancestor_chr"$id".fa"
    $bgzip $dir/"human_ancestor_chr"$id".fa"
    $samtools faidx $dir/"human_ancestor_chr"$id".fa.gz"
    ######mv $dir/"human_ancestor_"$id".bed" $dir/"human_ancestor_chr"$id".bed"
done
