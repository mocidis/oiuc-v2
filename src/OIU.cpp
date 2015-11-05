#include "OIU.h"
/*Constructor*/
OIU::OIU(QString name, QString  status, QString desc) {
	_name = name;
	_status = status;
	_desc = desc;
}

/*Add and set function*/
void OIU::setStatus(QString status) {
	_status = status;
}

/*Get function*/
QString OIU::getName() {
	return _name;
}

QString OIU::getStatus() {
	return _status;
}
QString OIU::getDesc() {
	return _desc;
}
