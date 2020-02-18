function PratialDigest(L)
width = max(L);
position = find(L==width);
L(position)=[];
X = [0 width];
Place(L,X)