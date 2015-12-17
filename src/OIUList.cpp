#include "OIUList.h"
/*****************Constructor******************/
OIUList* OIUList::_oiu_manager = 0;
OIUList* OIUList::getOIUListSingleton() {
	if (_oiu_manager == NULL) {
		_oiu_manager = new OIUList();
	}
	return _oiu_manager;
}
OIUList::OIUList() {}
/*****************Add and Set functions******************/
void OIUList::addOIU(OIU *oiu) {
	_oiu_list.append(oiu);
	updateOIUListSignal(oiu, -1);
	writeLog("detected " + oiu->getName(), SCREENS);
}
void OIUList::updateOIUState(int index, int type, bool value) {
	QString msg;
	if (value == false) {
		msg = "OFF";
	} else {
		msg = "ON";
	}
	switch (type) {
		case OIU_ONLINE:
			_oiu_list[index]->setOnline(value);
			writeLog("change ONLINE state " + _oiu_list[index]->getName() + " " + msg, SCREENS);
			break;
		case OIU_TX:
			_oiu_list[index]->setTx(value);
			writeLog("change TX state " + _oiu_list[index]->getName() + " " + msg, SCREENS);
			break;
		case OIU_RX:
			_oiu_list[index]->setRx(value);
			writeLog("change RX state " + _oiu_list[index]->getName() + " " + msg, SCREENS);
			break;
		case OIU_SQ:
			_oiu_list[index]->setSQ(value);
			writeLog("change SQ state " + _oiu_list[index]->getName() + " " + msg, SCREENS);
			break;
		default:
			break;
	}
	updateOIUListSignal(_oiu_list[index], index);
}
void OIUList::deleteOIU(OIU *oiu) {
	for (int i=0;i<_oiu_list.count();i++) {
		if (_oiu_list[i]->getName() == oiu->getName()) {
			_oiu_list.removeAt(i);
		}
	}
}
/*****************Get functions******************/
QList<OIU*> OIUList::getOIUList() { return _oiu_list;}
void OIUList::updateOIUListSignal(OIU* oiu, int mIndex) {
	emit updateOIUList(
            oiu->getName(),
			oiu->getDesc(),
			oiu->getPort(),
            oiu->isOnline(),
            oiu->isTx(),
            oiu->isRx(),
            oiu->isSQ(),
            oiu->getVolume(),
            mIndex
    );
}
int OIUList::searchOIUByName(QString name) {
	int n = _oiu_list.count();
	bool flag = false;
	int index=0;
	for (index=0; index<n; index++) {
		if (_oiu_list[index]->getName() == name) {
			flag = true;
			break;
		}
	}
	if (flag == true) {
		return index;
	}
	return -1; //not found
}
OIU* OIUList::getOIUByIndex(int index) {
	return _oiu_list[index];
}
