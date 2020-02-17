#pragma once

#include <iostream>
#include <SFML/Graphics.hpp>
#include <SFML/System.hpp>
#include <vector>
#include <string>

using namespace std;

class TrianglesAndNormals
{
public: 
	vector<vector<sf::Vector3f>> Triangles;
	vector<sf::Vector3f> Normals;

};

