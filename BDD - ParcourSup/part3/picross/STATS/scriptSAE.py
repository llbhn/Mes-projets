import numpy as np
import pandas as pd

df_parcoursup =  pd.read_csv("cormention.csv", sep=';')


#nomformation  nb_chars  coefficient_au_sud departement_code  proportion_candidates  proportion_bien_tb



arr_parcoursup = df_parcoursup.to_numpy()



# Extraction en DataFrame des colonnes contenant des données numériques :
df_num_parcoursup = df_parcoursup._get_numeric_data()
# affichage des noms des colonnes du DataFrame
print(df_num_parcoursup.columns)

# Passer ensuite en numpy.array les données de df_num_lannion :
arr_parcoursup = np.array(df_num_parcoursup)
print(arr_parcoursup)