#include "Hotline.h"

Hotline::Hotline(QString name, QString desc, QString location, QString phone, QString freq, double volume) {
	this->name = name;
	this->desc = desc;
	this->location = location;
	this->phone = phone;
	this->freq = freq;
	this->volume = volume;
}

/*************Add and Set functions************/
void Hotline::setVolume(double val) {
	this->volume = val;
}

/************Get functions********************/
QString Hotline::getName() {
	return name;
}
QString Hotline::getDesc() {
	return desc;
}
QString Hotline::getLocation() {
	return location;
}
QString Hotline::getPhone() {
	return phone;
}
QString Hotline::getFrequency() {
	return freq;
}
double Hotline::getVolume() {
	return volume;
}
/********** Hotline List **********/
HotlineList::HotlineList() {}
HotlineList* HotlineList::hotline_manager=0;
HotlineList* HotlineList::getHotlineListSingleton() {
	if (hotline_manager == NULL) {
		hotline_manager = new HotlineList();	
	}
	return hotline_manager;
}
void HotlineList::addHotline(Hotline *hotline) {
	hotline_list.append(hotline);	
	emit updateHotline(hotline->getName(), hotline->getDesc(), hotline->getLocation(), hotline->getPhone(), hotline->getFrequency(), hotline->getVolume());
}

