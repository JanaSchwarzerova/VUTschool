# -*- coding: utf-8 -*-
"""Copy of cv10_zadani.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/16EZQv0AAoBRPRtqIldal-LKdZG0ZQDyl

# Cvičení 10 - standardní konstrukce sítí v pytorch - batch,dataloader, klasifikační síť

Z minulého cvičení:
"""

import numpy as np
import torch
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace


rng = np.random.RandomState(1)
X = 5 * rng.rand(150)
Y = np.sin(X).ravel()
Y[::10] += 3 * (0.5 - rng.rand(15))
Y=Y+0.1*np.random.randn(150)



n=1000           
 
mu=0.0001     

std=0.1
W1=std*torch.randn(n,1)
b1=std*torch.randn(n,1)

W2=std*torch.randn(n,n)
b2=std*torch.randn(n,1)

W3=std*torch.randn(1,n)
b3=std*torch.randn(1,1)


W1=W1.cuda()
W2=W2.cuda()
W3=W3.cuda()

b1=b1.cuda()
b2=b2.cuda()
b3=b3.cuda()


W1.requires_grad=True
W2.requires_grad=True
W3.requires_grad=True

b1.requires_grad=True
b2.requires_grad=True
b3.requires_grad=True





for k in range(10000):
  ind=np.random.randint(0,150)

  x=X[ind].reshape((1,1))
  y=Y[ind].reshape((1,1))

  x=torch.from_numpy(x.astype(np.float32))
  y=torch.from_numpy(y.astype(np.float32))

  x=x.cuda()
  y=y.cuda()

  x.requires_grad=True
  y.requires_grad=True


  h0=x

  a1=W1@h0+b1
  h1=a1*(a1>0)

  a2=W2@h1+b2
  h2=a2*(a2>0)
  
  a3=W3@h2+b3
  h3=a3

  y_hat=h3

  L=0.5*(y_hat-y)**2

  L.backward()

  with torch.no_grad():
    W1-=mu*W1.grad
    b1-=mu*b1.grad
    W2-=mu*W2.grad
    b2-=mu*b2.grad
    W3-=mu*W3.grad
    b3-=mu*b3.grad

  W1.grad.zero_()
  b1.grad.zero_() 
  W2.grad.zero_()
  b2.grad.zero_()
  W3.grad.zero_()
  b3.grad.zero_()

  if k%50==0:
    with torch.no_grad():
      xx=np.linspace(0.5,4.5,200)
      yy=[]
      for kk in range(len(xx)):

        x=xx[kk].reshape((1,1))
        x=torch.from_numpy(x.astype(np.float32))

        x=x.cuda()

        h0=x

        a1=W1@h0+b1
        h1=a1*(a1>0)

        a2=W2@h1+b2
        h2=a2*(a2>0)
        
        a3=W3@h2+b3
        h3=a3

        y_hat=h3
        yy.append(y_hat.cpu().detach().numpy())

      plt.plot(X,Y,'*')
      plt.plot(xx,np.array(yy).ravel(),'*')
      plt.show()

"""## Inheritance

Inheritance allows us to define a class that inherits all the methods and properties from another class.
"""

class ParentClass():
  def __init__(self,q):
    self.parentAtribute = q

  def parentMethod(self):

    print('parentMethod')
    
    
class ChildClass(ParentClass):
  def __init__(self,q):
#     ParentClass.__init__(self, q)
    super().__init__(q)
    
    self.childAtribute=5

  def childMethod(self):
    print('childMethod')    
    
    
child=ChildClass(5)

child.parentMethod()

child.childMethod()

print(child.parentAtribute)

"""## nn.Module

Class torch.nn.Module contains basic operations of torch neural networks.
Base class for all neural network modules.
Your models should also subclass this class.
Modules can also contain other Modules, allowing to nest them in a tree structure. You can assign the submodules as regular attributes.
For construction of a network you need to inherite module class and overwrite init and forward methods
"""

