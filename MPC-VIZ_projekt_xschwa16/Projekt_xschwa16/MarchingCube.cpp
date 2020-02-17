#include "MarchingCube.h"
#include "LUT.h"
#include "TrianglesAndNormals.h"
#include <SFML/System.hpp>
#include <vector>

using namespace std;

//Marching Cube Algorithm 
TrianglesAndNormals MarchingCube::getTriangles(const vector<vector<vector<float>>>& Intensities, int Thresh) {

	//Declaration triangles grid: 
	vector<vector<sf::Vector3f>> Triangles;
	//Declaration normals vector grid:
	vector<sf::Vector3f> Normals;

	// Indexing the cube vertex; Inspiration by http://paulbourke.net/geometry/polygonise/  
		/*			   4
				 4-----------5
				/|          /|
			   / |8    B   / |9
			 7/  |     0  /5 |
			 /   0-------/---1
			7---/-------6   /
			|  /3       |  /1
		  11| /   F   10| /
			|/          |/
			3-----------2
				  2						 */

	for (unsigned int x = 0; x < Intensities.size() - 1; x++) {
		for (unsigned int y = 0; y < Intensities.at(x).size() - 1; y++) {
			for (unsigned int z = 0; z < Intensities.at(x).at(y).size() - 1; z++) {

			//Indexing intensity: 
			float Intensity_0 = Intensities.at(x + 0).at(y + 0).at(z + 0);
			float Intensity_1 = Intensities.at(x + 1).at(y + 0).at(z + 0);
			float Intensity_2 = Intensities.at(x + 1).at(y + 1).at(z + 0);
			float Intensity_3 = Intensities.at(x + 0).at(y + 1).at(z + 0);
			float Intensity_4 = Intensities.at(x + 0).at(y + 0).at(z + 1);
			float Intensity_5 = Intensities.at(x + 1).at(y + 0).at(z + 1);
			float Intensity_6 = Intensities.at(x + 1).at(y + 1).at(z + 1);
			float Intensity_7 = Intensities.at(x + 0).at(y + 1).at(z + 1);

			//Thresholding:
			int cubeindex = 0;
			if (Intensity_0 > Thresh) cubeindex |= 1;
			if (Intensity_1 > Thresh) cubeindex |= 2;
			if (Intensity_2 > Thresh) cubeindex |= 4;
			if (Intensity_3 > Thresh) cubeindex |= 8;
			if (Intensity_4 > Thresh) cubeindex |= 16;
			if (Intensity_5 > Thresh) cubeindex |= 32;
			if (Intensity_6 > Thresh) cubeindex |= 64;
			if (Intensity_7 > Thresh) cubeindex |= 128;


				// Cube is entirely in/out of the surface 
				if (LUT::EdgeTable[cubeindex] != 0) {
					sf::Vector3f TriangleVerticies[12];

					//Cube vertex: 
					sf::Vector3f CubeVertex_0(x + 0, y + 0, z + 0);
					sf::Vector3f CubeVertex_1(x + 1, y + 0, z + 0);
					sf::Vector3f CubeVertex_2(x + 1, y + 1, z + 0);
					sf::Vector3f CubeVertex_3(x + 0, y + 1, z + 0);
					sf::Vector3f CubeVertex_4(x + 0, y + 0, z + 1);
					sf::Vector3f CubeVertex_5(x + 1, y + 0, z + 1);
					sf::Vector3f CubeVertex_6(x + 1, y + 1, z + 1);
					sf::Vector3f CubeVertex_7(x + 0, y + 1, z + 1);

					// Find the vertices where the surface intersects the cube 
					if (LUT::EdgeTable[cubeindex] & 1)
						//With interpolation: 
						TriangleVerticies[0] = MarchingCube::Interpolation(CubeVertex_0, CubeVertex_1, Intensity_0, Intensity_1);
						//Without interpolation: 
						//TriangleVerticies[0] = (CubeVertex_0 + ((CubeVertex_1 - CubeVertex_0) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 2)
						//With interpolation: 
						TriangleVerticies[1] = MarchingCube::Interpolation(CubeVertex_1, CubeVertex_2, Intensity_1, Intensity_2);
						//Without interpolation: 
						//TriangleVerticies[1] = (CubeVertex_1 + ((CubeVertex_2 - CubeVertex_1) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 4)
						//With interpolation: 
						TriangleVerticies[2] = MarchingCube::Interpolation(CubeVertex_2, CubeVertex_3, Intensity_2, Intensity_3);
						//Without interpolation:
						//TriangleVerticies[2] = (CubeVertex_2 + ((CubeVertex_3 - CubeVertex_2) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 8)
						//With interpolation: 
						TriangleVerticies[3] = MarchingCube::Interpolation(CubeVertex_3, CubeVertex_0, Intensity_3, Intensity_0);
						//Without interpolation:
						//TriangleVerticies[3] = (CubeVertex_3 + ((CubeVertex_0 - CubeVertex_3) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 16)
						//With interpolation: 
						TriangleVerticies[4] = MarchingCube::Interpolation(CubeVertex_4, CubeVertex_5, Intensity_4, Intensity_5);
						//Without interpolation:
						//TriangleVerticies[4] = (CubeVertex_4 + ((CubeVertex_5 - CubeVertex_4) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 32)
						//With interpolation: 
						TriangleVerticies[5] = MarchingCube::Interpolation(CubeVertex_5, CubeVertex_6, Intensity_5, Intensity_6);
						//Without interpolation:
						//TriangleVerticies[5] = (CubeVertex_5 + ((CubeVertex_6 - CubeVertex_5) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 64)
						//With interpolation: 
						TriangleVerticies[6] = MarchingCube::Interpolation(CubeVertex_6, CubeVertex_7, Intensity_6, Intensity_7);
						//Without interpolation:
						//TriangleVerticies[6] = (CubeVertex_6 + ((CubeVertex_7 - CubeVertex_6) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 128)
						//With interpolation: 
						TriangleVerticies[7] = MarchingCube::Interpolation(CubeVertex_7, CubeVertex_4, Intensity_7, Intensity_4);
						//Without interpolation:
						//TriangleVerticies[7] = (CubeVertex_7 + ((CubeVertex_4 - CubeVertex_7) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 256)
						//With interpolation: 
						TriangleVerticies[8] = MarchingCube::Interpolation(CubeVertex_0, CubeVertex_4, Intensity_0, Intensity_4);
						//Without interpolation:
						//TriangleVerticies[8] = (CubeVertex_0 + ((CubeVertex_4 - CubeVertex_0) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 512)
						//With interpolation: 
						TriangleVerticies[9] = MarchingCube::Interpolation(CubeVertex_1, CubeVertex_5, Intensity_1, Intensity_5);
						//Without interpolation:
						//TriangleVerticies[9] = (CubeVertex_1 + ((CubeVertex_5 - CubeVertex_1) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 1024)
						//With interpolation: 
						TriangleVerticies[10] = MarchingCube::Interpolation(CubeVertex_2, CubeVertex_6, Intensity_2, Intensity_6);
						//Without interpolation:
						//TriangleVerticies[10] = (CubeVertex_2 + ((CubeVertex_6 - CubeVertex_2) / 2.0f));
					if (LUT::EdgeTable[cubeindex] & 2048)
						//With interpolation: 
						TriangleVerticies[11] = MarchingCube::Interpolation(CubeVertex_3, CubeVertex_7, Intensity_3, Intensity_7);
						//Without interpolation:
						//TriangleVerticies[11] = (CubeVertex_3 + ((CubeVertex_7 - CubeVertex_3) / 2.0f));

					// Create the triangle
					for (int i = 0; LUT::TriangleTable[cubeindex][i] != -1; i += 3) {
						vector<sf::Vector3f> Triangle{
						 TriangleVerticies[LUT::TriangleTable[cubeindex][i]],
						 TriangleVerticies[LUT::TriangleTable[cubeindex][i + 1]],
						 TriangleVerticies[LUT::TriangleTable[cubeindex][i + 2]]
						};
						Triangles.push_back(Triangle);
						//Normals = array for normals vector
						sf::Vector3f Normal = MarchingCube::getNormal(Triangle);
						Normals.push_back(Normal);
					}
				}
			}
		}
	}
	// Creationg OBJECT (instance class):   //Because I need Triangles and also Normals vectors for drawing
	TrianglesAndNormals TrianglesAndNormalsResult;
	// Setting object:
	TrianglesAndNormalsResult.Triangles = Triangles;
	TrianglesAndNormalsResult.Normals = Normals;

	//Output
	return TrianglesAndNormalsResult; 
}

