#ifndef _HOTLINE_H_
#define _HOTLINE_H_ 

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
class Hotline;
class HotlineList;
class Hotline : public QObject {
	Q_OBJECT
public:
	/****************Constructor*******************/
	Hotline(QString name, QString desc, QString location, QString phone, QString freq, double volume);

	/*************Add and Set functions************/
    void setVolume(double val);

	/************Get functions********************/
	QString getName();
	QString getDesc();
	QString getLocation();
	QString getPhone();
	QString getFrequency();
    double getVolume();
    
private:
	QString name;
	QString desc;
	QString location;
	QString phone;
	QString freq;
    double volume;
};
class HotlineList : public QObject {
	Q_OBJECT
public:
	static HotlineList* getHotlineListSingleton();
	void addHotline(Hotline *hotline);
signals:
	void updateHotline(QString name, QString desc, QString location, QString phone, QString freq, double volume);
private:
	HotlineList ();
	QList<Hotline*> hotline_list;
	static HotlineList* hotline_manager;
};

#endif
