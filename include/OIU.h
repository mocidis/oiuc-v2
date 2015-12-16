#ifndef _OIU_H_
#define _OIU_H_

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
class OIU;
class OIU : public QObject {
	Q_OBJECT
public:
	// constructor
	OIU(QString name, QString status, QString desc);

	//add and set functions
	void setStatus (QString status);

	//get functions
	QString getName();
	QString getStatus();
	QString getDesc();


private:
	QString _name; //name of oiu
	QString _status;  //1=online or 0=offline
	QString _desc;
};

#endif
