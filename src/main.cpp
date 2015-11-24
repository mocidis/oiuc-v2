#include <QGuiApplication>
#include <QQmlApplicationEngine>
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
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Config *config = Config::getConfig();
#ifdef ICS_ANDROID
    loadGeneralConfig(config, "assets:/databases/oiuc.db");
#else
    loadGeneralConfig(config, "databases/oiuc.db");
#endif
/*
     config->setAsteriskIP ("192.168.2.30");
     config->setPortAsterisk (5060);
     config->setArbiterIP ("192.168.2.30");
     config->setPortSendToArbiter (1994);
     config->setPortOIUCListen (1993);
     config->setOIUCDescription ("OIUC-DESC");
     config->setSpeakerVolume (0.5);
     config->setMicrophoneVolume (0.5);
     config->setLogDir("/tmp/");
     config->setLogMaxLinePerFile(1000);
     config->setLogMaxFile(10);
     config->setLogMaxLineDisplay(200);
     config->setOIUCName("FTW");
     config->setLocation("HAN");
     config->setOIUCIP("192.168.2.112");
*/
     Log *log = Log::getLog();
     log->setFilename(config->getLogDir() + "oiuc.log");
     log->start();
     //prepare for oiuc
     OIUC *oiuc = OIUC::getOIUC();
     oiuc->prepare();
     //oiuc->start("ntt", "1234");
     //make sure log file will be flushed after handle the quit signal of application
     QObject::connect(&app, SIGNAL(aboutToQuit()), log, SLOT(flushLog()));
     RadioList *radio_list = RadioList::getRadioListSingleton();
     OIUList *oiu_list = OIUList::getOIUListSingleton();
     engine.rootContext()->setContextProperty("oiuc", oiuc);
     engine.rootContext()->setContextProperty("radioList", radio_list);
     engine.rootContext()->setContextProperty("oiuList", oiu_list);
     engine.rootContext()->setContextProperty("logModel", log->getLogModel());
     writeLog("Start OIUC", SCREENS);
     engine.load(QUrl(QStringLiteral("qrc:/qml/Application.qml")));
     return app.exec();
}
