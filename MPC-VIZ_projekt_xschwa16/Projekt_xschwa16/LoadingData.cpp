#include "LoadingData.h"

//Loading data: 
sf::Image LoadingData::LoadData(int ImageStart, string Path, string ExtName) {
	sf::Image Img;
	if (ImageStart < 10) {
		if (!Img.loadFromFile(Path + "CT00" + to_string(ImageStart) + ExtName)) {
			cout << "Image is not loaded" << endl;
		}
	}
	else if (ImageStart >= 10 && ImageStart < 100) {
		if (!Img.loadFromFile(Path + "CT0" + to_string(ImageStart) + ExtName)) {
			cout << "Image is not loaded" << endl;
		}
	}
	else if (ImageStart >= 100 && ImageStart < 1000) {
		if (!Img.loadFromFile(Path + "CT" + to_string(ImageStart) + ExtName)) {
			cout << "Image is not loaded" << endl;
		}
	}
	else {
		cout << "Image is not loaded. You must put data as CTxxx.png e.g. from CT001.png to CT099.png (If you use another data type as *.jpg, you must change ExtName)" << endl;
	}
	return Img;
}
