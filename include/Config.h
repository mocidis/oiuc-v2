#ifndef _CONFIG_H_
#define _CONFIG_H_

#include <QtCore>
#include <QtSql>
class Config;
class Config : public QObject {
	Q_OBJECT
public:	
	static Config *getConfig();

	/**************ADD and SET FUNCTIONS*****/
	void setAsteriskIP(QString value);
	void setPortAsterisk(int value);
	void setArbiterIP(QString value );
	void setPortSendToArbiter(int value);
	void setPortOIUCListen(int value);
	void setOIUCDescription(QString value);
	void setSpeakerVolume(double value);
	void setMicrophoneVolume(double value);
	void setLogDir(QString value);
	void setLogMaxLinePerFile(int value);
	void setLogMaxFile(int value);
	void setLogMaxLineDisplay(int value);
	void setOIUCName(QString value);
	void setLocation(QString value);
	void setOIUCIP(QString value);
	void setSoundStreamerIdx(int value);
	void setSoundReceiverIdx(int value);
	void setSerialFile(QString value);
    void setNumberChannels(int value);

	/**************GET FUNCTIONS*************/
	QString getAsteriskIP();
	int getPortAsterisk();
	QString getArbiterIP();
	int getPortSendToArbiter();
	int getPortOIUCListen();
	QString getOIUCDescription();
	double getSpeakerVolume();
	double getMicrophoneVolume();
	QString getLogDir();
	int getLogMaxLinePerFile();
	int getLogMaxFile();
	int getLogMaxLineDisplay();
	QString getOIUCName();
	QString getLocation();
	QString getOIUCIP();
	int getSoundStreamerIdx();
	int getSoundReceiverIdx();
	QString getSerialFile();
    int getNumberChannels();

    void dump();
private:
	/*****************Constructor*******************/
	Config ();
	static Config *config;

	/*****************Attribute********************/
	QString asterisk_ip;
	int port_connect_asterisk;
	QString arbiter_ip;
	int port_sendto_arbiter;
	int port_oiuc_listen;
	QString oiuc_description; 
	double speaker_volume;
	double microphone_volume;
	QString log_dir;
	int log_max_line_per_file;
	int log_max_file;
	int log_max_line_display;
	QString oiuc_name;
	QString location;
	QString oiuc_ip;
    int snd_streamer_idx;
    int snd_receiver_idx;
    QString serial_file;
    int nchans;
};

#endif
