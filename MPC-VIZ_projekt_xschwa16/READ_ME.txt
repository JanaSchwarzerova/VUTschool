//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Projekt_xschwa16.cpp : Tento soubor obsahuje funkci main. Prov�d�n� programu se tam zahajuje a ukon�uje.
// Autor: Jana Schwarzerov�, 186686
// ZAD�N�: 
/*      1) Na��tat sady �ez� ulo�en� v b�n�ch obrazov�ch form�tech (*.png, *.jpg, *.gif)
	2) Na z�klad� nastaven�ho prahu generovat sou�adnice troj�heln�ku aproximuj�c� povrch
	3) Stanoven� norm�lov�ch vektor� pro jednotliv� polygony
	4) Vykreslen� polygonov�ch dat do okna programu
	5) Z�kladn� manipulace s objektem (rotace, posun, voliteln� zoom)
	6) Osv�teln� sc�ny
	7) Z�kladn� ovl�d�n� okna aplikace (zm�na velikosti okna, p�ep�n�n� celoobr�zkov�ho re�imu)*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// VYPRACOV�N�: 

////////////////ad 1) 
/* Projekt_xschwa16.cpp, ��dek 55 se nastav� cesta k obr�zk�m, kter� chceme na��st
   57 � 64 jsou ��dky, kde si m��eme pozm�nit defaultn� nastaven�
   Algoritmus vy�e�en v LoadingData.h + LoadingData.cpp  */

////////////////ad 2) + ad 3)
/* Algoritmus vy�e�en v MarchingCube.h + MarchingCube.cpp */

////////////////ad 4 � 6) -> viz Projekt_xschwa16.cpp + SettingGL + SettingMouse
/* Rotace se prov�d� pomoc�:  my�� (SettingMouse):
	 pomoc� lev�ho tla��tka obrazem rotujeme (viz sn�mky � Screen01)
         pomoc� prav�ho tla��tka se posouv�me jednotliv�mi �ezy (viz sn�mky � Screen02)
	 dokonce jde obr�zkem rotovat a n�sledn� proch�zet jednotliv� �ezy (viz sn�mky � Screen03)
  Osv�tlen� sc�ny je zabudovan� do SettingGL.cpp (viz ��dek 17 a� 31)  */

////////////////ad 7) 
/* Program umo��uje p�epnut� na fullscreen pomoc� tla��tka "w"
   N�sledn� pomoc� "Esc" zav��t                                */