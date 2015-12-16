#include "RadioList.h"
#include "backend.h"
/*****************Constructor******************/
RadioList* RadioList::_radio_manager = 0;
RadioList* RadioList::getRadioListSingleton() {
	if (_radio_manager == NULL) {
		_radio_manager = new RadioList();
	}
	return _radio_manager;
}
RadioList::RadioList() {}
/*****************Add and Set functions******************/
void RadioList::addRadio(Radio *radio) {
	_radio_list.append(radio);
	updateRadioListSignal(radio, -1);
	writeLog("detected " + radio->getName(), SCREENS);
}
void RadioList::updateRadioState(int index, int type, bool value) {
	QString msg;
	if (value == false) {
		msg = "OFF";
	} else {
		msg = "ON";
	}
	switch (type) {
		case RADIO_ONLINE:
			_radio_list[index]->setOnline(value);
			writeLog("change ONLINE state " + _radio_list[index]->getName() + " " + msg, SCREENS);
			break;
		case RADIO_TX:
			_radio_list[index]->setTx(value);
			writeLog("change TX state " + _radio_list[index]->getName() + " " + msg, SCREENS);
			break;
		case RADIO_RX:
			_radio_list[index]->setRx(value);
			writeLog("change RX state " + _radio_list[index]->getName() + " " + msg, SCREENS);
			break;
		case RADIO_SQ:
			_radio_list[index]->setSQ(value);
			writeLog("change SQ state " + _radio_list[index]->getName() + " " + msg, SCREENS);
			break;
		default:
			break;
	}
	updateRadioListSignal(_radio_list[index], index);
}
void RadioList::deleteRadio(Radio *radio) {
	for (int i=0;i<_radio_list.count();i++) {
		if (_radio_list[i]->getName() == radio->getName()) {
			_radio_list.removeAt(i);
		}
	}
}
/*****************Get functions******************/
QList<Radio*> RadioList::getRadioList() { return _radio_list;}
void RadioList::updateRadioListSignal(Radio* radio, int mIndex) {
	emit updateRadioList(
            radio->getName(),
			radio->getDesc(),
			radio->getPort(),
            radio->isOnline(),
            radio->isTx(),
            radio->isRx(),
            radio->isSQ(),
            radio->getVolume(),
            mIndex
    );
}
int RadioList::searchRadioByName(QString name) {
	int n = _radio_list.count();
	bool flag = false;
	int index=0;
	for (index=0; index<n; index++) {
		if (_radio_list[index]->getName() == name) {
			flag = true;
			break;
		}
	}
	if (flag == true) {
		return index;
	}
	return -1; //not found
}
Radio* RadioList::getRadioByIndex(int index) {
	return _radio_list[index];
}
