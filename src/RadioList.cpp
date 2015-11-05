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
	int flags = 0;
	int mIndex = -1;
	for (int i=0; i < _radio_list.count(); i++) {
		if (_radio_list[i]->getName() == radio->getName()) {
			flags = 1;
			if (_radio_list[i]->isOnline() != radio->isOnline()) {
				_radio_list[i]->setOnline(radio->isOnline());
				flags = 2;
				mIndex = i;
			}
			if (_radio_list[i]->isTx() != radio->isTx()) {
				_radio_list[i]->setTx(radio->isTx());
				flags = 2;
				mIndex = i;
			}
			if (_radio_list[i]->isSQ() != radio->isSQ()) {
				_radio_list[i]->setSQ(radio->isSQ());
				flags = 2;
				mIndex = i;
			}
			break;
		}
	}
	if (flags == 0 || flags == 2) {
		if (flags == 0) {
			_radio_list.append(radio);
			updateRadioListSignal(radio, mIndex);
			writeLog(radio->getName() + " detected");
		} else {
			updateRadioListSignal(radio, mIndex);
			writeLog(radio->getName() + "'s state changed");
		}
	}
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
