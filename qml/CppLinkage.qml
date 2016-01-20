@QtQuick
Item {
    Connections {
        target: oiuc
        onLoginStart: {
            _LOGINDIALOG.reasonMsg = "Logging in ...";
            _ROOT.appState.loginInProgress = true;
        }
        onLoggedInChange: {
            console.log("on_reg_state");
            _ROOT.appState.loginInProgress = false;
            _ROOT.appState.login = oiuc.isLoggedIn();
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
        onPTTPressed: {
            console.log(" ---- PTT pressed\n");
            _PTTBTN.clicked(null);
        }
        onPTTReleased: {
            console.log(" ---- PTT released\n");
            _PTTBTN.released(null);
        }
    }
    Connections {
        target: radioList
        onUpdateRadioList: {
            if (mIndex == -1) {
                radios.append({
					"id": id,
                    "name": name, 
					"description": desc,
					"freq": freq,
					"port": port,
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
                radios.setProperty(mIndex, "isOnline", bOnline);
                radios.setProperty(mIndex, "isTx", bTx);
                radios.setProperty(mIndex, "isRx", bRx);
                radios.setProperty(mIndex, "isSQ", bSQ);
				//radios.setProperty(mIndex, "freq", freq);
                //radios.setProperty(mIndex, "volume", rVolume);
            }
        }
    }
    Connections {
        target: oiuList
        onUpdateOIUList: {
            if (mIndex == -1) {
                oius.append({
					"id": id,
					"name": name,
					"description": desc,
					//"port": name,
                    "isOnline": bOnline,
                    "isPTT": false,
                    "isTx": bTx,
                    "isRx": bRx,
                    "isRxBlocked": false,
                    "isSQ": bSQ,
                    "volume": 0.5
                });
            } else {
                oius.setProperty(mIndex, "name", name);
                //oius.setProperty(mIndex, "port", name);
                oius.setProperty(mIndex, "isOnline", bOnline);
                oius.setProperty(mIndex, "isTx", bTx);
                oius.setProperty(mIndex, "isRx", bRx);
                oius.setProperty(mIndex, "isSQ", bSQ);
                //radios.setProperty(mIndex, "volume", rVolume);
            }
        }
    }
}
