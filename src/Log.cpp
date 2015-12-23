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
}
void Log::logs(QString msg) {
	Config *config = Config::getConfig();
	logModel->addLog(msg);
	int maxline = config->getLogMaxLineDisplay();
	qDebug() << "--------------------" << maxline;
	if (logModel->rowCount() >= maxline) {
		qDebug() << "+++++++++++++++++++++++++++++" << maxline;
		logModel->removeAt(logModel->rowCount() - 1);
	}
}
void Log::setFilename(QString _filename) {
	filename = _filename;
}

QString Log::getFilename() {
	return filename;
}

void Log::run() {
	logfile.setFileName(filename);
	fileMaintenance();
	if (!logfile.open(QIODevice::WriteOnly | QIODevice::Text) ) {
		return;
	}
	out.setDevice(&logfile);
	int _max_line = 0;
	int _max_buffer_line = 0;
	QString filenameS="";
	while(1) {
		if (!q_log.isEmpty()) {
			out << q_log.dequeue() << "\n";
			_max_buffer_line++;
			_max_line++;
		}
		if (_max_line >= max_line) {
			out.flush();
			filenameS = filename;
			filenameS += QString::number(file_count%max_file);
			logfile.copy(this->getFilename(), filenameS);
			logfile.resize(0);
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
void Log::fileMaintenance() {
	for (int i=0; i<max_file; i++) {
		QFile file(filename + QString::number(i));
		if (!file.exists()) {
			QFileInfo info(logfile);
			file_count = i;
			if (info.size() != 0) {
				QString filenameS = filename + QString::number(file_count);
				logfile.copy(filename, filenameS); 
				file_count++;
			}
			break;
		}
	}
}
void Log::flushLog() {
	out << "\nFILE FLUSHED";
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
    beginInsertRows(QModelIndex(), rowCount()-1, rowCount()-1);
	//list.insert(0, msg);
	list.append(msg);
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

/**********************************/
void writeLog(QString msg, int dev) {
	Log *log = Log::getLog();
	QDateTime currentDate = QDateTime::currentDateTime();
    QString time = currentDate.toString("dd/MM/yy -- hh:mm:ss");
	QString line = "[";
	switch (dev) {
		case SCREENS:
			line.append(time);
			line =	line + "] " + msg;
			log->logs(line);
			q_log.enqueue(line);
			break;
		case FILES:
			line.append(time);
			line =	line + "] " + msg;
			q_log.enqueue(line);
			break;
		default:
			break;
	}
}

