#ifndef _RADIO_H_
#define _RADIO_H_

#include <QtGlobal>
#include <QtCore>

#if QT_VERSION >= 0x050000
#include <QQuickView>
#include <QQuickItem>
#else
#include <QDeclarativeView>
#include <QDeclarativeItem>
#endif

#include <QtSql>
class Radio;
class Radio : public QObject {
	Q_OBJECT
public:
	/****************Constructor*******************/
	Radio(QString name, QString desc, int port, bool isOnline, bool isTx, bool isSQ, double freq);

	/*************Add and Set functions************/
	void setDowntime(double downtime);

	/************Get functions********************/
	QString getName();
    bool isOnline();
    bool isTx();
    bool isRx();
    bool isSQ();
    double getVolume();
	QString getDesc();
	int getPort();
    double getFreq();
    
    void setOnline(bool val);
    void setTx(bool val);
    void setRx(bool val);
    void setSQ(bool val);
    void setVolume(double val);

private:
	QString _name;
	QString _desc;
	int _port;
    bool _isOnline;
    bool _isTx;
    bool _isRx;
    bool _isSQ;
    double _volume;
    double _freq;
};
#endif
