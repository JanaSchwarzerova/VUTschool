//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Projekt_xschwa16.cpp : Tento soubor obsahuje funkci main. Provádìní programu se tam zahajuje a ukonèuje.
// Autor: Jana Schwarzerová, 186686
// ZADÁNÍ: 
/*      1) Naèítat sady øezù uložené v bìžných obrazových formátech (*.png, *.jpg, *.gif)
	2) Na základì nastaveného prahu generovat souøadnice trojúhelníku aproximující povrch
	3) Stanovení normálových vektorù pro jednotlivé polygony
	4) Vykreslení polygonových dat do okna programu
	5) Základní manipulace s objektem (rotace, posun, volitelnì zoom)
	6) Osvìtelní scény
	7) Základní ovládání okna aplikace (zmìna velikosti okna, pøepínání celoobrázkového režimu)*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// VYPRACOVÁNÍ: 

////////////////ad 1) 
/* Projekt_xschwa16.cpp, øádek 55 se nastaví cesta k obrázkùm, které chceme naèíst
   57 – 64 jsou øádky, kde si mùžeme pozmìnit defaultní nastavení
   Algoritmus vyøešen v LoadingData.h + LoadingData.cpp  */

////////////////ad 2) + ad 3)
/* Algoritmus vyøešen v MarchingCube.h + MarchingCube.cpp */

////////////////ad 4 – 6) -> viz Projekt_xschwa16.cpp + SettingGL + SettingMouse
/* Rotace se provádí pomocí:  myší (SettingMouse):
	 pomocí levého tlaèítka obrazem rotujeme (viz snímky – Screen01)
         pomocí pravého tlaèítka se posouváme jednotlivými øezy (viz snímky – Screen02)
	 dokonce jde obrázkem rotovat a následnì procházet jednotlivé øezy (viz snímky – Screen03)
  Osvìtlení scény je zabudované do SettingGL.cpp (viz øádek 17 až 31)  */

////////////////ad 7) 
/* Program umožòuje pøepnutí na fullscreen pomocí tlaèítka "w"
   Následnì pomocí "Esc" zavøít                                */