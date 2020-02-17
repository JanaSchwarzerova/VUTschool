// Projekt_xschwa16.cpp : Tento soubor obsahuje funkci main. Provádění programu se tam zahajuje a ukončuje.
//
// ZADÁNÍ: 
/*  1) Načítat sady řezů uložené v běžných obrazových formátech (*.png, *.jpg, *.gif)
	2) Na základě nastaveného prahu generovat souřadnice trojúhelníku aproximující povrch
	3) Stanovení normálových vektorů pro jednotlivé polygony
	4) Vykreslení polygonových dat do okna programu
	5) Základní manipulace s objektem (rotace, posun, volitelně zoom)
	6) Osvětelní scény
	7) Základní ovládání okna aplikace (změna velikosti okna, přepínání celoobrázkového režimu)
*/

////////////////////////////////////////////////////////////////////////////////////////////////////
// Author: Jana Schwarzerová, 186686										   deadline: 22.12. 2019
//                                                                             Language: EN 
// 

#include <iostream>
#include <SFML/Graphics.hpp>
#include <SFML/OpenGL.hpp>
#include <SFML/System.hpp>
#include <vector>
#include <string>

#include "LoadingData.h"
#include "MarchingCube.h"
#include "SettingGL.h"
#include "SettingMouse.h"

using namespace std;

// Function getIntesities are used for creating 3D intesity space
vector<vector<vector<float>>> getIntensities(const vector<sf::Image>& Input, const sf::Vector2u& velikost) {

	vector<vector<vector<float>>> Intensities;

	for (unsigned int x = 0; x < velikost.x; x++) {
		vector<vector<float>> Intensities_y;
		for (unsigned int y = 0; y < velikost.y; y++) {
			vector<float> Intensities_z;
			for (unsigned int z = 0; z < Input.size(); z++) {
				float Intensity = 0.299f * Input.at(z).getPixel(x, y).r + 0.587f * Input.at(z).getPixel(x, y).g + 0.114f * Input.at(z).getPixel(x, y).b;
				Intensities_z.push_back(Intensity);
			}
			Intensities_y.push_back(Intensities_z);
		}
		Intensities.push_back(Intensities_y);
	}
	return Intensities;
}

int main()
{
	//Path:
	string Path = "C:\\Users\\Jana\\Desktop\\Magisterské studium\\F-BTB\\2.ročník\\MPC-VIZ\\MPC-VIZ projekt\\ProjektData\\";;

	//From image number:
	int ImageStart = 1;
	//To image number: 
	int ImageEnd = 99;
	//Image type:
	string ExtName = ".png";
	//Threshold: 
	int Thresh = 125; 

	//Creating image array -> 3D
	vector<sf::Image> ImgSequence;
	for (int i = ImageStart; i <= ImageEnd; i++) {
		sf::Image ImgSeq = LoadingData::LoadData(i, Path, ExtName); //Loading data	
		ImgSequence.push_back(ImgSeq);
	}

	//Creating 3D intesity space: 
	sf::Image Img_3D = ImgSequence.at(0);
	sf::Vector2u ImgSize = Img_3D.getSize();
	vector<vector<vector<float>>> Intensities = getIntensities(ImgSequence, ImgSize);

	//TrianglesAndNormals is object, where is Triangles = array in array for triangles grid and Normals = array for normals
	TrianglesAndNormals Tri_Nor_Results = MarchingCube::getTriangles(Intensities, Thresh);

	//Context settings window:
	sf::ContextSettings ContextSettings;
	ContextSettings.antialiasingLevel = 2;
	ContextSettings.depthBits = 32;
	ContextSettings.stencilBits = 8;
	sf::Window window(sf::VideoMode(700, 600), "Projekt xschwa16", sf::Style::Close | sf::Style::Resize, ContextSettings);
	
	SettingMouse m;
	//Setting GL (There is setting lighting, too): 
	SettingGL::SettingGL();

	while (window.isOpen()) {
		sf::Event event;

		while (window.pollEvent(event)) {
			switch (event.type) {
			case sf::Event::Closed:
				window.close();
				break;
			case sf::Event::Resized:
				glViewport(0, 0, event.size.width, event.size.height);
				break;
			}
		}
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		glColor3f(1.0f, 0, 0);
		glBegin(GL_TRIANGLES);
		vector<sf::Vector3f> Triangle;

		//Drawing Triangles + Normals
		for (unsigned int Triangle_i = 0; Triangle_i < Tri_Nor_Results.Triangles.size(); Triangle_i++) {
			Triangle = Tri_Nor_Results.Triangles.at(Triangle_i);
			sf::Vector3f Normal = Tri_Nor_Results.Normals.at(Triangle_i);
			glNormal3f(Normal.x, Normal.y, Normal.z);
			glVertex3f(Triangle.at(0).x, Triangle.at(0).y, Triangle.at(0).z);
			glVertex3f(Triangle.at(1).x, Triangle.at(1).y, Triangle.at(1).z);
			glVertex3f(Triangle.at(2).x, Triangle.at(2).y, Triangle.at(2).z);
		}

		bool isFull = false;

		// Setting manipulation with window: 
		sf::Event Event;

		SettingGL object;

		while (window.pollEvent(Event))
		{
			switch (Event.type)
			{
			case sf::Event::Closed:
				window.close();
				break;
			case sf::Event::KeyPressed:
				switch (Event.key.code)
				{
				//If you press "esc", window closes
				case sf::Keyboard::Escape:
					window.close();
					break;
			//If you press "w", the image is drawn as fullscreen 
			case sf::Keyboard::W:
					if (isFull){
						window.create(sf::VideoMode(700, 600), "Projekt_xschwa16", sf::Style::Default);
						SettingGL::SettingGL();
						isFull = false;
					}
					else {
						window.create(sf::VideoMode(700, 600), "Projekt_xschwa16", sf::Style::Fullscreen);
						SettingGL::SettingGL();
						isFull = true;
					}
					break;
				}
			}
			//Mouse manipulation: 
			if (sf::Mouse::isButtonPressed(sf::Mouse::Left)) {
				if (Event.type == sf::Event::MouseButtonPressed) {
					m.setState(SettingMouse::State::Left);
					m.setXx(sf::Mouse::getPosition(window).x);
					m.setYy(sf::Mouse::getPosition(window).y);
				}
				m.onLeftButton(sf::Mouse::getPosition(window).x, sf::Mouse::getPosition(window).y);
			}
			if (sf::Mouse::isButtonPressed(sf::Mouse::Right)) {
				if (Event.type == sf::Event::MouseButtonPressed) {
					m.setState(SettingMouse::State::Right);
					m.setZz(sf::Mouse::getPosition(window).y);
				}
				m.onRightButton(sf::Mouse::getPosition(window).x, sf::Mouse::getPosition(window).y);
			}
			if (Event.type == sf::Event::MouseButtonReleased) {
				if (m.getState() == SettingMouse::State::Left) {
					m.setXold(m.getXnew());
					m.setYold(m.getYnew());
				}
				else if (m.getState() == SettingMouse::State::Right) {
					m.setZold(m.getZnew());
				}
				m.setState(SettingMouse::State::None);
			}

			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
			glEnd();
			glMatrixMode(GL_MODELVIEW);
			glLoadIdentity();

			object.transformObject(m.getXnew(), m.getYnew(), m.getZnew());
		}
		glFlush();
		window.display();
	}
	return 0;
}

