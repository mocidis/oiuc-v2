#include <QtCore>
#include <QString>
#include "ctocpp.h"
#include "Config.h"
#include "OIUC.h"
#include "Radio.h"
#include "RadioList.h"
#include "OIU.h"
#include "OIUList.h"
#include "Config.h"
#define MAX_URI_LENGTH 100

void on_reg_start_impl(int account_id) {
	printf("Acc id:: %d\n", account_id);
    OIUC::getOIUC()->signalLoginStart();
}
void copy_pj_str(char *dest, pj_str_t *source) {
    strncpy(dest, source->ptr, source->slen);
}

void copy_QString(char *dest, QString &source) {
    QByteArray ba = source.toLocal8Bit();
    strncpy(dest, ba.data(), ba.size());
}

void update_online_state( int online, pj_str_t *id, QString &description ) {
	Q_UNUSED(online);
	Q_UNUSED(id);
	Q_UNUSED(description);
    gm_request_t req;

    app_data_t *app_data;    
    app_data = OIUC::getOIUC()->getAppData();

    req.msg_id = GM_REG;

    ansi_copy_str(req.gm_reg.reg_id, app_data->node.id);
    ansi_copy_str(req.gm_reg.gmc_cs,app_data->node.gmc_cs);
    ansi_copy_str(req.gm_reg.location,app_data->node.location);
    ansi_copy_str(req.gm_reg.desc,app_data->node.desc);

/*
    memset(req.gm_reg.reg_id, 0, sizeof(req.gm_reg.reg_id));
    strncpy(req.gm_reg.reg_id, app_data->node.id, strlen(app_data->node.id));
    memset(req.gm_reg.gmc_cs, 0, sizeof(req.gm_reg.gmc_cs));
    strncpy(req.gm_reg.gmc_cs, app_data->node.gmc_cs, strlen(app_data->node.gmc_cs));
    memset(req.gm_reg.location, 0, sizeof(req.gm_reg.location));
    strncpy(req.gm_reg.location, app_data->node.location, strlen(app_data->node.location));
    memset(req.gm_reg.desc, 0, sizeof(req.gm_reg.desc));
    strncpy(req.gm_reg.desc, app_data->node.desc, strlen(app_data->node.desc));
*/
    req.gm_reg.radio_port = app_data->node.radio_port;    

    //Send MG_REQ
    PERROR_IF_TRUE(gm_client_send(&app_data->node.gm_client, &req) < 0, "ERROR:: registered failed - ");
}

void get_radio_list() {
    app_data_t *app_data;    
    app_data = OIUC::getOIUC()->getAppData();
    gm_request_t req;

    req.msg_id = GM_GET_INFO;

    ansi_copy_str(req.gm_get_info.owner_id, app_data->node.id);

    //Send MG_REQ
    PERROR_IF_TRUE(gm_client_send(&app_data->node.gm_client, &req) < 0, "ERROR:: gm get info failed - ");
}


void on_reg_state_impl(int account_id, char* is_registration, int code, char *reason){
    SHOW_LOG(3, "ON_REG_STATE_IMPL\n");
    RadioList *radio_list = RadioList::getRadioListSingleton();
    QList<Radio*> _radio_list;

	ics_t *data;
	data = (ics_t *)pjsua_acc_get_user_data(account_id);
    OIUC *oiuc = OIUC::getOIUC();
    
    pj_str_t *id = &(data->acfg.cred_info[0].username);
    QString description = Config::getConfig()->getOIUCDescription();

    int online = 0;
    if( code == 200 && strcmp(is_registration, "No") != 0 ) {
        online = 1;
        oiuc->setLoggedIn(online, reason);
	}
    if( code == 200 && strcmp(is_registration, "No") == 0 ) {
        oiuc->setLoggedIn(online, (char *)"");
    }
    else {
        oiuc->setLoggedIn(online, reason);
    }
    update_online_state(online, id, description);

    _radio_list = radio_list->getRadioList();

    SHOW_LOG(3, "List count: %d\n", _radio_list.count());

    if (_radio_list.count() == 0) {
        SHOW_LOG(3, "Get radio list\n");          
        get_radio_list();
    }
}

void on_incoming_call_impl(int account_id, int call_id, int st_code, char *remote_contact, char *local_contact) {
    Q_UNUSED(account_id);
    Q_UNUSED(call_id);
    Q_UNUSED(local_contact);
	QString msg = QString::fromUtf8(remote_contact);
	OIUC *dial = OIUC::getOIUC();
	dial->runCallingState(msg, st_code);
}

