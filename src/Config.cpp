#include "Config.h"

Config* Config::config=0;
Config* Config::getConfig() {
	if (config == NULL) {
		config = new Config();	
	}
	return config;
}
Config::Config() {
	asterisk_ip = "127.0.0.1";
	port_connect_asterisk = 1111;
	arbiter_ip = "127.0.0.1";
	port_sendto_arbiter = 6789;
	port_oiuc_listen = 9876;
	oiuc_description = "OIUC-DESC-DF"; 
	speaker_volume = 0.5;
	microphone_volume = 0.5;
}

/**************ADD and SET FUNCTIONS*****/
void Config::setAsteriskIP(QString value) {
	asterisk_ip = value;
}
void Config::setPortAsterisk(int value) {
	port_connect_asterisk = value;
}
void Config::setArbiterIP(QString value ) {
	arbiter_ip = value;
}
void Config::setPortSendToArbiter(int value) {
	port_sendto_arbiter = value;
}
void Config::setPortOIUCListen(int value) {
	port_oiuc_listen = value;
}
void Config::setOIUCDescription(QString value) {
	oiuc_description = value;
}
void Config::setSpeakerVolume(double value) {
	speaker_volume = value;
}
void Config::setMicrophoneVolume(double value) {
	microphone_volume = value;
}
void Config::setLogDir(QString value) {
	log_dir = value;
}
QString Config::getLogDir() {
	return log_dir;
}
void Config::setLogMaxLinePerFile(int value) {
	log_max_line_per_file = value;
}
void Config::setLogMaxFile(int value) {
	log_max_file = value;
}
void Config::setLogMaxLineDisplay(int value) {
	log_max_line_display = value;
}
void Config::setOIUCName(QString value) {
	oiuc_name = value;
}
void Config::setLocation(QString value) {
	location = value;
}
void Config::setOIUCIP(QString value) {
	oiuc_ip = value;
}
void Config::setSoundStreamerIdx(int value) {
    snd_streamer_idx = value;   
}
void Config::setSoundReceiverIdx(int value) {
    snd_receiver_idx = value;   
}
void Config::setSerialFile(QString value) {
    serial_file = value;
}
void Config::setNumberChannels(int value) {
    nchans = value;
}
/**************GET FUNCTIONS*************/
QString Config::getAsteriskIP() { return asterisk_ip;}
int Config::getPortAsterisk() { return port_connect_asterisk;}
QString Config::getArbiterIP() { return arbiter_ip;}
int Config::getPortSendToArbiter() { return port_sendto_arbiter;}
int Config::getPortOIUCListen() { return port_oiuc_listen;}
QString Config::getOIUCDescription() { return oiuc_description;}
double Config::getSpeakerVolume() { return speaker_volume;}
double Config::getMicrophoneVolume() { return microphone_volume;}
int Config::getLogMaxLinePerFile() { return log_max_line_per_file;}
int Config::getLogMaxFile() { return log_max_file;}
int Config::getLogMaxLineDisplay() { return log_max_line_display;}
QString Config::getOIUCName() { return oiuc_name;}
QString Config::getLocation() { return location;}
QString Config::getOIUCIP() { return oiuc_ip;}
int Config::getSoundStreamerIdx() { return snd_streamer_idx;}
int Config::getSoundReceiverIdx() { return snd_streamer_idx;}
QString Config::getSerialFile() { return serial_file;}
int Config::getNumberChannels() { return nchans;}

void Config::dump() {
    qDebug() << "----" << asterisk_ip;
    qDebug() << "----" << port_connect_asterisk;
    qDebug() << "----" << arbiter_ip;
    qDebug() << "----" << port_sendto_arbiter;
    qDebug() << "----" << port_oiuc_listen;
    qDebug() << "----" << oiuc_description;
    qDebug() << "----" << speaker_volume;
    qDebug() << "----" << microphone_volume;
    qDebug() << "----" << log_max_line_per_file;
    qDebug() << "----" << log_max_file;
    qDebug() << "----" << log_max_line_display;
    qDebug() << "----" << oiuc_name;
    qDebug() << "----" << location;
    qDebug() << "----" << oiuc_ip;
    qDebug() << "----" << snd_streamer_idx;
    qDebug() << "----" << snd_receiver_idx;
    qDebug() << "----" << serial_file;
    qDebug() << "----" << nchans;
}