#####standard pytorch import
import torch
import torch.nn as nn #Z pytorch potřebujeme vždy tyto dvě části... to kde jsou parametry: torch.nn .. všechno co je nn se bude muset vždy první inicializovat
import torch.nn.functional as F   #všechno co je F se dá použít kdekoliv 

class Net(nn.Module):

    def __init__(self):
        super(Net, self).__init__()

        self.W1=nn.Parameter(std*torch.randn(n,1))
        self.b1=nn.Parameter(std*torch.randn(n,1))
        self.W2=nn.Parameter(std*torch.randn(n,n))
        self.b2=nn.Parameter(std*torch.randn(n,1))
        self.W3=nn.Parameter(std*torch.randn(1,n))
        self.b3=nn.Parameter(std*torch.randn(1,1))
        ### here you have to initialize all parameters and submodules
        ### nn.Parameter is special type of tensor for storage of parameters
        ### there are many avaliable submodules - e.g. nn.Linear, nn.Conv2d, nn.ReLU..... 

    def forward(self, x):
        ### here you have to implement all calculations of the network
        
        h0=x
        a1=self.W1@h0+self.b1
        h1=a1*(a1>0)
        a2=self.W2@h1+self.b2
        h2=a2*(a2>0)
        a3=self.W3@h2+self.b3
        h3=a3
        y_hat=h3
        return x

import numpy as np
import torch
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace


rng = np.random.RandomState(1)
X = 5 * rng.rand(150)
Y = np.sin(X).ravel()
Y[::10] += 3 * (0.5 - rng.rand(15))
Y=Y+0.1*np.random.randn(150)

n=1000           
 
mu=0.0001     
net = Net()

optimizer= torch.optim.SGD(net.parameters(), lr=mu)

y_hat= net(x)
y_hat = net.forward(x) 

for k in range(10000):
  ind=np.random.randint(0,150)

  x=X[ind].reshape((1,1))
  y=Y[ind].reshape((1,1))

  x=torch.from_numpy(x.astype(np.float32))
  y=torch.from_numpy(y.astype(np.float32))

  x=x.cuda()
  y=y.cuda()

  x.requires_grad=True
  y.requires_grad=True

  L=0.5*(y_hat-y)**2

  L.backward()

  #projede mi všechny parametry
  optimal.step()
  net.zero_graf()

  if k%50==0:
    with torch.no_grad():
      xx=np.linspace(0.5,4.5,200)
      yy=[]
      for kk in range(len(xx)):

        x=xx[kk].reshape((1,1))
        x=torch.from_numpy(x.astype(np.float32))

        x=x.cuda()

        h0=x

        a1=W1@h0+b1
        h1=a1*(a1>0)

        a2=W2@h1+b2
        h2=a2*(a2>0)
        
        a3=W3@h2+b3
        h3=a3

        y_hat=h3
        yy.append(y_hat.cpu().detach().numpy())


      plt.plot(X,Y,'*')
      plt.plot(xx,np.array(yy).ravel(),'*')
      plt.show()

"""## Batch"""

import torch
import torch.nn as nn
import torch.nn.functional as F  

class Net(nn.Module):

  def __init__(self,n=1000):
    super(Net, self).__init__()
    #Modifikace: 
    n = 1000
    std = 0.1

    self.l1=nn.Linear(1,n)
    self.l2=nn.Linear(n,n)
    self.l3=nn.Linear(n,1)   

  def forward(self, x):
    #Modifikace:
    x=self.l1(x)
    x=F.relu(x)

    x=self.l2(x)
    x=F.relu(x)

    x=self.l3(x) #zde nemusí být relu, jelikož zde je ten lineární neuron    
    return x

import numpy as np
import torch
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace


rng = np.random.RandomState(1)
X = 5 * rng.rand(150)
Y = np.sin(X).ravel()
Y[::10] += 3 * (0.5 - rng.rand(15))
Y=Y+0.1*np.random.randn(150)

