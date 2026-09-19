import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

##################################
        ###PARTIE B###
##################################


df_parcoursup =  pd.read_csv("/home/user/Desktop/BUT/SAE2.04/picross/STATS/cormention.csv", sep=';')


#nomformation  nb_chars  coefficient_au_sud departement_code  proportion_candidates  proportion_bien_tb

arr_parcoursup = df_parcoursup.to_numpy()


# Extraction en DataFrame des colonnes contenant des données numériques :
df_num_parcoursup = df_parcoursup._get_numeric_data()
# affichage des noms des colonnes du DataFrame
print(df_num_parcoursup.columns)

# Passer ensuite en numpy.array les données de df_num_lannion :
arr_parcoursup = np.array(df_num_parcoursup)
print(arr_parcoursup)

CaracteresLibelle_li = arr_parcoursup[:, 0]

CoeffSud_li = arr_parcoursup[:, 1]

Departement_li = arr_parcoursup[:, 2]

PropCandidates_li = arr_parcoursup[:, 3]

MentionBTB_li = arr_parcoursup[:, 4]


# Boites à moustaches :

plt.boxplot([PropCandidates_li, MentionBTB_li])
plt.show()


# Nuages de points :

indices_li = np.random.choice(len(MentionBTB_li), size=50, replace=False) 

PropCandidates_Aleatoires_li = PropCandidates_li[indices_li] 
MentionBTB_Aleatoires_li = MentionBTB_li[indices_li]

plt.plot(PropCandidates_Aleatoires_li, MentionBTB_Aleatoires_li, "o")
plt.xlabel("Proportion de candidates")
plt.ylabel("Proportion d'étudiants avec mention bien ou meilleure")
plt.show()


filtre_bool = CoeffSud_li < 1 
CoeffSud_Filtré_li = CoeffSud_li[filtre_bool] 

indices_li = np.random.choice(len(CoeffSud_Filtré_li), size=50, replace=False)

CoeffSud_Filtré_Aleatoires_li = CoeffSud_Filtré_li[indices_li]
MentionBTB_Aleatoires_li = MentionBTB_li[indices_li]

plt.plot(CoeffSud_Filtré_Aleatoires_li, MentionBTB_Aleatoires_li, "o")
plt.xlabel("Coefficient de proximité avec l'équateur")
plt.ylabel("Proportion d'étudiants avec mention bien ou meilleure")
plt.show()
