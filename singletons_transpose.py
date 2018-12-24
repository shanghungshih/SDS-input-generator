import pandas as pd
import os
import sys


singletons_dir = "/home/shanghung/ancestral_1000g/SDS-input-generator/annotated_vcf/singletons"
vcf = "taiwan_biobank_2nd_497.g.vcf.gz"
individuals_list = sys.argv[1]

flag = 0
filter_individuals_list = list()
tmp=""
with open(individuals_list) as f:
    for i in f.readlines():
        i = i.strip()
        individual = os.path.join(singletons_dir, "SM_%s.singletons" %(i))
        tmp_individual = os.path.join(singletons_dir, "tmp_SM_%s.singletons" %(i))
        tmp_individual_name = os.path.join(singletons_dir, "tmp_SM_%s.singletons " %(i))
        try:
            df = pd.read_csv(individual, header=None, encoding='utf-8')
            df = df.T
            df.to_csv(tmp_individual, index=False, header=None, sep="\t")
            tmp += tmp_individual_name
            filter_individuals_list.append(i)
        except:
            print(i, "don't have singletons,", tmp_individual, "doesn't exist.")
            flag = 1


if (flag == 1):
    out = open("filtered_individuals_list", 'w')
    for i in filter_individuals_list:
        out.writelines(i+"\n")
    out.close()
    os.system("python3 singletons_transpose.py filtered_individuals_list")
elif (flag == 0):
    os.system("cat %s > final_SDS_input/%s"%(tmp, vcf.replace('vcf.gz', 'singletons')))
    os.system("rm %s/tmp*" %(singletons_dir))
