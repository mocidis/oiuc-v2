#include "backend.h"
void loadGeneralConfig(Config *config, QString backend_location) {
	{
		QSqlDatabase db;
		if (QSqlDatabase::contains("ics-database")) {
			db = QSqlDatabase::database("ics-database");
		} else {
            qDebug() << "------- try to open databases";
            db = QSqlDatabase::addDatabase("QSQLITE", "ics-database");
			db.setDatabaseName(backend_location);
			db.open();
        }
		if (!db.isOpen()) {
            qDebug() << "------- cannot open databases";
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
        int snd_streamer_idx = 0;
        int snd_receiver_idx = 0;
        QString serial_file;
        int nchans = 0;

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
            snd_streamer_idx = query.value(15).toInt();
            snd_receiver_idx = query.value(16).toInt();
            serial_file = query.value(17).toString();
            nchans = query.value(18).toInt();
		}
        //query.finish();
        //db.close();
		config->setAsteriskIP(asterisk_ip);
		config->setPortAsterisk(port_connect_asterisk);
		config->setArbiterIP(arbiter_ip);
		config->setPortSendToArbiter(port_sendto_arbiter);
		config->setPortOIUCListen(port_oiuc_listen);
		config->setOIUCDescription(oiuc_description);
		config->setSpeakerVolume(speaker_volume);
		config->setMicrophoneVolume(microphone_volume);
		config->setLogDir(log_dir);
		config->setLogMaxLinePerFile(log_max_line_per_file);
		config->setLogMaxFile(log_max_file);
		config->setLogMaxLineDisplay(log_max_line_display);
		config->setOIUCName(oiuc_name);
		config->setLocation(location);
		config->setOIUCIP(oiuc_ip);
        config->setSoundStreamerIdx(snd_streamer_idx); 
        config->setSoundReceiverIdx(snd_receiver_idx); 
        config->setSerialFile(serial_file);
        config->setNumberChannels(nchans);
        config->dump();
	}
	QSqlDatabase::removeDatabase(backend_location);
}
void loadHotlineModel(HotlineList *hotlineList, QString backend_location) {
	{
		QSqlDatabase db;
		if (QSqlDatabase::contains("ics-database")) {
			db = QSqlDatabase::database("ics-database");
		} else {
            qDebug() << "------- try to open databases";
            db = QSqlDatabase::addDatabase("QSQLITE", "ics-database");
			db.setDatabaseName(backend_location);
			db.open();
        }
		if (!db.isOpen()) {
            qDebug() << "------- cannot open databases";
			exit (EXIT_FAILURE);
		}
		QString command = "select * from ics_hotline";
		QSqlQuery query = db.exec(command);
		QString name = "default hotline name";
		QString desc = "default hotline desc";
		QString location = "unknown";
		QString phone = "111";
		QString freq = "100 Mhz";
		double volume = 0.5;
        while (query.next()) {
			name = query.value(0).toString();
			desc = query.value(1).toString();
			location = query.value(2).toString();
			phone = query.value(3).toString();
			freq = query.value(4).toString();
			volume = query.value(5).toDouble();
			Hotline *hotline = new Hotline(name, desc, location, phone, freq, volume);
			hotlineList->addHotline(hotline);
		}
        query.finish();
        db.close();
	}
}
