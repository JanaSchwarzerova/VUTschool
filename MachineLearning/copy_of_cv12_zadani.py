# -*- coding: utf-8 -*-
"""Copy of cv12_zadani.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1TxDQsws_B760sJ5IjqjAruwjsB5ygZc2

#  Cvičení 12 - Rekurentní sítě, LSTM, aplikace na genomická data

## Pytorch RNN from scratch (with nn.Module)
"""

import numpy as np
import matplotlib.pyplot as plt

##### generate testing sequnaces - output is sum of last n input values + bias
input_seqs=[]
output_seqs=[]

num_of_seq=50
min_max_len=[10,20]
range_of_num=[0,7]
sum_last_n=3
bias=1

for k in range(num_of_seq):
  seq_len=np.random.randint(min_max_len[0],min_max_len[1])
  input_seq=np.random.randint(range_of_num[0],range_of_num[1],size=seq_len)
  output_seq=[]
  for kk in range(seq_len):
    tmp=np.sum(input_seq[np.maximum(0,kk-sum_last_n+1):kk+1])+bias
    output_seq.append(tmp)
    
  input_seqs.append(np.array(input_seq).astype(np.float32))
  output_seqs.append(np.array(output_seq).astype(np.float32))
  
input_seqs=input_seqs
output_seqs=output_seqs
  
train_in=input_seqs[:40]
train_out=output_seqs[:40]

test_in=input_seqs[40:]
test_out=output_seqs[40:]

print(train_in[5])
print(train_out[5])


plt.plot(train_in[5])
plt.plot(train_out[5])
plt.show()

"""Create single RNN unit using nn.Module

initialize parameters $W_x, W_y, W_h, b_y, b_h$

forward  $(x_k,h_{k-1}) => (y_k,h_{k})$

$h_{k}=tanh(W_x x + W_h h_{k-1} + b_h)$

$y_k=g(W_h h + b_y)$ 

($g$ is identity)
"""

import torch.nn as nn
import torch.nn.functional as F 
import torch


class RNN_unit(nn.Module):
  def __init__(self,x_size,h_size,y_size):
    super(RNN_unit, self).__init__()
    self.h_size=h_size #potřebuji si ho vytvořit abych ho následně mohla použít v metodě při definování init_h

    self.Wx = nn.Parameter(0.001 *torch.randn(h_size,x_size));
    self.Wy = nn.Parameter(0.001 *torch.randn(y_size,h_size));
    self.Wh = nn.Parameter(0.001 *torch.randn(h_size,h_size));  
    self.bh = nn.Parameter(0.001 *torch.randn(h_size,1)); 
    self.by = nn.Parameter(0.001 *torch.randn(y_size,1)); 

  def forward(self, x):
    self.h = torch.tanh(self.Wx@x + self.Wh@h +self.bh);          
    y = (self.Wy@h+self.by);    
    return y

  def init_h(self): #funkce pro inicializaci (vynulování) vektoru h
    self.h = torch.zeros(self.h_size, 1);

"""Train simple RNN with 1 unit for sequence to sequnce translation

initialize $h_0$

sequntialy aplly RNN  $(x_k,h_{k-1}) => (y_k,h_{k})$
"""

import torch.nn as nn
import torch.nn.functional as F 
import torch
import numpy as np
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace
import torch.optim as optim


hiden_dim=500

rnn_unit=RNN_unit(1,hiden_dim,1)

optimizer = optim.SGD(rnn_unit.parameters(), lr=0.0001,momentum=0.5)

scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=100, gamma=0.1)

for k in range(200):
  
  optimizer.zero_grad()
  
  for ind_batch in range(64):
  
    #### forward and beckward propagataion

    ind=np.random.randint(low=1,high=len(train_in));

    xx= train_in[ind];
    N = len(xx);
    tt = train_out[ind];

    xx=torch.Tensor(xx)
    tt = torch.Tensor(tt)

    rnn_unit.init_h()

    xx.requires_grade=True
    tt.requires_grade=True

    yy={}

    for kk in range(len(xx)): 
      x = torch.from_numpy(xx[kk].reshape((-1,1))); #potřeba reshape na 1x1 aby šly počítat matice
      y = rnn_unit(x)
      yy.append(y)
      yy=torch.cat(yy, dim=1) #Příkaz na kontaktenaci 

      loss=torch.mean((yy-tt)**2) #loss bude mean square
      loss.backwar()



    optimizer.step()
    scheduler.step()

    plt.plot(tt.detach().numpy(),"r")
    plt.plot(yy.detach().numpy(),"h")
    plt.plot(xx.detach().numpy(),"g")
    plt.title('train' + str(k))
    plt.show()
  
  
  
  #### test forward propagation


  # plt.plot(tt.detach().numpy())
  # plt.plot(yy.detach().numpy())
  # plt.plot(xx.detach().numpy())
  # plt.title('test')
  # plt.show()

