#include "SettingMouse.h"

void SettingMouse::onLeftButton(int x, int y) {
	SettingMouse::ynew = SettingMouse::yold + y - SettingMouse::yy;
	SettingMouse::xnew = SettingMouse::xold + x - SettingMouse::xx;
}

void SettingMouse::onRightButton(int x, int y) {
	SettingMouse::znew = SettingMouse::zold + y - SettingMouse::zz;
}



void SettingMouse::setXx(int xx) {
	SettingMouse::xx = xx;
}


void SettingMouse::setXold(int xold) {
	SettingMouse::xold = xold;
}


void SettingMouse::setYy(int yy) {
	SettingMouse::yy = yy;
}


void SettingMouse::setYold(int yold) {
	SettingMouse::yold = yold;
}


void SettingMouse::setZz(int zz) {
	SettingMouse::zz = zz;
}


void SettingMouse::setZold(int zold) {
	SettingMouse::zold = zold;
}

void SettingMouse::setState(State state)
{
	SettingMouse::state = state;
}

//void Mouse::setState(Mouse::State state) {
//	Mouse::state = state;
//}

int SettingMouse::getXnew() const {
	return SettingMouse::xnew;
}

int SettingMouse::getYnew() const {
	return SettingMouse::ynew;
}

int SettingMouse::getZnew() const {
	return SettingMouse::znew;
}

SettingMouse::State SettingMouse::getState() const
{
	return State();
}
