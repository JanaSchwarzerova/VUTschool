# -*- coding: utf-8 -*-
"""Copy of cv3_zadani.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1i36QBxf0rorECeN_KCxIbfs0GJUVsNtV

# Cvičení 3 - selekce příznaků, redukce příznaků
"""

from google.colab import drive
drive.mount('/content/drive')

"""## Introduction to pandas

Pandas stands for “Python Data Analysis Library”


 It is library useful for basic operations with tables.

 Pandas has two basic variables - *series* and *dataframes*  (dataframe consist of series).


 DataFrame has a lot of useful methods for plotting and data analysis.
"""

import pandas as pd
## create a series
s1 = pd.Series([1, 3, 5])

## create dataframe
s1 = pd.Series([1, 3, 5])
s2 = pd.Series(['dog', 'dog','cat'])

df=pd.DataFrame([s1,s2])
df

### select part of dataframe
df1=df.iloc[0, :]
df1

### convert to numpy
df1=df.iloc[0, :]

np1=df1.values
np1

## convert to list
df1=df.iloc[1, :]

list1=df1.to_list()
list1

## read table
path='/content/sample_data/california_housing_train.csv'

df = pd.read_csv(path)
df

"""## Dataset"""

#### california housing dataset
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


path='/content/sample_data/california_housing_train.csv'

df = pd.read_csv(path)

house_f_train=df.iloc[:, :8].values ### as numpy array
house_l_train=df.iloc[:, 8].values

house_f_train_df=df.iloc[:, :8] ### as dataframe
house_l_train_df=df.iloc[:, :8]

house_df=df



df = pd.read_csv(path)

house_f_test=df.iloc[:, :8].values
house_l_test=df.iloc[:, 8].values

house_f_test_df=df.iloc[:, :8].values
house_l_test_df=df.iloc[:, 8].values

names_house=df.columns.values.tolist()
names_house_f = df.columns.values.tolist()[:-1]
names_house_l = df.columns.values.tolist()[-1]

df

"""## Feature selection

### Feature filtering

Initial analyssis - pandas plots
"""

axx=house_df.hist(figsize=(12,12),bins=50)

data=house_df
names=names_house
correlations = data.corr()


fig = plt.figure(figsize=(10,10))
ax = fig.add_subplot(111)
ax.matshow(correlations, vmin=-1, vmax=1)
ax.set_xticklabels(names,rotation = 45)
ax.set_yticklabels(names,rotation = 45)

plt.show()

import seaborn as sns
data=house_df
names=names_house
ax=sns.heatmap(cbar=False,annot=True,data= data.corr(),cmap='coolwarm')

from pandas.plotting import scatter_matrix

scatter_matrix(house_df,figsize=(15,15))

plt.show()

"""### Feature wrapping

Feature subset

How many subsets $S \subset F$  for n features exists?
* for $|S|=k$
* in total
"""

import itertools

def subset_k(s,k):  
  return list(itertools.combinations(s, k))

s=np.arange(5)
k=2
subsets=subset_k(s,k)
print(subsets)

#### create function, which will evaluate test RMSE error of k-nn regresor (using sklean)
## https://scikit-learn.org/stable/modules/generated/sklearn.neighbors.KNeighborsRegressor.html - use k=5
#normalize features data_norm=(data-mean)/std
import numpy as np
from sklearn.neighbors import KNeighborsRegressor
from IPython.core.debugger import set_trace

def knn_reg_rmse(data_train,lbl_train,data_test,lbl_test):
  
  mu=np.mean(data_train,axis=0)
  
  sigma=np.std(data_train,axis=0)
  
  
  
  

  return rmse






  
rmse=knn_reg_rmse(house_f_train[:,[0,1]],house_l_train,house_f_test[:,[0,1]],house_l_test)  
  
print(rmse)

###### find best subset of features for classifiction

"""Forward method"""



"""Backward method"""



