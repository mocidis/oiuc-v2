#ifndef _RADIO_LIST_
#define _RADIO_LIST_ 

#include <QtCore>
#include <QDeclarativeItem>
#include <QDeclarativeView>
#include <QDeclarativeContext>
#include <QtSql>
#include "Radio.h"
#include "Log.h"
#define RADIO_ONLINE 0
#define RADIO_TX 1
#define RADIO_RX 2
#define RADIO_SQ 3
class RadioList;
class RadioList : public QObject {
	Q_OBJECT
public:	
	static RadioList* getRadioListSingleton();

	/*****************Add and Set functions******************/
	void addRadio (Radio *radio);
	void deleteRadio (Radio *radio);
	void updateRadioListSignal(Radio* radio, int mIndex);

	/*****************Get functions**************************/
	QList<Radio*> getRadioList(); //return list of radios in this RadioList
	void updateRadioState(int index, int type, bool value);
	int searchRadioByName(QString name);
	Radio* getRadioByIndex(int index);

signals: 
	void updateRadioList(QString name, QString desc, int port, bool bOnline, bool bTx, bool bRx, bool bSQ, double rVolume, int mIndex);

private:
	/*****************Constructor*******************/
	RadioList ();

	/*****************Attribute********************/
	QList<Radio*> _radio_list;
	static RadioList* _radio_manager;
};

#endif
