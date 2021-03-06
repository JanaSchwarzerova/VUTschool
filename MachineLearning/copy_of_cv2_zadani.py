# -*- coding: utf-8 -*-
"""Copy of cv2_zadani.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1Cp0wkdTvha4ZfnbJ96ppVOpYakaa9SFb

# Cvičení 2 - Opakování AUIN, úvod do Pythonu II


1.   Debugging 
2.   k-means clustering 
3.   Object oriented programing - practical example 
5.   UPGMA

## Debugging
"""

from IPython.core.debugger import set_trace
# from pdb import set_trace   #alternative


aa=6
for k in range(100):
  bb=999
  if k==50:
    cc=9
    set_trace()   ##break point
    dd=6
    ee=99  
    pdb
## use help/h to get all commands,  use step/s to step through code and print variables content
## c - continue, s - step (get inside fcn), q - quit, p var - print, n - next line (in same fcn)

whos   ## not working inside debugger  :(

# Commented out IPython magic to ensure Python compatibility.
# %pdb 1     
#### start automatic debug if error
# %pdb 0    
### stop automatic debug if error

aa=6
for k in range(100):
  bb=999
  if k==50:
    cc=9
    fff=fdfsfdf   ##create error
    dd=6
    ee=99

# Commented out IPython magic to ensure Python compatibility.
# %pdb 1     
#### start automatic debug if error
# %pdb 0    
### stop automatic debug if error

aa=6
for k in range(100):
  bb=999
  if k==50:
    cc=9
    fff=fdfsfdf   ##create error
    dd=6
    ee=99  
    
    
### run %debug magic comand to find last error

# Commented out IPython magic to ensure Python compatibility.
# %debug

"""## k-means

### Load and plot iris data

select just 2 featrues - plot diferent labels with diferent color
"""

from sklearn import datasets

iris = datasets.load_iris()

# print(iris)
print(iris.target_names)
print(iris.feature_names)

data = iris.data
label = iris.target

data=data[:,[0,2]]  ## select just 2 features => can be ploted

print(data.shape)

import numpy as np
import matplotlib.pyplot as plt


plt.figure(figsize=(12, 12))
plt.scatter(data[:,0], data[:,1], c=label)
plt.axes().set_aspect('equal')
plt.show()

"""###Create k-means clustering 

(use just numpy)

1. Initialize $k=3$ centroids of clusters - e.g as randomly selected data points


> Repeat until convergence:


>2. Data assigment step - each datapoint is assignet to th nearest centroid w.r.t. Euclidean distance.


>3. Centroid update step - move all centroids to mean position of  assigned points.
"""

import numpy as np

init= np.random.randint(data.shape[0],size=3)
centroids = data[init,:]

def eukleid(x,y):   # function Eukleid distance
  return np.sqrt(np.sum((x-y)**2))


for k in range(10):
  prirazeni=[]
  for kk in range(data.shape[0]):
    distance=[]

    for kkk in range(centroids.shape[0]):
      distance.append(eukleid(data[kk,:],centroids[kkk,:]))

    prirazeni.append(np.argmin(distance))

  plt.figure(figsize=(12, 12))
  plt.scatter(data[:,0], data[:,1], c=label)
  plt.axes().set_aspect('equal')
  plt.show()

  prirazeni=np.array(prirazeni)
  for kkk in range(centroids.shape[0]):
      centroids[kkk,:]=np.mean(data[prirazeni==kkk,:],axis=0)

"""### Use k-means from sklearn



1.   Create KMeans object
2.   Fit k-means with data
3.   Predict same data to get classes
"""

from sklearn.cluster import KMeans

"""## Object oriented programing

třída  - kód popisující objekt/typ objektu

objekt - vytvořená proměná s danou třídou (instance trídy )

metoda - funkce objektu

atribut - proměnná objektu
"""

### example class
class Person:
  def __init__(self, name, age):
    self.name = name
    self.age = age
    
  def multiply(self,a,b):
    return a*b
  
karel =  Person('Karel Novák',24) 


print(karel.name)


c=karel.multiply(2,3)
print(c)

"""Create class MyKMeans with same behavior as sklearn.cluster.KMeans  (just fit and predict methods):"""

class MyKMeans:
  def __init__(self,n_clusters=3):
    self.n_clustersSSSS=n_clusters

  def fit(self,data): 

    for k in range(10):
      prirazeni=[]
      for kk in range(data.shape[0]):
        distance=[]
        
        for kkk in range(centroids.shape[0]):
          distance.append(eukleid(data[kk,:],centroids[kkk,:]))
        
      prirazeni.append(np.argmin(distance))
      prirazeni=np.array(prirazeni)
      for kkk in range(centroids.shape[0]):
        centroids[kkk,:]=np.mean(data[prirazeni==kkk,:],axis=0)

    self.cent= centroids
     

  def predict(self,data):

   c = self.cent
   for k in range()



  return labels

kmeans = MyKMeans(n_clusters=3)
kmeans.fit(data)
label = kmeans.predict(data)

plt.figure(figsize=(12, 12))
plt.scatter(data[:,0], data[:,1], c=label)
plt.axes().set_aspect('equal')
plt.show()

"""## UPGMA

Find two nearest points in a list, conect them and replace them with their average.

Usefull functions:

> sklearn.metrics.pairwise_distances

> np.argmin

> np.append / np.concatenate

> np.delete
"""

from sklearn.metrics import pairwise_distances
import numpy as np
import matplotlib.pyplot as plt

np.random.seed(101)

data=np.random.randn(10,2)
plt.plot(data[:,0],data[:,1],'*')

"""Create upgma clustering:"""



"""Apply scipy UPGMA to iris dataset and display results with dendrogram. (scipy.cluster.hierarchy.linkage/dendrogram)"""