"""### Embeded methods

Enforce model to select only sparce subset of features by regularization - e.g. lasso regresion.


In next exercise.......

## Feature reduction (dimensionality reduction)

### PCA

Linear dimensionality reduction which preserve maximum information.


Find ortogonal linear tranformation with (equvalently):

* least-squere reconstruction error - if you project to new space, remove small components and project back
* components with largest variance (ordered by variace)

We want to maximize variance after projection:

${\mathbf  {w}}_{{(1)}}={\underset  {\Vert {\mathbf  {w}}\Vert =1}{\operatorname {\arg \,max}}}\,\left\{\sum _{i}\left({\mathbf  {x}}_{{i}}\cdot {\mathbf  {w}}\right)^{2}\right\}$


$ \mathbf {w} _{(1)}={\underset {\Vert \mathbf {w} \Vert =1}{\operatorname {\arg \,max} }}\,\{\Vert \mathbf {Xw} \Vert ^{2}\}={\underset {\Vert \mathbf {w} \Vert =1}{\operatorname {\arg \,max} }}\,\left\{\mathbf {w} ^{T}\mathbf {X^{T}} \mathbf {Xw} \right\}$

 $\mathbf {w} _{(1)}={\operatorname {\arg \,max} }\,\left\{{\frac {\mathbf {w} ^{T}\mathbf {X^{T}} \mathbf {Xw} }{\mathbf {w} ^{T}\mathbf {w} }}\right\}$
 
 which is well known optimization problem (maximization of Rayleigh quotient), where solution is first eigenvector for positive semi-definite matrix $X^TX$.
 
 
 
 For next otrhogonal projection vector we exchange matrix $X$ for resudual matrix  $\hat{X} = X -  \mathbf {Xw_{(1)}w_{(1)}^T}$, which leads to second eigen vector, etc.
 
 
 If we define covariance matrix
 
 $\mathbf  {C}={\frac  {1}{N}}\sum _{{i=1}}^{N}{\mathbf  {x}}_{i}{\mathbf  {x}}_{i}^{\top }$
 
 and find its eigen decomposition (this is definition of eigen decompostion):
 
 $\Lambda {\mathbf  {W}}=\mathbf{C}{\mathbf  {W}}$
 
 then our optimal transform is:
 
 $\mathbf  {T} = \mathbf  {X} \mathbf  {W}$ 
 
and transform back to original space is (for ortonormal matrix transpose is inverse)
 
  $\mathbf  {X} = \mathbf  {T} \mathbf  {W^T}$ 
  
and eigen values are variances along principal axes, where first component contains most variability, thus we can just first $k$ componets, which leads to dimensionality reduction.
"""

#### calculate PCA using eigenvalue decomposition, plot principal components
from numpy.linalg import eig
from IPython.core.debugger import set_trace
import numpy as np
import matplotlib.pyplot as plt

rot_mat=np.array([[np.cos(np.pi/6),-np.sin(np.pi/6)],[np.sin(np.pi/6),np.cos(np.pi/6)]])
X=np.stack((2*np.random.randn(500),1*np.random.randn(500)),axis=1)@(rot_mat.T)

plt.plot(X[:,0],X[:,1],'.')
plt.xlim([-7,7])
plt.ylim([-7,7])
plt.show()

#### reconstruct original data from just first and  just second component

### aply sklern pca to california housing dataset, show results with biplot , apply classifier to reduced dimension
# dont forget to standardize!
###coeff=pca.components_ - to get score
###score=pca.transform(*)  - to get scores
from IPython.core.debugger import set_trace

def biplot(score,coeff,labels=None,names=None):
  xs = score[:,0]
  ys = score[:,1]
  n=coeff.shape[1]
  scalex = 1.0/(xs.max()- xs.min())
  scaley = 1.0/(ys.max()- ys.min())
  plt.figure(figsize=(12,12))
  if labels is None:
    plt.scatter(xs*scalex,ys*scaley)
  else:
    plt.scatter(xs*scalex,ys*scaley,c=labels)
  coeff= coeff.T
  for i in range(n):
    plt.arrow(0, 0, coeff[i,0], coeff[i,1],color='r',alpha=0.5) 
    if names is None:
      plt.text(coeff[i,0]* 1.15, coeff[i,1] * 1.15, "Var"+str(i+1), color='k', ha='center', va='center')
    else:
      plt.text(coeff[i,0]* 1.15, coeff[i,1] * 1.15, names[i], color='k', ha='center', va='center')
  plt.xlim(-1,1)
  plt.ylim(-1,1)
  plt.xlabel("PC1")
  plt.ylabel("PC2")
  plt.grid()
  plt.show()


from sklearn.decomposition import PCA


data_train=house_f_train

