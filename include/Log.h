#ifndef _LOG_H_
#define _LOG_H_
#include <QtCore>
#include <QtGlobal>

#if QT_VERSION >= 0x050000
#include <QQuickView>
#else
#include <QDeclarativeItem>
#endif
#include <QtSql>
#include <QDateTime>
#include <QFile>
#include "Config.h"
#define SCREENS 0
#define FILES 1
class Log;
class LogModel;
class LogModel : public QAbstractListModel {
	Q_OBJECT
public:
	enum LogRole{
		logRole	
	};
	LogModel ();
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
	void clear();
	void removeAt(int index);
	void addLog(QString msg);
#if QT_VERSION > 0x050000
    QHash<int, QByteArray> roleNames() const;
#endif
public slots:
	void onWLog(QString msg);
	void onClearLog();
private:
	QList <QString> list;
};
class Log : public QThread {
	Q_OBJECT
public:
	void logs(QString msg);
	static Log* getLog();
	void setFilename(QString _filename);
	Q_INVOKABLE QString getFilename();
	LogModel* getLogModel();
public slots:
	void flushLog();
signals:
	void wLog(QString msg);
	void clearLog();
private:
	Log();
	static Log* log;
	void run(); //thread

	LogModel *logModel;
	QFile logfile;
	QTextStream out;
	QString filename;
	int max_file;
	int max_line;
	int max_buffer_line;
	int file_count;
};
void writeLog(QString msg);
#endif
