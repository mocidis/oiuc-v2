#include "Log.h"

QQueue <QString> q_log;
Log* Log::log = NULL;
Log* Log::getLog() {
	if (log == NULL) {
		log = new Log();
	}
	return log;
}
Log::Log() {
	file_count = 0;
	Config *config = Config::getConfig();	
	max_file = config->getLogMaxFile();
	max_line = config->getLogMaxLinePerFile();
	max_buffer_line = 3;
	logModel = new LogModel();
	logModel->roleNames();
	connect(this, SIGNAL(wLog(QString)), logModel, SLOT(onWLog(QString)));
	connect(this, SIGNAL(clearLog()), logModel, SLOT(onClearLog()));
}
void Log::logs(QString msg) {
	Config *config = Config::getConfig();
	emit wLog(msg);
}
void Log::setFilename(QString _filename) {
	filename = _filename;
}

QString Log::getFilename() {
	return filename;
}

void Log::run() {
	logfile.setFileName(filename);
	if (!logfile.open(QIODevice::Append | QIODevice::Text) ) {
		return;
	}
	out.setDevice(&logfile);
	int _max_line = 0;
	int _max_buffer_line = 0;
	QString filenameS="";
	QString msg;
	while(1) {
		if (!q_log.isEmpty()) {
			msg = q_log.dequeue();
			out << msg << "\n";
			logs(msg);
			_max_buffer_line++;
			_max_line++;
		}
		if (_max_line >= max_line) {
			emit clearLog();
			out.flush();
			_max_line = 0;
			filenameS = "";
			file_count++;
		}
		if (_max_buffer_line >= max_buffer_line) {
			out.flush();
		}
		msleep(100);
	} 
		logfile.close();
}
void Log::flushLog() {
	out << "\nFILE FLUSHED\n\n";
	out.flush();
	logfile.close();
}

LogModel* Log::getLogModel() {
	return logModel;
}
/************LOGMODEL**************/
LogModel::LogModel () {
	qRegisterMetaType<QModelIndex>("QModelIndex");
#if QT_VERSION < 0x050000
	QHash<int, QByteArray> roles;
	roles[logRole] = "log";
	setRoleNames(roles);
#endif
}
void LogModel::addLog(QString msg)
{
    beginInsertRows(QModelIndex(), 0, 0);
	list.insert(0, msg);
    endInsertRows();
}

int LogModel::rowCount(const QModelIndex & parent) const {
    return list.count();
}

QVariant LogModel::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() > list.count())
        return QVariant();

    const QString &msg = list[index.row()];
    if (role == logRole)
        return msg;
    return QVariant();
}
void LogModel::clear() {
	beginResetModel();
	list.clear();
	qDebug() << "-------------------------------CLEAR----------------------------------";
	endResetModel();
}
void LogModel::removeAt(int index) {
	beginRemoveRows(QModelIndex(), rowCount(), rowCount());
	list.removeAt(index);
	endRemoveRows();
}

#if QT_VERSION > 0x050000
QHash<int, QByteArray> LogModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[logRole] = "log";
    return roles;
}
#endif

void LogModel::onWLog(QString msg) {
	addLog(msg);
}
void LogModel::onClearLog() {
	clear();
}
/**********************************/
void writeLog(QString msg) {
	QDateTime currentDate = QDateTime::currentDateTime();
    QString time = currentDate.toString("dd/MM/yy -- hh:mm:ss");
	QString line = "[";
	line.append(time);
	line =	line + "] " + msg;
	q_log.enqueue(line);
}

