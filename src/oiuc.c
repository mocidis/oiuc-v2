#include "ansi-utils.h"
#include "ics.h"
#include "node.h"
#include "gb-receiver.h"

void on_adv_info(adv_server_t *adv_server, adv_request_t *request) {
    SHOW_LOG(4, fprintf(stdout,"Received: ID = %s\nSDP addr %s:%d\n", request->adv_info.info_id, request->adv_info.sdp_mip, request->adv_info.sdp_port));
}

void on_online_report(char *id, char *desc, int radio_port, int is_online) {
    SHOW_LOG(4, fprintf(stdout, "O_REPT:%s Desc: %s Radio port: %d (online=%d)\n", id,desc, radio_port, is_online));
}
void on_tx_report(char *id, int is_tx) {
    SHOW_LOG(4, fprintf(stdout, "T_REPT:%s(tx=%d)\n", id, is_tx));
}
void on_rx_report(char *id, int is_rx) {
    SHOW_LOG(4, fprintf(stdout, "R_REPT:%s(rx=%d)\n", id, is_rx));
}
void on_sq_report(char *id, int is_sq) {
    SHOW_LOG(4, fprintf(stdout, "Q_REPT:%s(sq=%d)\n", id, is_sq));
}

void on_reg_start_impl(int account_id);
void on_reg_state_impl(int account_id, char* is_registration, int code, char *reason);
void on_incoming_call_impl(int account_id, int call_id, int st_code, char *remote_contact, char *local_contact);
void on_call_state_impl(int call_id, int st_code, char *st_text);

void *auto_register(void *node_data) {
    node_t *node = (node_t *)node_data;
    while (1) {
        node_register(node);
        usleep(5*1000*1000);
    }
}

void usage(char *app) {
    SHOW_LOG(5, fprintf(stdout,"usage: %s <id> <location> <desc> <radio_port> <gm_cs> <gmc_cs>\n", app));
    exit(-1);
}

