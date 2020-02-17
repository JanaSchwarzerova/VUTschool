#pragma once

#include <iostream>
#include <SFML/Graphics.hpp>
#include <SFML/System.hpp>
#include <vector>
#include <string>

using namespace std;
class LoadingData
{
public: 
	static sf::Image LoadData(int ImageStart, string Path, string ExtName);

};

