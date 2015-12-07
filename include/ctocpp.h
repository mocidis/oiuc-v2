#ifndef CTOCPP_H
#define CTOCPP_H
#include <QtCore>
#include <QString>
extern "C"
{
#include "ics.h"
#include "ics-common.h"
#include <unistd.h>
#include "gb-receiver.h"	
#include "node.h"
#include "pttc_uart.h"
#include "ansi-utils.h"
#include "endpoint.h"
}
typedef struct {
    ics_t ics;
    node_t node;
    gb_receiver_t gr;
    adv_server_t adv_server;

    endpoint_t streamer;
    endpoint_t receiver;

    serial_t serial;
    pttc_t pttc;

    char serial_file[30];

} app_data_t;
void send_cmd_to_arbiter(char *radio_list, char *cmd);
//callback functions
void on_reg_start_impl (int account_id);
void on_reg_state_impl(int account_id, char* is_registration, int code, char *reason);
void on_incoming_call_impl(int account_id, int call_id, int st_code, char *remote_contact, char *local_contact);
void on_call_state_impl (int call_id, int st_code, char *st_text);
void on_call_transfer_impl (int call_id, int st_code, char *st_text);
void on_call_media_state_impl (int call_id, int st_code);

void on_adv_info(adv_server_t *adv_server, adv_request_t *request);
void on_online_report(char *id, char* des, int radio_port, int is_online);
void on_tx_report(char *id, int is_tx);
void on_rx_report(char *id, int is_rx);
void on_sq_report(char *id, int is_sq);

void on_pttc_ptt(int ptt);
#endif