int main(int argc , char *argv[]) {
    ics_t ics;
    node_t node;
    gb_receiver_t gr;

    if (argc < 8)
        usage(argv[0]);
    char *gm_cs;
    char *gmc_cs;
    char adv_cs[30];
    char gb_cs[30];
    char guest[10];

    pthread_t thread;
    int n, chose;
    char option[5], sip_add[50];

    //int adv_port = ADV_PORT;
    int adv_port = 2015;
    int gb_port = GB_PORT; 
    
    SET_LOG_LEVEL(4);

    gm_cs = argv[5];
    gmc_cs = argv[6];
    n = sprintf(adv_cs, "udp:0.0.0.0:%d", adv_port);
    adv_cs[n] = '\0';
    n = sprintf(gb_cs, "udp:%s:%d",GB_MIP, gb_port);
    gb_cs[n] = '\0';
    /*--------- ICS ---------*/

    ics_pool_init(&ics);  
    ics_pjsua_init(&ics);
    ics_init(&ics);

	ics_set_default_callback(&on_reg_start_default);

	ics_set_reg_start_callback(&on_reg_start_impl);
	ics_set_reg_state_callback(&on_reg_state_impl);
	ics_set_incoming_call_callback(&on_incoming_call_impl);
	ics_set_call_state_callback(&on_call_state_impl);

	ics_start(&ics);
	ics_connect(&ics, 1235);
	ics_add_account(&ics, "192.168.2.50", "quy", "1234");

    /*------------ NODE ------------*/
    memset(&node, 0, sizeof(node));
    node.on_adv_info_f = &on_adv_info;
    node_init(&node, argv[1], argv[2], argv[3], atoi(argv[4]), gm_cs, gmc_cs, adv_cs);

    /*----------- GB --------------*/
    memset(&gr, 0, sizeof(gr));
    gr.on_online_report_f = &on_online_report;
    gr.on_tx_report_f = &on_tx_report;
    gr.on_rx_report_f = &on_rx_report;
    gr.on_sq_report_f = &on_sq_report;

    gb_receiver_init(&gr, gb_cs);

    ////////////////////
    pthread_create(&thread, NULL, auto_register, &node) ;  

    ///////////////////////////////////////////////////////////
    // For Test Only: PTT - GM_INFO
    gm_request_t req_info;
    req_info.msg_id = GM_INFO;
    ansi_copy_str(req_info.gm_info.info_id, argv[1]);
    ansi_copy_str(req_info.gm_info.sdp_mip, "111.111.111.111");
    req_info.gm_info.sdp_port = 1111;
    
    while (1) {
        if (fgets(option, sizeof(option), stdin) == NULL ) {
            SHOW_LOG(5, fprintf(stdout,"NULL cmd"));
        }
        switch(option[0]) {
            case 'j':
                memset(guest, 0 , sizeof(guest));
                n = sprintf(guest, "RIUC1%c", option[1]);
                printf("guest = %s\n", guest);
                guest[n] = '\0';

                node_invite(&node, guest);
                break;
            case 'l':
                memset(guest, 0 , sizeof(guest));
                n = sprintf(guest, "RIUC1%c", option[1]);
                guest[n] = '\0';

                node_repulse(&node, guest);
                break;
            case 'r':
                node_register(&node);
                break;
            case 't':
                PERROR_IF_TRUE(gm_client_send(&node.gm_client, &req_info) < 0, "ERROR::send failed - ");
                break;
            case 'd':
                node_pause(&node);
                break;
            case 'e':
                node_resume(&node);
                break;
            case '1':
                gb_server_join(&gr.gb_server, GB_MIP);
            case '2':
                gb_server_leave(&gr.gb_server, GB_MIP);
                break;
            case 'm':
                SHOW_LOG(4, fprintf(stdout,"Chose a call:\n"));
                SHOW_LOG(4, fprintf(stdout,"1.quy2@192.168.2.50\n"));
                SHOW_LOG(4, fprintf(stdout,"2.quy3@192.168.2.50\n"));
                SHOW_LOG(4, fprintf(stdout,"3.quy10@192.168.2.50\n"));
                SHOW_LOG(4, fprintf(stdout,"4.ntt@192.168.2.50\n"));
                SHOW_LOG(4, fprintf(stdout,"5.ntt1@191.168.2.50\n"));
                SHOW_LOG(4, fprintf(stdout,"6. 1\n"));
                SHOW_LOG(4, fprintf(stdout,"7.852@101.248.11.221"));
                if (scanf("%d",&chose) != 1){
                    SHOW_LOG(4, fprintf(stdout,"Invalid input value\n"));
                }
                switch(chose) {
                    case 1:
                        strcpy(sip_add, "sip:quy2@192.168.2.50");
                        ics_make_call(&ics, sip_add);
                        break;
                    case 2:
                        strcpy(sip_add, "sip:quy3@192.168.2.50");
                        ics_make_call(&ics, sip_add);
                        break;	
                    case 3:
                        strcpy(sip_add, "sip:quy10@192.168.2.50");
                        ics_make_call(&ics, sip_add);
                        break;
                    case 4:
                        strcpy(sip_add, "sip:ntt@192.168.2.50");
                        ics_make_call(&ics, sip_add);
                        break;
                    case 5:
                        strcpy(sip_add, "sip:ntt1@192.168.2.50");
                        ics_make_call(&ics, sip_add);
                        break;
                    case 6:
                        strcpy(sip_add, "sip:852901252465677@10.248.11.221");
                        ics_make_call(&ics, sip_add);
                        break;
                    case 7:
                        strcpy(sip_add, "sip:@192.168.2.50");
                        ics_make_call(&ics, sip_add);
                        break;
                    default:
                        SHOW_LOG(5, fprintf(stdout,"Press 'm' to make another call\n"));
                        break;
                }
                break;
            case 'a':
                ics_answer_call(&ics);
                break;
            case 'h':
                if (option[1] == 'a')
                    ics_hangup_call(&ics, -2);
                else
                    ics_hangup_call(&ics, 0);
                break;
            default:
                SHOW_LOG(5,fprintf(stdout,"Unknow command\n"));
                break;
        }
    }

    return 0;
} 

void on_reg_start_impl(int account_id) {
	SHOW_LOG(5, fprintf(stdout,"Acc id:: %d\n", account_id)); 
}

void on_reg_state_impl(int account_id, char* is_registration, int code, char *reason){
	SHOW_LOG(5, fprintf(stdout,"Acc id: %d\n", account_id));
	SHOW_LOG(5, fprintf(stdout,"Registed: %s \n", is_registration));
	SHOW_LOG(4, fprintf(stdout,"Status: %d(%s)\n", code, reason));
}

void on_incoming_call_impl(int account_id, int call_id, int st_code, char *remote_contact, char *local_contact) {
	SHOW_LOG(4, fprintf(stdout,"Acc id: %d\n", account_id));
	SHOW_LOG(4, fprintf(stdout,"Call id: %d\n", call_id));
	SHOW_LOG(4, fprintf(stdout,"From: %s\n", remote_contact));	
	SHOW_LOG(4, fprintf(stdout,"To: %s\n", local_contact));
    SHOW_LOG(4, fprintf(stdout,"Call state: %d\n", st_code));
}

void on_call_state_impl(int call_id, int st_code,  char *st_text) {
	SHOW_LOG(4, fprintf(stdout,"Call %d state= %s(%d)\n", call_id, st_text, st_code));
}

