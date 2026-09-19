
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import numpy.linalg as la
import math



df_parcoursup =  pd.read_csv("~/0-documents/1-pro/but/s2/s24/part3/picross/STATS/cormention.csv", sep=';')

parcoursup_ar = df_parcoursup.to_numpy()

#---------------------------------------------Définition des Variables---------------------------------------------------

df_num_parcoursup = df_parcoursup._get_numeric_data()

parcoursup_ar = np.array(df_num_parcoursup)

CaracteresLibelle_li = parcoursup_ar[:, 0]

CoeffSud_li = parcoursup_ar[:, 1]

Departement_li = parcoursup_ar[:, 2]

PropCandidates_li = parcoursup_ar[:, 3]

MentionBTB_li = parcoursup_ar[:, 4]

#---------------------------------------------Régression Linéaire Multiple---------------------------------------------------

N = parcoursup_ar[:, 0].size

Y = MentionBTB_li

X = np.ones((N, 5))

X[:, 1] = CaracteresLibelle_li
X[:, 2] = CoeffSud_li
X[:, 3] = Departement_li
X[:, 4] = PropCandidates_li

tX = X.T
tXX = tX @ X

tXX_inv = la.inv(tXX)

A = tXX_inv @ tX @ Y

print("A :",A)

#-----------------------------------------Graphique pour analyser les coefficients---------------------------------------------

labels = ["b : biais", "a1 : Taille Nom Formation", "a2 : Rapprochement Equateur", "a3 : n° Departement", "a4 : Proportion Candidate"]
plt.figure(figsize=(12, 6)) # taille fenetre

plt.ylim(-0.05, 0.15)
plt.plot(labels, A, "o")
plt.title("Coefficients de la régression linéaire multiple")

plt.show()

#-------------------------------------------Calculs Corélation------------------------------------------------

def Variance(X):
    N=X.shape[0]
    Xm=sum(X)/N
    return sum((X-Xm)*(X-Xm))/N
def calculCorelation(A_ar, X_ar, Y_ar, N):
    b = A_ar[0]
    a1 = A_ar[1]
    a2 = A_ar[2]
    a3 = A_ar[3]
    a4 = A_ar[4]

    Erreur = 0

    for i in range(N):
        Ypred = a1 * X_ar[i][1] + a2 * X_ar[i][2] + a3 * X_ar[i][3] + a4 * X_ar[i][4] + b
        
        
        Erreur += math.pow(Ypred -Y_ar[i], 2) 
        
    Erreur /= N
    cor = math.sqrt(1 - (Erreur / Variance(Y)))
    return cor


print("Corélation :", calculCorelation(A, X, Y, N))
