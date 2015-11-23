#include "OIUC.h"
OIUC* OIUC::singleton = 0;
OIUC* OIUC:: getOIUC() {
	if (!singleton) {
		singleton = new OIUC();
		return singleton;
	} else {
		return singleton;
	}	
}
OIUC::OIUC() {
	config = Config::getConfig();
	current_dial_number="000"; 
	username = "youhavenoname";
	password = "youhavenopassword";
	logged_in = false;
	memset(&app_data, 0, sizeof(app_data_t));
}

static void init_adv_server(app_data_t *app_data, char *adv_cs, node_t *node) {
    memset(&app_data->adv_server, 0, sizeof(app_data->adv_server));
    app_data->adv_server.on_request_f = &on_adv_info;
    app_data->adv_server.on_open_socket_f = &on_open_socket_adv_server;
    app_data->adv_server.user_data = node;

    adv_server_init(&app_data->adv_server, adv_cs);
    adv_server_start(&app_data->adv_server);
}

void OIUC::start(QString username, QString password) {
	char user[20], passwd[20];
    if (username != NULL) {
        this->username = username;
        this->password = password;

        strncpy(user, username.toLocal8Bit().constData(), 20);
        strncpy(passwd, password.toLocal8Bit().constData(), 20);
        ics_add_account(&app_data.ics, config->getAsteriskIP().toLocal8Bit().data(), user, passwd); 
    }
}
void OIUC::prepare() {
	//ics
    ics_pool_init(&app_data.ics);
    ics_pjsua_init(&app_data.ics); 
    ics_init(&app_data.ics);

    SET_LOG_LEVEL(4);
    pj_log_set_level(3);

	ics_set_default_callback(&on_reg_start_default);
	ics_set_reg_start_callback(&on_reg_start_impl);
	ics_set_reg_state_callback(&on_reg_state_impl);
	ics_set_incoming_call_callback(&on_incoming_call_impl);
	ics_set_call_state_callback(&on_call_state_impl);
	ics_set_call_transfer_callback(&on_call_transfer_impl);
	ics_set_call_media_state_callback(&on_call_media_state_impl);

	ics_start(&app_data.ics);
	config->getPortAsterisk(); // Don't need anymorea, now set default bind to any port
	ics_connect(&app_data.ics, config->getPortAsterisk());

	//node
    memset(&app_data.node, 0, sizeof(app_data.node));
   
	gm_cs = "udp:" + config->getArbiterIP() + ":" + QString::number(config->getPortSendToArbiter());
	gmc_cs = "udp:" + config->getOIUCIP() + ":" + QString::number(config->getPortOIUCListen());
	adv_cs = "udp:0.0.0.0:2015";

    init_adv_server(&app_data, adv_cs.toLocal8Bit().data(), &app_data.node);
    node_init(&app_data.node, config->getOIUCName().toLocal8Bit().data(), config->getLocation().toLocal8Bit().data(), config->getOIUCDescription().toLocal8Bit().data(), -1, strdup(gm_cs.toLocal8Bit().data()), strdup(gmc_cs.toLocal8Bit().data()), strdup(adv_cs.toLocal8Bit().data()));
    node_add_adv_server(&app_data.node, &app_data.adv_server);
    //gb
    memset(&app_data.gr, 0, sizeof(app_data.gr));
    app_data.gr.on_online_report_f = &on_online_report;
    app_data.gr.on_tx_report_f = &on_tx_report;
    app_data.gr.on_rx_report_f = &on_rx_report;
    app_data.gr.on_sq_report_f = &on_sq_report;
    gb_receiver_init(&app_data.gr, GB_CS);

    //STREAM
#if 1
    node_media_config(&app_data.node, &app_data.streamer, &app_data.receiver);
    app_data.node.streamer->pool = app_data.node.receiver->pool = app_data.ics.pool;
    app_data.node.streamer->ep = app_data.node.receiver->ep = pjsua_get_pjmedia_endpt();
    pjmedia_codec_g711_init(app_data.node.streamer->ep);
    pjmedia_codec_g711_init(app_data.node.receiver->ep);

    streamer_init(app_data.node.streamer, app_data.node.streamer->ep, app_data.node.streamer->pool);
    receiver_init(app_data.node.receiver, app_data.node.receiver->ep, app_data.node.receiver->pool, 2);

    streamer_config_dev_source(app_data.node.streamer, 2);
    receiver_config_dev_sink(app_data.node.receiver, 2);
#endif
}

void OIUC::call (QString number) {
	current_dial_number = number;
	number="sip:" + number + "@" + config->getAsteriskIP();
	char *c_uri = number.toLatin1().data();
	ics_make_call(&app_data.ics, c_uri);
}
void OIUC::hangupCall () {
	ics_hangup_call(&app_data.ics, 1);
}
void OIUC::hangupAllCall () {
	ics_hangup_call(&app_data.ics, 1);
}
void OIUC::conferenceCall () {
    // TODO
}
void OIUC::answerCall () { 
	ics_answer_call(&app_data.ics);
}
void OIUC::transferCall () {
	ics_transfer_call(&app_data.ics, 1, 2);
}
void OIUC::holdCall () {
	ics_hold_call(&app_data.ics);
}
void OIUC::releaseHoldCall () {
	ics_release_hold(&app_data.ics);
}
void OIUC::signalLoginStart() {
    emit loginStart();
}

void OIUC::runCallingState(QString msg, int st_code) {
	emit callingState(msg, st_code);
}
app_data_t *OIUC::getAppData() {
	return &app_data;
}
QString OIUC::getLastDialNumber() {
	return current_dial_number;
}
void OIUC::setLoggedIn(int flag, char *reason) {
	logged_in = (flag == 1);
	emit loggedInChange(QString::fromLocal8Bit(reason, -1));
}
bool OIUC::isLoggedIn() {
	return logged_in;
}
void OIUC::stop() {
    ics_set_registration(&app_data.ics, 0);
}

void OIUC::sendInvite(QString guest) {
	qDebug() << "++++++++++++++++" << guest;
	node_invite(&app_data.node, strdup(guest.toLocal8Bit().data()));
}
void OIUC::repulse(QString guest) {
	qDebug() << "----------------" << guest.toLocal8Bit().data();
	node_repulse(&app_data.node, strdup(guest.toLocal8Bit().data()));
}
void OIUC::PTT() {
	qDebug() << "*****************PTT PRESSED**********";
    node_start_session(&app_data.node);
}
void OIUC::endPTT() {
	qDebug() << "*****************PTT RELEASED**********";
    node_stop_session(&app_data.node);
}

