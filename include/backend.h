#ifndef _BACKEND_H_
#define _BACKEND_H_
#include <QtSql>
#include <QtCore>
#include "Log.h"
#include "Config.h"
#include "Hotline.h"
void loadGeneralConfig(Config *config, QString backend_location);
void loadHotlineModel(HotlineList *hotlineList, QString backend_location);
#endif