"""## Pytorch Built-in LSTM"""

import torch.nn as nn
import torch.nn.functional as F 
import torch


class LSTM(nn.Module):
  def __init__(self,x_size,h_size,y_size,lstm_layers):
    super(LSTM, self).__init__()
    
    self.lstm_layers=lstm_layers
    self.h_size=h_size

    self.lstm=nn.LSTM(1,hiden_dim,batch_first=True,num_layers=self.lstm_layers)    
    
    self.linear=nn.Linear(h_size,y_size)

  def forward(self, x):
    
    y,(self.h,self.c)=self.lstm(x,(self.h,self.c))
    
    y=self.linear(y)
        
    return y
  
  def init_hiden(self,batch):
    self.h=torch.zeros((self.lstm_layers, batch, self.h_size))
    self.c=torch.zeros((self.lstm_layers, batch, self.h_size))

import torch.nn as nn
import torch.nn.functional as F 
import torch
import numpy as np
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace
import torch.optim as optim

from torch.nn.utils.rnn import pad_sequence
from torch.nn.utils.rnn import pack_sequence

hiden_dim=300
batch=128
lstm_layers=1

rnn_unit=LSTM(1,hiden_dim,1,lstm_layers)

optimizer = optim.SGD(rnn_unit.parameters(), lr=0.01,momentum=0.9)
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=100, gamma=0.1)

for k in range(300):
  

  ### training step



  ### get batch of data
  ind=np.random.randint(low=0,high=len(train_in),size=batch)
  xx=[]
  tt=[]
  for i in ind:
    xx.append(torch.Tensor(train_in[i].reshape((train_in[i].shape[0],1))))
    tt.append(torch.Tensor(train_out[i].reshape((train_out[i].shape[0],1))))
  xx=pad_sequence(xx,batch_first=True)
  tt=pad_sequence(tt,batch_first=True,padding_value=-1)
  
  xx.shape

  ###apply the network
  rnn_unit.init_hiden(batch)
  xx.requires_grad=True
  tt.requires_grad=True


  #APLIKACE V ČASE: na jednotlivé vzorky, jednotlivě
  #sequential version - can be useful in some cases
  # yy=[]
  # for kk in range(list(xx.size())[1]):
  #   x=xx[:,kk].view(-1,1,1)
  #   y=rnn_unit(x)
  #   yy.append(y)
  # yy=torch.cat(yy,1).squeeze()

  #network can also process whole sequence automaticaly
  yy=rnn_unit(xx)

  loss=(tt-yy)**2
  loss=loss[tt!=-1] #### remove padded values
  loss=torch.mean(loss)
  

  #### update weigths
  optimizer.zero_grad()
  loss.backward()
  nn.utils.clip_grad_norm_(rnn_unit.parameters(), 1) #projede všechny gradienty a jejich délku zmenší na 1
  optimizer.step()
  scheduler.step()

  plt.plot(tt[0,:].detach().numpy())
  plt.plot(yy[0,:].detach().numpy())
  plt.plot(xx[0,:].detach().numpy())
  plt.title('train' + str(k))
  plt.show()
  
  
  
  #### testing step



  ### get batch of data
  ind=np.random.randint(low=0,high=len(test_in),size=1)
  xx=[]
  tt=[]
  for i in ind:
    xx.append(torch.Tensor(test_in[i].reshape((test_in[i].shape[0],1))))
    tt.append(torch.Tensor(test_out[i].reshape((test_out[i].shape[0],1))))
  xx=pad_sequence(xx,batch_first=True)
  tt=pad_sequence(tt,batch_first=True,padding_value=-1)
  
  ### aply the network
  rnn_unit.init_hiden(1)
  xx.requires_grad=True
  tt.requires_grad=True

  yy=rnn_unit(xx)

  plt.plot(tt[0,:].detach().numpy())
  plt.plot(yy[0,:].detach().numpy())
  plt.plot(xx[0,:].detach().numpy())
  plt.title('test' + str(k))
  plt.show()

"""## LSTM protein secondary structure prediction"""

from google.colab import drive
drive.mount('/content/drive')

"""Dataset description

https://www.princeton.edu/~jzthree/datasets/ICML2014/

input an  output is already one-hot encoded




features are amino acids, labels is secondary structre  -  last one is no sequence (padding value)
"""

import numpy as np

f = '/content/drive/My Drive/cullpdb+profile_6133_filtered.npy.gz'
data=np.load(f).reshape(-1, 700, 57)

num_features = 43
num_samples = data.shape[0]


seqs =data[:, :, 0:22].copy()

labels = data[:, :, 22:31].copy()


#### 9 class -> 4 class  H, C E
labels1=np.max(labels[:,:,[5,3]],axis=2)
labels2=np.max(labels[:,:,[0,7,6,4]],axis=2)
labels3=np.max(labels[:,:,[2,1]],axis=2)
labels4=np.max(labels[:,:,[8]],axis=2)
labels=np.stack((labels1,labels2,labels3,labels4),axis=2)


