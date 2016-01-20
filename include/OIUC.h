#ifndef _OIUC_H_
#define _OIUC_H_
#include <QtGlobal>

#if QT_VERSION >= 0x050000
#include <QQuickView>
#include <QQuickItem>
#include <QGuiApplication>
#else
#include <QDeclarativeView>
#include <QDeclarativeItem>
#include <QApplication>
#endif // QT_VERSION

#include <QMouseEvent>
#include <QDebug>
#include <QString>
#include "ctocpp.h"
#include "backend.h"
#include "Config.h"
#include "PTTButton.h"
#include "Log.h"
extern "C"
{
#include <unistd.h>
#include <pjsua-lib/pjsua.h>
#include "pttc_uart.h"
#include "ansi-utils.h"
#include "ics.h"
#include "node.h"
#include "gb-receiver.h"
}
class OIUC;
#if QT_VERSION >= 0x050000
class OIUC : public QQuickItem {
#else
class OIUC : public QDeclarativeItem {
#endif // QT_VERSION
	Q_OBJECT
public:
	static OIUC* getOIUC();
	static LogModel *logModel;
    void signalLoginStart();
	void runCallingState(QString msg, int st_code);
    void signalPTTPressed();
    void signalPTTReleased();
	app_data_t *getAppData();

	Q_INVOKABLE void call (QString number);
	Q_INVOKABLE void hangupCall ();
	Q_INVOKABLE void hangupAllCall ();
	Q_INVOKABLE void conferenceCall ();
	Q_INVOKABLE void answerCall ();
	Q_INVOKABLE void transferCall ();
	Q_INVOKABLE void holdCall ();
	Q_INVOKABLE void releaseHoldCall ();

	Q_INVOKABLE void prepare();
	Q_INVOKABLE void start(QString username, QString password);
	Q_INVOKABLE void stop();

	Q_INVOKABLE void sendInvite(QString guest);
	Q_INVOKABLE void repulse(QString guest);
	Q_INVOKABLE void PTT();
	Q_INVOKABLE void endPTT();
	Q_INVOKABLE void adjust_volume(int stream_idx, float incremental);
	Q_INVOKABLE void adjust_master_volume(float incremental);

	void setLoggedIn(int flag, char *reason);
	Q_INVOKABLE bool isLoggedIn();

	Q_INVOKABLE QString getLastDialNumber();
	Q_INVOKABLE QString getUserName();
	Q_INVOKABLE bool isAdministrator();
signals:
	void callingState(QString msg, int st_code);
    void loginStart();
	void loggedInChange(QString reason);
    void pTTPressed();
    void pTTReleased();
private:
	OIUC();
	static OIUC *singleton;
	app_data_t app_data; 
	QString current_dial_number;
	bool logged_in;
	QString username;
	QString password;
	Config *config; //the configuration of this OIUC
	QString guest;
    gm_request_t req_info;
	QString gm_cs; //connection string
	QString gmc_cs; //connection string
	QString adv_cs; //connection string
};


#endif  //end of __OIUC_H__
