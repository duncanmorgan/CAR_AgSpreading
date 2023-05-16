import pandas as pd
import numpy as np
import re
from umi_tools import UMIClusterer

clusterer = UMIClusterer(cluster_method="directional")

df = pd.read_csv('file_igblast_db-pass.tab1', index_col = None, sep = '\t')
print(df.shape)
#df['BC_UMI'] = [''.join([i for i in x if not i.isdigit()] for x in df.SEQUENCE_ID)]
df['BC_UMI'] = [re.sub(r'[0-9]+', '', x) for x in df.SEQUENCE_ID]

print('r2g')


df['BYTEID'] = [x.encode() for x in df.BC_UMI]  

print(df.head())
dict = df.set_index('BYTEID').to_dict()['CONSCOUNT']


clustered_umis = clusterer(dict, threshold=1)

dict = {}
for x in clustered_umis:
	correct = x[0]
	if (len(x) > 1):
		for each in x[1:]:
			dict[each] = correct
	dict[correct] = correct
	
	
df['CORRECTED_ID'] = [dict[x] for x in df.BYTEID]
df.to_csv('igblast_umicorrected.tab')