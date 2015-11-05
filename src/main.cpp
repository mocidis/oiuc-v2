#include <QDeclarativeView>
#include <QApplication>
#include <QDeclarativeItem>
#include <QDeclarativeContext>
#include <QDebug>
#include <QVariant>
#include "OIUC.h"
#include "backend.h"
#include "Log.h"
#include "Config.h"
#include "RadioList.h"
#include "Radio.h"
#include "OIU.h"
#include "OIUList.h"
int main (int argc, char* argv[]) {
	QApplication app(argc, argv);

	QStringList args = app.arguments();
	if (args.count() >= 2) {
		if (args[1] == "-v" || args[1] == "--version") {
			qDebug() << "OIUC version:" << APP_VERSION;
		}
		exit(EXIT_SUCCESS);
	}

	QDeclarativeView view;
	//load OIUC config from sqlite3 database
	Config *config = Config::getConfig();
	loadGeneralConfig(config, "databases/oiuc.db");
	
	//start log thread
	Log *log = Log::getLog();
	log->setFilename(config->getLogDir() + "oiuc.log");
	log->start();

	//prepare for oiuc
	OIUC *oiuc = OIUC::getOIUC();
	oiuc->prepare();

	//make sure log file will be flushed after handle the quit signal of application
	QObject::connect(&app, SIGNAL(aboutToQuit()), log, SLOT(flushLog()));

	//initial radio list and oiu list object
	RadioList *radio_list = RadioList::getRadioListSingleton();
	OIUList *oiu_list = OIUList::getOIUListSingleton();

	//connect cpp and qml
	view.rootContext()->setContextProperty("oiuc", oiuc);// setup connection between qml and cpp
	view.rootContext()->setContextProperty("radioList", radio_list);
	view.rootContext()->setContextProperty("oiuList", oiu_list);
	view.rootContext()->setContextProperty("logModel", log->getLogModel());
	view.setSource(QUrl::fromLocalFile("qml/Application.qml"));

	writeLog("Start OIUC"); //any log should declare after this line
	view.show(); //display QML GUI of this application
	return app.exec(); //event loop of application
}
