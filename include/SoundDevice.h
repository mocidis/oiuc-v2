#ifndef __SOUND_DEVICE__
#define _SOUND_DEVICE_
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
#include "Log.h"
#include "OIUC.h"
extern "C" {
#include "my-pjlib-utils.h"
#include <pjmedia.h>
}
class SoundDevice;
class SoundDeviceList;
class SoundDevice : public QObject {
	Q_OBJECT
public:
	SoundDevice();
	SoundDevice(int index, QString name, bool select);
	int getIndex();
	QString getName();
	bool isSelected();
	void setSelected(bool value);
private:
	int index;
	QString name;
	bool select;
};
class SoundDeviceList : public QObject{
	Q_OBJECT
public:
	static SoundDeviceList* getSoundDeviceListSingleton();
	Q_INVOKABLE void getSoundDeviceInfo();
	Q_INVOKABLE void applySoundDevice(QString soundList);
signals:
	void updateSoundDevice(int index, QString name, bool select);
private:
	SoundDeviceList();
	static SoundDeviceList *soundDeviceList;
	QList<SoundDevice*> listDevice;
};
#endif