n=1000           
 
mu=0.0001     
net = Net()

optimizer= torch.optim.SGD(net.parameters(), lr=mu)

hatch_size=32

for k in range(10000):
  ind=np.random.randint(0,150,size=32)

  x=X[ind].reshape((-1,1))
  y=Y[ind].reshape((-1,1))

  x=torch.from_numpy(x.astype(np.float32))
  y=torch.from_numpy(y.astype(np.float32))

  x=x.cuda()
  y=y.cuda()

  x.requires_grad=True
  y.requires_grad=True

  y_hat= net.forward(x)
  L=torch.mean(0.5*(y_hat-y)**2)
  L.backward()

  #projede mi všechny parametry
  optimizer.step()
  net.zero_graf()

  if k%50==0:
    with torch.no_grad():
      xx=np.linspace(0.5,4.5,200)
      yy=[]
      for kk in range(len(xx)):

        x=xx[kk].reshape((1,1))
        x=torch.from_numpy(x.astype(np.float32))

        x=x.cuda()

        h0=x

        a1=W1@h0+b1
        h1=a1*(a1>0)

        a2=W2@h1+b2
        h2=a2*(a2>0)
        
        a3=W3@h2+b3
        h3=a3

        y_hat=h3
        yy.append(y_hat.cpu().detach().numpy())


      plt.plot(X,Y,'*')
      plt.plot(xx,np.array(yy).ravel(),'*')
      plt.show()

"""## Dataloader

For large datasets, it is not possible to store evverything in memory. Dataloaders allow for fast paralelized lodaning of data from disk. Inside dataloader any nessesery preprocessing can be done.

You can use some online avaliable datasets, store data in standart format, or create custom dataloader

To create custom dataloader, you can modify torch.utils.data.Dataset - overwrite init, len and getitem methods.
"""

import numpy as np
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace

import torch
import torch.nn as nn
import torch.nn.functional as F  
import torch.optim as optim


from torch.utils import data


class DataLoader(data.Dataset):
    def __init__(self, split="train",path_to_data=''):
      self.split = split  ## train or test images? 
      self.num_of_imgs=6
    ##here you need to store paths to data, number data 
    
    def __len__(self):
        return self.num_of_imgs
    
    
    
    def __getitem__(self, index): 
      img=torch.ones((5,5))
      lbl=torch.ones(1)
      return img,lbl
    #load and preprocess one image - with number index
    #torchvision.transforms  contains several preprocessing functions for images

    
    

loader = DataLoader(split='training',path_to_data='data')
trainloader= data.DataLoader(loader,batch_size=2, num_workers=0, shuffle=True,drop_last=True)


for it,(batch,lbls) in enumerate(trainloader): ### you can iterate over dataset (one epoch)
  print(batch)
  print(batch.size())
  print(lbls)
  
  
# data=next(iter(trainloader))   ### or create iterator and get samples with next

"""### Create custom dataloader for MNIST data"""

#### this can be used, however, we will create custom dataloader
loader = torch.utils.data.DataLoader(torchvision.datasets.MNIST('/files/', train=True, download=True,transform=torchvision.transforms.ToTensor()),batch_size=1, shuffle=True)

#### mount google drive
from google.colab import drive
drive.mount('/content/drive')

### extract mnist in png format  - setupsource and destination path
!unzip '/content/drive/My Drive/mnist_png_small_200_20.zip' -d '/content/drive/My Drive'

### try to load one image
from skimage.io import imread
import matplotlib.pyplot as plt
import numpy as np

img=imread('/content/drive/My Drive/mnist_png_small_200_20/testing/0/10.png')

plt.imshow(img)
plt.show()

### try to sarch png files in folder
import glob
png_files=glob.glob('/content/drive/My Drive/mnist_png_small_200_20/testing/0/*.png')

print(png_files)

import os

os.sep

