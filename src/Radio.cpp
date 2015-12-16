#include "Radio.h"
/*Constructor*/
Radio::Radio(QString name, QString desc, int port, bool isOnline, bool isTx, bool isSQ) {
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
void Radio::setOnline(bool val) { _isOnline = val;}
void Radio::setTx(bool val) { _isTx = val;}
void Radio::setRx(bool val) { _isRx = val;}
void Radio::setSQ(bool val) { _isSQ = val;}
void Radio::setVolume(double val) { _volume = val;}


/*Get function*/

QString Radio::getName() { return _name;}
bool Radio::isOnline() { return _isOnline;}
bool Radio::isTx() { return _isTx;}
bool Radio::isRx() { return _isRx;}
bool Radio::isSQ() { return _isSQ;}
double Radio::getVolume() { return _volume;}
QString Radio::getDesc() { return _desc;}
int Radio::getPort() { return _port;}

