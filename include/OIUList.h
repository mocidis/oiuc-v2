#ifndef _OIU_LIST_
#define _OIU_LIST_

#include <QtGlobal>
#include <QtCore>
#if QT_VERSION >= 0x050000
#include <QQuickItem>
#include <QQuickView>
#include <QQmlContext>
#else
#include <QDeclarativeItem>
#include <QDeclarativeView>
#include <QDeclarativeContext>
#endif
#include <QtSql>

#include "OIU.h"
#include "Log.h"
#define OIU_ONLINE 0
#define OIU_TX 1
#define OIU_RX 2
#define OIU_SQ 3
class OIUList;
class OIUList : public QObject {
	Q_OBJECT
public:	
	static OIUList* getOIUListSingleton();

	/*****************Add and Set functions******************/
	void addOIU (OIU *oiu);
	void deleteOIU (OIU *oiu);
	void updateOIUListSignal(OIU* oiu, int mIndex);

	/*****************Get functions**************************/
	QList<OIU*> getOIUList(); //return list of oius in this OIUList
	void updateOIUState(int index, int type, bool value);
	int searchOIUByName(QString name);
	OIU* getOIUByIndex(int index);

signals: 
	void updateOIUList(QString name, QString desc, int port, bool bOnline, bool bTx, bool bRx, bool bSQ, double rVolume, int mIndex);

private:
	/*****************Constructor*******************/
	OIUList ();

	/*****************Attribute********************/
	QList<OIU*> _oiu_list;
	static OIUList* _oiu_manager;
};

#endif