void on_call_state_impl(int call_id, int st_code, char *st_text) {
    Q_UNUSED(call_id);
	QString msg = QString::fromUtf8(st_text);
	OIUC *dial = OIUC::getOIUC();
	dial->runCallingState(msg, st_code);
}

void on_call_transfer_impl(int call_id, int st_code, char *st_text) {
    Q_UNUSED(call_id);  
	QString msg = QString::fromUtf8(st_text);
	OIUC *dial = OIUC::getOIUC();
	dial->runCallingState(msg, st_code);
}

void on_call_media_state_impl(int call_id, int st_code) {
	printf("Call id: %d\n", call_id);
	printf("Status: %d\n", st_code);
}

void on_adv_info(adv_server_t *adv_server, adv_request_t *request) {
	Q_UNUSED(adv_server);
	Q_UNUSED(request);
    SHOW_LOG(4, "Received: ID = %s\nSDP addr %s:%d\n", request->adv_info.adv_owner, request->adv_info.sdp_mip, request->adv_info.sdp_port);
}

void on_online_report(char *id, char* des, int radio_port, int is_online) {
	if (radio_port >=0 ) {
		//For Radio
		RadioList *radio_list = RadioList::getRadioListSingleton();
		QString name = "WTF_RADIO?";
		QString desc = "WTF_NO_DESC?";

		name = QString::fromLocal8Bit(id);
		desc = QString::fromLocal8Bit(des);
		bool online = false;
		if ( is_online == 1 ) {
			online = true;
		}
		int index = -1;
		index = radio_list->searchRadioByName(name);
		if (index == -1) {
			Radio *radio = new Radio(name, desc, radio_port, online, false, false);
			radio_list->addRadio(radio);
		} else {
			radio_list->updateRadioState(index, RADIO_ONLINE, online);
		}
	} else {
		//For OIU
		OIUList *oiu_list = OIUList::getOIUListSingleton();
		QString name = "WTF_RADIO?";
		QString desc = "WTF_NO_DESC?";

		name = QString::fromLocal8Bit(id);
        name.remove(0,5); //remove OIUC prefix
		desc = QString::fromLocal8Bit(des);
		bool online = false;
		if ( is_online == 1 ) {
			online = true;
		}
		int index = -1;
		if (name == Config::getConfig()->getOIUCName()) {
			return;	
		}
		index = oiu_list->searchOIUByName(name);
		if (index == -1) {
			OIU *oiu = new OIU(name, desc, -1, online, false, false);
			oiu_list->addOIU(oiu);
		} else {
			oiu_list->updateOIUState(index, OIU_ONLINE, online);
		}
	}
}

void on_tx_report(char *id, int is_tx) {
	RadioList *radio_list = RadioList::getRadioListSingleton();

	QString name="FTW_RADIO?";
	name = QString::fromLocal8Bit(id);	
	bool tx = false;
	int index = -1;
	index = radio_list->searchRadioByName(name);

	if (index > -1) {
		if (is_tx == 1) {
			tx = true;
		}
		radio_list->updateRadioState(index, RADIO_TX, tx);
	} else {
		//Do nothing
	}
}
void on_rx_report(char *id, int is_rx) {
	RadioList *radio_list = RadioList::getRadioListSingleton();

	QString name="FTW_RADIO?";
	name = QString::fromLocal8Bit(id);	
	bool rx = false;
	int index = -1;
	index = radio_list->searchRadioByName(name);

	if (index > -1) {
		if (is_rx == 1) {
			rx = true;
		}
		radio_list->updateRadioState(index, RADIO_RX, rx);
	} else {
		//Do nothing
	}
}
void on_sq_report(char *id, int is_sq) {
	RadioList *radio_list = RadioList::getRadioListSingleton();

	QString name="FTW_RADIO?";
	name = QString::fromLocal8Bit(id);	
	bool sq = false;
	int index = -1;
	index = radio_list->searchRadioByName(name);

	if (index > -1) {
		if (is_sq == 1) {
			sq = true;
		}
		radio_list->updateRadioState(index, RADIO_SQ, sq);
	} else {
		//Do nothing
	}
}

void on_pttc_ptt(int ptt) {
    fprintf(stdout, "PTTC - ptt is %d\n", ptt);

    app_data_t *app_data;    
    app_data = OIUC::getOIUC()->getAppData();

    switch(ptt) {
        case 1:
            OIUC::getOIUC()->signalPTTPressed();
            //node_start_session(&app_data->node);
            break;
        case 0:
            OIUC::getOIUC()->signalPTTReleased();
            //node_stop_session(&app_data->node);
            break;
        default:
            qDebug() << "Unknown signal ptt\n";
            break;      
    }

}

