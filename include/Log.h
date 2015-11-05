#ifndef _LOG_H_
#define _LOG_H_
#include <QtCore>
#include <QDeclarativeItem>
#include <QtSql>
#include <QDateTime>
#include <QFile>
#include "Config.h"
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
private:
	Log();
	static Log* log;
	void run(); //thread
	void fileMaintenance(); //mananage log file

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
