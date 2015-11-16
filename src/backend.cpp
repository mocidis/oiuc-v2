#include "backend.h"
void loadGeneralConfig(Config *config, QString backend_location) {
	{
		QSqlDatabase db;
		if (QSqlDatabase::contains("ics-database")) {
			db = QSqlDatabase::database("ics-database");
		} else {
			db = QSqlDatabase::addDatabase("QSQLITE", "ics-database");
			db.setDatabaseName(backend_location);
			db.open();
		}
		if (!db.isOpen()) {
			qDebug() << "-------" << backend_location;
			exit (EXIT_FAILURE);
		}
		QString command = "select * from ics_config";
		QSqlQuery query = db.exec(command);
		QString asterisk_ip;
		int port_connect_asterisk=0;
		QString arbiter_ip;
		int port_sendto_arbiter=0;
		int port_oiuc_listen=0;
		QString oiuc_description; 
		double speaker_volume=0;
		double microphone_volume=0;
		QString log_dir;
		int log_max_line_per_file=0;
		int log_max_file=0;
		int log_max_line_display=0;
		QString oiuc_name;
		QString location;
		QString oiuc_ip;
		while (query.next()) {
			asterisk_ip = query.value(0).toString();
			port_connect_asterisk = query.value(1).toInt();
			arbiter_ip = query.value(2).toString();
			port_sendto_arbiter = query.value(3).toInt();
			port_oiuc_listen = query.value(4).toInt();
			oiuc_description = query.value(5).toString(); 
			speaker_volume = query.value(6).toDouble();
			microphone_volume = query.value(7).toDouble();
			log_dir = query.value(8).toString();
			log_max_line_per_file = query.value(9).toInt();
			log_max_file = query.value(10).toInt();
			log_max_line_display = query.value(11).toInt();
			oiuc_name = query.value(12).toString();
			location = query.value(13).toString();
			oiuc_ip = query.value(14).toString();
		}
		config->setAsteriskIP (asterisk_ip);
		config->setPortAsterisk (port_connect_asterisk);
		config->setArbiterIP (arbiter_ip);
		config->setPortSendToArbiter (port_sendto_arbiter);
		config->setPortOIUCListen (port_oiuc_listen);
		config->setOIUCDescription (oiuc_description);
		config->setSpeakerVolume (speaker_volume);
		config->setMicrophoneVolume (microphone_volume);
		config->setLogDir(log_dir);
		config->setLogMaxLinePerFile(log_max_line_per_file);
		config->setLogMaxFile(log_max_file);
		config->setLogMaxLineDisplay(log_max_line_display);
		config->setOIUCName(oiuc_name);
		config->setLocation(location);
		config->setOIUCIP(oiuc_ip);
	}
	QSqlDatabase::removeDatabase(backend_location);
}