"""### LDA

Dimensionality reduction which preserve separability.

* linear classifier

* dimensionality reduction method


Linear classifier is defined with weigth vector $\mathbf{w}$ and treshhold $t$ as

$\mathbf{x}^T \mathbf{w} > t$

which is basicaly projection to one dimension and tresholding.


<br>


You can also project to new orthogonal space (similar to PCA) 

 $\mathbf  {T} = \mathbf  {X} \mathbf  {W}$ 
 
 and remove unnessesery dimenisions there, where first dimension gives best separation and other are ortogonal to it.
 
<br>


How to find this projectin (procedure without derivation)?

Let:

* $n$ be the number of classes
* $\mathbf{X_i}$ be matrix of samples in the i-th class
* $\mu$  be the mean of all observations
*$N_i$ be the number of observations in the i-th class
*$\mu_i$ be the mean of the i-th class

we need to calculate within class scatter $\mathbf  {S_W}$ and between class scatter matrix $\mathbf  {S_B}$


$\mathbf{S_W} = \sum_{i=1}^n (\mathbf{X_i} - \mathbf{\mu_i})^T(\mathbf{X_i} - \mathbf{\mu_i})$

$\mathbf{S_B} = \sum_i N_i (\mathbf{\mu_i} - \mathbf{\mu})^T(\mathbf{\mu_i} - \mathbf{\mu})$ 



and solution ($\mathbf  {W}$) are eigenvectors of $\mathbf  {S_W}^{-1}\mathbf  {S_B}$.
"""

##### project 2 class iris dataset to 2D and classify with LDA

from sklearn import datasets
from numpy.linalg import eig
from numpy.linalg import inv
from IPython.core.debugger import set_trace
import numpy as np
import matplotlib.pyplot as plt
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis as LDA



### iris data
iris = datasets.load_iris()

print(iris.target_names)
print(iris.feature_names)

data = iris.data
label = iris.target

data=data[label!=2,:] #### use only 2 classes
label=label[label!=2]


x=data
x1=data[label==0,:]
x2=data[label==1,:]



####test data
# rot_mat=np.array([[np.cos(np.pi/6),-np.sin(np.pi/6)],[np.sin(np.pi/6),np.cos(np.pi/6)]])
# x1=np.stack((2*np.random.randn(100),1*np.random.randn(100)),axis=1)@(rot_mat.T)
# x2=np.stack((2*np.random.randn(100)+3,1*np.random.randn(100)+6),axis=1)@(rot_mat.T)
# x=np.concatenate((x1,x2),axis=0)
# label=np.concatenate((np.zeros(100),np.ones(100)),axis=0)

# plt.scatter(x[:,0],x[:,1],c=label)
# plt.show()





























#### sklearn to má taky ale s tím se štvát už nebudem


# lda=LDA(n_components=2)
# lda.fit(data,label)
# PCq=lda.transform(data)

# coefs=lda.coef_[0,:]

# plt.scatter(PCq[:,0],PCq[:,0],c=label)
# plt.show()


# print(W)
# print(coefs/np.sum(coefs))

"""### t-SNE -  t-distributed Stochastic Neighbor Embedding

Dimensionalty reduction which preserve distances.

Complex non-linear dimensionality reduction method, which try to preserve distances between data points. Non-convex randomized optimalization can leads to diferent and suboptimal results.

Its very usefull if we want to visualy check separability of highdimensional data or distances between diferent classes.


Larger distances are more inacurate!
"""

### test sklearn TSNE for iris and MNIST datasets - comapre it with PCA

from sklearn import datasets
from numpy.linalg import eig
from numpy.linalg import inv
from IPython.core.debugger import set_trace
import numpy as np
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE
from sklearn.decomposition import PCA

### iris data
iris = datasets.load_iris()

print(iris.target_names)
print(iris.feature_names)

data = iris.data
label = iris.target


###### MNIST dataset
# import torch
# import torchvision

# loader = torch.utils.data.DataLoader(torchvision.datasets.MNIST('/files/', train=True, download=True,transform=torchvision.transforms.ToTensor()),batch_size=1, shuffle=True)

# data=[]
# label=[]
# for  k, (dataa, targets) in enumerate(loader):
#   lbl=targets.detach().cpu().numpy()
#   data.append(dataa[0,0,:,:].detach().cpu().numpy())
#   label.append(lbl)
  
#   if k>1000:   ###num of asmples
#     break
      
# label=np.array(label)[:,0]
# data=np.stack(data,axis=2).reshape(28*28,-1)  ### vectorize all images
# data=data.T

# data.shape