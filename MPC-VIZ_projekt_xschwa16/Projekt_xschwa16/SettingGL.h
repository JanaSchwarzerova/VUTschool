#pragma once

#include <iostream>
#include <SFML/Graphics.hpp>
#include <SFML/OpenGL.hpp>

class SettingGL
{
public:
	SettingGL();
	void transformObject(int xnew, int ynew, int znew);
};
