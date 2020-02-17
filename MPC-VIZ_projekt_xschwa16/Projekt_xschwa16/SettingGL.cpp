#include "SettingGL.h"

SettingGL::SettingGL() {
	glClearDepth(1.0);
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glMatrixMode(GL_PROJECTION);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LESS);
	glLoadIdentity();
	glOrtho(0, 256, 0, 256, -99, 99);
	glDepthRange(-10, 10);
	glShadeModel(GL_SMOOTH);
	glPolygonMode(GL_FRONT, GL_FILL);
	glPolygonMode(GL_BACK, GL_FILL);
	glDisable(GL_CULL_FACE);

	//Setting lighting: 
	GLfloat Ambient[4] = { 0.5f, 0.5f, 0.5f, 0.0f };
	GLfloat Diffuse[4] = { 0.1f, 0.1f, 0.1f, 0.0f };
	GLfloat Shine[4] = { 0.1f, 0.1f, 0.1f, 0.0f };
	GLfloat ShineFactor[1] = { 30.0f };
	GLfloat lightposition[4] = { 1.0f, 1.0f, 1.0f, 0.0f };

	glMaterialfv(GL_FRONT, GL_AMBIENT, Ambient);
	glMaterialfv(GL_FRONT, GL_DIFFUSE, Diffuse);
	glMaterialfv(GL_FRONT, GL_SPECULAR, Shine);
	glMaterialfv(GL_FRONT, GL_SHININESS, ShineFactor);
	glLightfv(GL_LIGHT0, GL_POSITION, lightposition);

	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
};

void SettingGL::transformObject(int xnew, int ynew, int znew) {
	//glTranslatef(0.0, 0.0, -50.0f);
	glTranslatef(0.0, 0.0, znew);
	glRotatef(ynew, 1.0, 0.0, 0.0);
	glRotatef(xnew, 0.0, 1.0, 0.0);
}