//Normals vectors:
sf::Vector3f MarchingCube::getNormal(vector<sf::Vector3f>& Triangle){
//Computing normal vector:  
sf::Vector3f Edge1 = Triangle[1] - Triangle[0];
sf::Vector3f Edge2 = Triangle[2] - Triangle[0];
sf::Vector3f Product_Edges(
	Edge1.y* Edge2.z - Edge1.z * Edge2.y,
	Edge1.x* Edge2.z - Edge1.z * Edge2.x,
	Edge1.x* Edge2.y - Edge1.y * Edge2.x
);

//Normalized: 
float Eukl_vzd = sqrt(Product_Edges.x * Product_Edges.x + Product_Edges.y * Product_Edges.y + Product_Edges.z * Product_Edges.z);

//Using TERNAL Operator: 
//(3 things! = condition + what happened, if condition is true + what happend, if it is false)
sf::Vector3f Normal = (Eukl_vzd == 0)
? Product_Edges
	: Product_Edges / Eukl_vzd;

//Output
return (Normal * -1.0f);
}

//Interpolation: 
sf::Vector3f MarchingCube::Interpolation(sf::Vector3f CubeVertex1, sf::Vector3f CubeVertex2, float Intensity1, float Intensity2) {
	if (std::abs(Intensity1) < 0.000001) return  CubeVertex1;
	if (std::abs(Intensity2) < 0.000001) return  CubeVertex2;
	if (std::abs(Intensity1 - Intensity2) < 0.000001) return CubeVertex1;

	return CubeVertex1 + (125 - Intensity1) * (CubeVertex2 - CubeVertex1) / (Intensity2 - Intensity1);
}

