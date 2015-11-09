#ifndef _OIUC_H_
#define _OIUC_H_
#include <QDeclarativeView>
#include <QDeclarativeItem>
#include <QDebug>
#include <QString>
#include "ctocpp.h"
#include "backend.h"
#include "Config.h"
extern "C"
{
#include <unistd.h>
#include <pjsua-lib/pjsua.h>
#include "ansi-utils.h"
#include "ics.h"
#include "node.h"
#include "gb-receiver.h"
}
class OIUC;
class OIUC : public QDeclarativeItem {
	Q_OBJECT
public:
	static OIUC* getOIUC();
    void signalLoginStart();
	void runCallingState(QString msg, int st_code);
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
	void setLoggedIn(int flag, char *reason);
	Q_INVOKABLE bool isLoggedIn();

	Q_INVOKABLE QString getLastDialNumber();
signals:
	void callingState(QString msg, int st_code);
    void loginStart();
	void loggedInChange(QString reason);
public slots:
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
