import QtQuick 1.0
Item {
    Connections {
        target: pstn
        onLoginStart: {
            _LOGINDIALOG.reasonMsg = "Logging in ...";
            _ROOT.appState.loginInProgress = true;
        }
        onLoggedInChange: {
            console.log("on_reg_state");
            _ROOT.appState.loginInProgress = false;
            _ROOT.appState.login = pstn.isLoggedIn();
            if(_ROOT.appState.login) {
                _LOGINDIALOG.visible = false;
            }
            else {
                _LOGINDIALOG.visible = true;
            }
            _LOGINDIALOG.reasonMsg = reason;
        }
        onCallingState: {
            _CALLDIALOG.text = msg;

            /*****
            0 PJSIP_INV_STATE_NULL     Before INVITE is sent or received 
            1 PJSIP_INV_STATE_CALLING     After INVITE is sent
            2 PJSIP_INV_STATE_INCOMING     After INVITE is received.
            3 PJSIP_INV_STATE_EARLY     After response with To tag.
            4 PJSIP_INV_STATE_CONNECTING     After 2xx is sent/received.
            5 PJSIP_INV_STATE_CONFIRMED     After ACK is sent/received.
            6 PJSIP_INV_STATE_DISCONNECTED     Session is terminated. 
            *****/

               if (st_code == 2) {
                _CALLDIALOG.dialogState = 2; 
            } else if ( st_code == 0) {
                _CALLDIALOG.dialogState    = 0;
            } else if (st_code == 1) {
                _CALLDIALOG.dialogState    = 1;
            } else if (st_code == 5) {
                _CALLDIALOG.dialogState = 3;
            } else if (st_code == 6) {
                _CALLDIALOG.dialogState = 0;    
            }
        }
    }
    Connections {
        target: radioObj 
        onUpdateRadioManager: {
            if (mIndex == -1) {
                radios.append({
                    "name": name, 
                    "frequency":frequency, 
                    "location": location, 
                    "port_mip": port_mip, 
                    "downtime": downtime,
                    "port": port, 
                    "description": desc,
                    "isOnline": bOnline,
                    "isPTT": false,
                    "isTx": bTx,
                    "isRx": bRx,
                    "isRxBlocked": false,
                    "isSQ": bSQ,
                    "volume": 0.5
                });
            } else {
                radios.setProperty(mIndex, "name", name);
                radios.setProperty(mIndex, "frequency", frequency);
                radios.setProperty(mIndex, "location", location);
                radios.setProperty(mIndex, "port_mip", port_mip);
                radios.setProperty(mIndex, "downtime", downtime);
                radios.setProperty(mIndex, "port", port);
                radios.setProperty(mIndex, "description", desc);
                radios.setProperty(mIndex, "isOnline", bOnline);
                radios.setProperty(mIndex, "isTx", bTx);
                radios.setProperty(mIndex, "isRx", bRx);
                radios.setProperty(mIndex, "isSQ", bSQ);
                radios.setProperty(mIndex, "volume", rVolume);
            }
        }
    }
    Connections {
        target: oiucObj
        onUpdateOIUCManager: {
            if (mIndex == -1) {
                oius.append({
                    "type": type, 
                    "name": name, 
                    "status":status, 
                    "downtime":downtime, 
                    "description":desc,
                    "iState": 0
                });
            } else {
                oius.setProperty(mIndex, "type", type);
                oius.setProperty(mIndex, "name", name);
                oius.setProperty(mIndex, "status", status);
                oius.setProperty(mIndex, "downtime", downtime);
                oius.setProperty(mIndex, "description", desc);
            }
        }
    }
}
