#include "OIU.h"
/*Constructor*/
OIU::OIU(QString name, QString desc, int port, bool isOnline, bool isTx, bool isSQ) {
	_name = name;
	_desc = desc;
	_port = port;
    _isOnline = isOnline;
    _isTx = isTx;
    _isRx = false;
    _isSQ = isSQ;
    _volume = 0.5;
}

/*Add and set function*/
void OIU::setOnline(bool val) { _isOnline = val;}
void OIU::setTx(bool val) { _isTx = val;}
void OIU::setRx(bool val) { _isRx = val;}
void OIU::setSQ(bool val) { _isSQ = val;}
void OIU::setVolume(double val) { _volume = val;}


/*Get function*/

QString OIU::getName() { return _name;}
bool OIU::isOnline() { return _isOnline;}
bool OIU::isTx() { return _isTx;}
bool OIU::isRx() { return _isRx;}
bool OIU::isSQ() { return _isSQ;}
double OIU::getVolume() { return _volume;}
QString OIU::getDesc() { return _desc;}
int OIU::getPort() { return _port;}

