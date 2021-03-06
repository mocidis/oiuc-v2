#include "SoundDevice.h"
SoundDevice::SoundDevice() {
	index = -1;
	name = "default";
}
SoundDevice::SoundDevice(int index, QString name, bool select) {
	this->index = index;
	this->name = name;
	this->select = select;
}
int SoundDevice::getIndex() {
	return index;
}
QString SoundDevice::getName() {
	return name;
}
bool SoundDevice::isSelected() {
	return select;
}
void SoundDevice::setSelected(bool value) {
	select = value;	
}

/***************** SoundDeviceList ******************/
SoundDeviceList* SoundDeviceList::soundDeviceList = 0;
SoundDeviceList* SoundDeviceList::getSoundDeviceListSingleton() {
	if (soundDeviceList == NULL) {
		soundDeviceList = new SoundDeviceList();	
	}
	return soundDeviceList;
}
SoundDeviceList::SoundDeviceList() {
	first_load = true;
}
void SoundDeviceList::getSoundDeviceInfo() {
    pjmedia_aud_dev_index dev_idx;
    int dev_cnt;
    dev_cnt = pjmedia_aud_dev_count();
	qDebug() << "devices count" << dev_cnt;
	if (first_load == true) {
		//fix: update sound device does not work when a new usb sound device plugged-in the computer
		if (first_load == true) {
			first_load = false;	
		}
		for (dev_idx=0; dev_idx < dev_cnt; ++dev_idx) {
			pjmedia_aud_dev_info info;
			CHECK(__FILE__, pjmedia_aud_dev_get_info(dev_idx, &info));
			SoundDevice *soundDevice = new SoundDevice(dev_idx, QString::fromLocal8Bit(info.name), false);
			if (soundDevice->getName().contains("PCH", Qt::CaseSensitive)) {
				soundDevice->setSelected(true);
			}
			if (soundDevice->getName().contains("sysdefault", Qt::CaseInsensitive)) {
				//QStringList liststr = soundDevice->getName().split(": ");
				emit updateSoundDevice(soundDevice->getIndex(), soundDevice->getName(), soundDevice->isSelected());
				listDevice.append(soundDevice);
			}
		}
	}
}
void SoundDeviceList::applySoundDevice(QString soundList) {
	QStringList list;
	list = soundList.split(";", QString::SkipEmptyParts);
	OIUC *oiuc = OIUC::getOIUC();
	foreach (QString idx, list) {
		foreach(SoundDevice *soundDevice, listDevice) {
			if (soundDevice->getIndex() == idx.toInt()) {
				soundDevice->setSelected(true);
				oiuc->updateEndpoint(soundDevice->getIndex());
			}
		}
	}
}
void SoundDeviceList::applySoundDevice2(QString soundList) {
	QStringList list;
	QList<int> deviceIdxList;
	list = soundList.split(";", QString::SkipEmptyParts);
	OIUC *oiuc = OIUC::getOIUC();
	foreach (QString idx, list) {
		foreach(SoundDevice *soundDevice, listDevice) {
			if (soundDevice->getIndex() == idx.toInt()) {
				soundDevice->setSelected(true);
				deviceIdxList.append(soundDevice->getIndex());
			}
		}
	}
	oiuc->updateEndpoint2(deviceIdxList);
}
