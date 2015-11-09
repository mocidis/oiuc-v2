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
