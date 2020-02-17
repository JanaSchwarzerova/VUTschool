#pragma once

#include <iostream>
#include <SFML/Graphics.hpp>
#include <SFML/System.hpp>
#include <vector>
#include <string>

#include "TrianglesAndNormals.h"

using namespace std;
class MarchingCube
{
public:
	static TrianglesAndNormals getTriangles(const vector<vector<vector<float>>>& Intensities, int Thresh);
	static sf::Vector3f getNormal(vector<sf::Vector3f>& Triangle);
	static sf::Vector3f Interpolation(sf::Vector3f CubeVertex1, sf::Vector3f CubeVertex2, float Intensity1, float Intensity2);

};

