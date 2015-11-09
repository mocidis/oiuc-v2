#include "OIUList.h"

/*****************Constructor******************/
OIUList* OIUList::_oiu_manager = 0;
OIUList* OIUList::getOIUListSingleton() {
	if (_oiu_manager == NULL) {
		_oiu_manager = new OIUList();
	}
	return _oiu_manager;
}
OIUList::OIUList() { }

/*****************Add and Set functions******************/
void OIUList::addOIU(OIU *oiu) {
	int flags = 0;
	int mIndex = -1;
	for (int i=0; i < _oiu_list.count(); i++) {
		if (_oiu_list[i]->getName() == oiu->getName()) {
			flags = 1;
			if (_oiu_list[i]->getStatus() != oiu->getStatus()) {
				_oiu_list[i]->setStatus(oiu->getStatus());
				flags = 2;
				mIndex = i;
			}
			break;	
		}
	}
	if (flags == 0 || flags == 2) {
		if (flags == 0) {
			_oiu_list.append(oiu);
			updateOIUListSignal(oiu, mIndex);
		} else {
			updateOIUListSignal(oiu, mIndex);
		}
	}
}
void OIUList::deleteOIU(OIU *oiu) {
	for (int i=0;i<_oiu_list.count();i++) {
		if (_oiu_list[i]->getName() == oiu->getName()) {
			_oiu_list.removeAt(i);
		}
	}
}
/*****************Get functions******************/
QList<OIU*> OIUList::getOIUList() {
	return _oiu_list;
}
void OIUList::updateOIUListSignal (OIU *oiu, int mIndex) {
	QString name = oiu->getName();
	QString status = oiu->getStatus();
	QString desc = oiu->getDesc();
	emit updateOIUList (name, status, desc, mIndex);
}
