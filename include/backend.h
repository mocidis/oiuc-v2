#ifndef _BACKEND_H_
#define _BACKEND_H_
#include <QtSql>
#include <QtCore>
#include "Log.h"
#include "Config.h"
void loadGeneralConfig(Config *config, QString backend_location);
#endif
