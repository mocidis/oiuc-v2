#ifndef _OIU_LIST_
#define _OIU_LIST_

#include <QtCore>
#include <QDeclarativeItem>
#include <QDeclarativeView>
#include <QDeclarativeContext>
#include <QtSql>

#include "OIU.h"
#include "Log.h"
class OIUList;
class OIUList : public QObject {
	Q_OBJECT
public:	
	static OIUList *getOIUListSingleton();

	/*****************Add and Set functions******************/
	void addOIU (OIU *oiu);
	void deleteOIU (OIU *oiu);

	/*****************Get functions******************/
	QList<OIU*> getOIUList();
	void updateOIUListSignal (OIU *oiu, int mIndex);

signals: 
	void updateOIUList (QString name, QString status, QString desc, int mIndex);

private:
	/*****************Constructor*******************/
	OIUList ();

	/*****************Attribute********************/
	QList<OIU*> _oiu_list;
	static OIUList* _oiu_manager;
};

#endif
