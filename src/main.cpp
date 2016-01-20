#include <QtGlobal>
#if QT_VERSION >= 0x050000
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QScreen>
#else
#include <QDeclarativeView>
#include <QApplication>
#include <QDeclarativeItem>
#include <QDeclarativeContext>
#endif
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
#include "PTTButton.h"
int main(int argc, char *argv[])
{
	qmlRegisterType<PTTButton>("PTTButton", 1, 0, "PTT");
#if QT_VERSION >= 0x050000
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
#else
	QApplication app(argc, argv);
	QDeclarativeView engine;
#endif
    Config *config = Config::getConfig();
#ifdef ICS_ANDROID
    loadGeneralConfig(config, "assets:/databases/oiuc.db");
#else
    loadGeneralConfig(config, "databases/oiuc.db");
#endif
	Log *log = Log::getLog();
	log->setFilename(config->getLogDir() + "oiuc.log");
	log->start();
	//prepare for oiuc
	OIUC *oiuc = OIUC::getOIUC();
	oiuc->prepare();
	oiuc->start("ntt", "1234");
	//make sure log file will be flushed after handle the quit signal of application
	QObject::connect(&app, SIGNAL(aboutToQuit()), log, SLOT(flushLog()));
	RadioList *radio_list = RadioList::getRadioListSingleton();
	OIUList *oiu_list = OIUList::getOIUListSingleton();
	engine.rootContext()->setContextProperty("oiuc", oiuc);
	engine.rootContext()->setContextProperty("radioList", radio_list);
	engine.rootContext()->setContextProperty("oiuList", oiu_list);
	engine.rootContext()->setContextProperty("logModel", log->getLogModel());
	writeLog("Start OIUC");
#if QT_VERSION >= 0x050000
	QString qml_url = "qrc:/";
	qml_url.append(QString::fromLocal8Bit(QML_GEN_DIR));
	qml_url.append("/Application.qml");
	engine.load(QUrl(qml_url));
	QQuickWindow *window = qobject_cast<QQuickWindow*>(engine.rootObjects().at(0));
	window->showFullScreen();
#else
	QString qml_url = "qrc:///";
	qml_url.append(QString::fromLocal8Bit(QML_GEN_DIR));
	qml_url.append("/Application.qml");
	engine.setSource(QUrl(qml_url));
	engine.showFullScreen();
#endif
	return app.exec();
}
/*
#include <QDeclarativeView>
#include <QApplication>
#include <QDeclarativeItem>
#include <QDeclarativeContext>
#include <QMessageBox>
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
#include "my-pjlib-utils.h"

QApplication *pApp;

void exitQt(int retcode) {
//    QMessageBox::critical(NULL, "Title", "Content ");
    _Exit(retcode);
}

int main (int argc, char* argv[]) {
	QApplication app(argc, argv);
    pApp = new QApplication(argc, argv);
    __exit_f = &exitQt;
	QStringList args = pApp->arguments();
	if (args.count() >= 2) {
		if (args[1] == "-v" || args[1] == "--version") {
			qDebug() << "OIUC version:" << APP_VERSION;
		}
		exit(EXIT_SUCCESS);
	}

	QDeclarativeView view;
	//load OIUC config from sqlite3 database
	Config *config = Config::getConfig();
	qDebug() << "loading config";
	loadGeneralConfig(config, "databases/oiuc.db");
	
	//start log thread
	Log *log = Log::getLog();
	log->setFilename(config->getLogDir() + "oiuc.log");
	log->start();

	OIUC *oiuc = OIUC::getOIUC();
	//make sure log file will be flushed after handle the quit signal of application
	QObject::connect(pApp, SIGNAL(aboutToQuit()), log, SLOT(flushLog()));

	//initial radio list and oiu list object
	RadioList *radio_list = RadioList::getRadioListSingleton();
	OIUList *oiu_list = OIUList::getOIUListSingleton();

	//connect cpp and qml
	view.rootContext()->setContextProperty("oiuc", oiuc);// setup connection between qml and cpp
	view.rootContext()->setContextProperty("radioList", radio_list);
	view.rootContext()->setContextProperty("oiuList", oiu_list);
	view.rootContext()->setContextProperty("logModel", log->getLogModel());
	view.setSource(QUrl("qrc:///qml/Application.qml"));

	writeLog("Start OIUC", SCREENS); //any log should declare after this line

	//prepare for oiuc
	oiuc->prepare();
	oiuc->start("ntt", "1234");

	view.show(); //display QML GUI of this application
	return pApp->exec(); //event loop of application
}
*/