import numpy as np
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace

import torch
import torch.nn as nn
import torch.nn.functional as F  
import torch.optim as optim

import glob
import os
from skimage.io import imread

from torch.utils import data


class DataLoader(data.Dataset):
    def __init__(self, split="training"):
      path_to_data='/content/drive/My Drive/mnist_png_small_200_20'
      self.split=split
      self.path=path_to_data + '/' + split 
      
      self.cesty=[]
      self.lbls=[]
      for k in range(10):
        tmp=glob.glob(self.path+'/'+str(k)+'/*.png')
        self.cesty=self.cesty+tmp
        self.lbls=self.lbls+[k]*len(self.cesty)
      #glob.glob() #Prohledá složku a vrátí všechny soubory co v té složce jsou
    
      self.num_of_imgs=len(self.cesty)

    def __len__(self):
      return self.num_of_imgs
    
    
    
    def __getitem__(self, index): 
      img=imread(self.cesty[index])

      #pomocí reshape na tvar 1 x m x n
      #a ještě převod float32
      #potom převést za (0-255) na (-0.5-0.5)
      img=img.reshape((1,img.shape[0],img.shape[1]))
      img=img.astype(np.float32)
      img = (img/255)-0.5
      img = torch.from_numpy(img)

      #A převést ho na tenzor 

      #0 1 2 3 4 5
      #0 0 1 0 0 0 ... pro dvě 

      tmp=self.lbls[index]
      lbl = np.zeros(10)
      lbl[tmp]=1
      lbl=lbl.astype(np.float32)
      lbl=torch.from_numpy(lbl)

      return img,lbl


    
    

loader = DataLoader(split='training')
trainloader= data.DataLoader(loader,batch_size=2, num_workers=0, shuffle=True,drop_last=True)


for it,(batch,lbls) in enumerate(trainloader): ### you can iterate over dataset (one epoch)
  print(batch)
  print(batch.size())
  print(np.argmax(lbls.detach().cpu().numpy(),axis=1))
  plt.imshow(batch[0,0,:,:].detach().cpu().numpy())
  plt.show()
  break




loader = DataLoader(split='testing')
testloader= data.DataLoader(loader,batch_size=2, num_workers=0, shuffle=True,drop_last=True)


for it,(batch,lbls) in enumerate(testloader): ### you can iterate over dataset (one epoch)
  print(batch)
  print(batch.size())
  print(np.argmax(lbls.detach().cpu().numpy(),axis=1))
  plt.imshow(batch[0,0,:,:].detach().cpu().numpy())
  plt.show()
  break

"""## Classification network

Create classification network for MNIST dataset.
"""

#### define network

import torch.nn as nn
import torch.nn.functional as F 


class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()


    def forward(self, x):

        return x

#### training loop


import numpy as np
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace

import torch
import torch.nn as nn
import torch.nn.functional as F  
import torch.optim as optim
import torchvision
from torchvision import transforms

import glob
import os
from skimage.io import imread

from torch.utils import data

batch=128

# transform=transforms.Compose([ transforms.ToTensor(),transforms.Normalize((0.1307,), (0.3081,))])
# dataset=torchvision.datasets.MNIST('/files/', train=True, download=True,transform=transform)
# trainloader = torch.utils.data.DataLoader(dataset,batch_size=batch,num_workers=0, shuffle=True,drop_last=True)
# dataset=torchvision.datasets.MNIST('/files/', train=False, download=True,transform=transform)
# testloader = torch.utils.data.DataLoader(dataset,batch_size=batch,num_workers=0, shuffle=True,drop_last=True)


dataset=DataLoader(split="training")
trainloader = torch.utils.data.DataLoader(dataset,batch_size=batch,num_workers=4, shuffle=True,drop_last=True)
dataset=DataLoader(split="testing")
testloader = torch.utils.data.DataLoader(dataset,batch_size=batch,num_workers=4, shuffle=False,drop_last=True)