del data 


print('samples x length x features')
print(seqs.shape)


print('features in one time point:')
print(seqs[0,0,:])

print('samples x length x onehot')
print(labels.shape)

print('label in one time point:')
print(labels[0,0,:])


ind=np.random.rand(seqs.shape[0])>0.2
seqs_train = seqs[ind,:,:] #daty jsou ty trénovací data, z kterých vemu batch
labels_train = labels[ind,:,:]

seqs_test = seqs[ind==0,:,:]
labels_test = labels[ind==0,:,:]

print('frequency of each label')
print(np.mean(labels,axis=(0,1)))

del seqs
del labels


plt.figure(figsize=(15, 15))
plt.imshow(labels_train[0,:100,:].T)
plt.show()

import torch.nn as nn
import torch.nn.functional as F 
import torch


class LSTM(nn.Module):
  def __init__(self,x_size,h_size,y_size,lstm_layers=3):
    super(LSTM, self).__init__()
    
    self.lstm_layers=lstm_layers
    self.h_size=h_size

    self.lstm=nn.LSTM(1,hiden_dim,batch_first=True,num_layers=self.lstm_layers)    
    
    self.linear=nn.Linear(h_size,y_size)

  def forward(self, x):
    
    y,(self.h,self.c)=self.lstm(x,(self.h,self.c))
    
    y=self.linear(y)

      # B x n x dim 
      # B x n x 4  <= samples x length x onehot = (5534, 700, 4)
    y=torch.softmax(y, dim=2)

    return y
  
  def init_hiden(self,batch):
    self.h=torch.zeros((self.lstm_layers, batch, self.h_size))
    self.c=torch.zeros((self.lstm_layers, batch, self.h_size))

import torch.nn as nn
import torch.nn.functional as F 
import torch
import numpy as np
import matplotlib.pyplot as plt
from IPython.core.debugger import set_trace
import torch.optim as optim


hiden_dim=200
batch=128
net=LSTM(seqs_train.shape[2],hiden_dim,labels_train.shape[2]).cuda()
optimizer = optim.Adam(net.parameters(), lr=0.001,weight_decay=1e-6)
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=600, gamma=0.1)



for k in range(1300):
  net.train()
  
  
  
  ind=np.random.randint(low=0,high=seqs_train.shape[0],size=batch)
  xx=torch.Tensor(seqs_train[ind,:,:].astype(np.float32)).cuda()
  tt=torch.Tensor(labels_train[ind,:,:].astype(np.float32)).cuda()

  net.init_hiden(batch)
  

  #### training forward pass
  ind=np.random.randint(low=0,high=len(train_in),size=batch)
  xx=[]
  tt=[]
  for i in ind:
    xx.append(torch.Tensor(train_in[i].reshape((train_in[i].shape[0],1))))
    tt.append(torch.Tensor(train_out[i].reshape((train_out[i].shape[0],1))))
    xx=pad_sequence(xx,batch_first=True)
    tt=pad_sequence(tt,batch_first=True,padding_value=-1)
  
    xx.shape
    ###apply the network
    rnn_unit.init_hiden(batch)
    xx.requires_grad=True
    tt.requires_grad=True

    #network can also process whole sequence automaticaly
    yy=rnn_unit(xx)

    loss=torch.mean(tt*torch.log(yy))   

    optimizer.zero_grad()
    loss.backward()
    nn.utils.clip_grad_norm_(net.parameters(), 1)
    optimizer.step()
    scheduler.step()
  
  if k%20==0:
    for k_test in range(10):
      net.eval()


      ind=np.random.randint(low=0,high=seqs_test.shape[0],size=batch)

      xx=torch.Tensor(seqs_test[ind,:,:].astype(np.float32)).cuda()
      tt=torch.Tensor(labels_test[ind,:,:].astype(np.float32)).cuda()

      net.init_hiden(batch)

      #### testing forward pass
      

      ### get batch of data
      ind=np.random.randint(low=0,high=len(test_in),size=1)
      xx=[]
      tt=[]
      for i in ind:
        xx.append(torch.Tensor(test_in[i].reshape((test_in[i].shape[0],1))))
        tt.append(torch.Tensor(test_out[i].reshape((test_out[i].shape[0],1))))
      xx=pad_sequence(xx,batch_first=True)
      tt=pad_sequence(tt,batch_first=True,padding_value=-1)
  
      ### aply the network 
      rnn_unit.init_hiden(1)
      xx.requires_grad=True
      tt.requires_grad=True

      yy=rnn_unit(xx)
    
    plt.figure(figsize=(15, 15))
    plt.imshow(tt[0,:100,:].T)
    plt.show()
    
    plt.figure(figsize=(15, 15))
    plt.imshow(yy[0,:100,:].T,vmin=0,vmax=1)
    plt.show()