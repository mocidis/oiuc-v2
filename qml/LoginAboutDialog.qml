import QtQuick 1.0

DialogCommon {
    property alias reasonMsg: msgLabel.text
    id: root
    Item {
        anchors {
            fill: parent
            topMargin: 30
        }
        Flow {
            id: loginForm
            flow: Flow.TopToBottom
            anchors {
                top:parent.top
                left:parent.left
                right:parent.right
                margins: 10
            }
            spacing: 10
            Text {
                id: title
                font.pixelSize: 30
                font.bold: true
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "Login"
            }
            LabelCommon {
                id: msgLabel
                font.italic: true
                align: Text.AlignHCenter
                text: ""
                textColor: "Red"
            }
            Flow {
                width: parent.width
                spacing: 15
                height: 30
                Text {
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width/3
                    height: parent.height
                    text: "Username"
                }
                Rectangle {
                    width: parent.width/2
                    height: parent.height
                    border {
                        width: 1
                        color: "lightgray"
                    }
                    TextInput {
                        id: usrTextInput
                        anchors {
                            fill: parent
                            topMargin: 5
                            leftMargin: 5
                        }
                        text: ""
                        MouseArea {
                            anchors {
                                fill: parent
                            }
                            onClicked: {
                                if ( _KEYBOARD.textInput != null )
                                    _KEYBOARD.textInput.cursorVisible = false;
                                _KEYBOARD.textInput = usrTextInput;
                                _KEYBOARD.textInput.cursorVisible = true;
                            }
                        }
                    }
                }
            }
            Flow {
                width: parent.width
                height: 30
                spacing: 15
                Text {
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width/3
                    height: parent.height
                    text: "Password"
                }
                Rectangle {
                    width: parent.width/2
                    height: parent.height
                    border {
                        width: 1
                        color: "lightgray"
                    }
                    TextInput {
                        id: pwdTextInput
                        anchors {
                            fill: parent
                            topMargin: 5
                            leftMargin: 5
                        }
                        text: ""
                        echoMode:TextInput.Password
                        MouseArea {
                            anchors {
                                fill: parent
                            }
                            onClicked: {
                                if ( _KEYBOARD.textInput != null )
                                    _KEYBOARD.textInput.cursorVisible = false;
                                _KEYBOARD.textInput = pwdTextInput
                                _KEYBOARD.textInput.cursorVisible = true;
                            }
                        }
                    }
                }
            }
            Item {
                width: parent.width
                height: 40
                PushButton {
                    border {
                        width: 3
                        color: "gray"
                    }
                    width: parent.width/6
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: parent.width/3 + 15
                        topMargin: 10
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "Ok"
                        font {
                            bold: true
                        }
                        color: _ROOT.appState.loginInProgress?"lightgray":"black"
                    }
                    clickable: _ROOT.appState.loginInProgress?false:true
                    onClicked: {
                        pstn.pstnStart(usrTextInput.text, pwdTextInput.text);
                    }
                }
                PushButton {
                    border {
                        width: 2
                        color: "gray"
                    }
                    width: parent.width/6
                    clickable:_ROOT.appState.loginInProgress?false:true
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: parent.width/3 + parent.width/6 + 30
                        topMargin: 10
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "Reset"
                        color: _ROOT.appState.loginInProgress?"lightgray":"black"
                    }
                    onClicked: {
                        msgLabel.text = "";
                        usrTextInput.text = "";
                        pwdTextInput.text = "";
                    }
                }
            }
        }
        Flow {
            id: homeForm
            flow: Flow.TopToBottom
            anchors {
                top:parent.top
                left:parent.left
                right:parent.right
                margins: 10
            }
            spacing: 10
            Text {
                font.pixelSize: 30
                font.bold: true
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "Welcome to iCS-M"
            }
            LabelCommon {
                font.italic: true
                align: Text.AlignHCenter
                text: "Intergrated Communication System"
            }
            Item {
                width: parent.width
                height: childrenRect.height
                Image {
                    id: logo
                    source: "../static/iCS-M-medium.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    anchors {
                        top: logo.bottom
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 10
                    }
                    font {
                        pixelSize: 12
                        italic: true
                    }
                    color: "navy"
                    text: "version 1.0"
                }
            }
            Item {
                width: parent.width
                height: 40
                PushButton {
                    anchors.centerIn: parent
                    width: parent.width/2
                    height: parent.height

                    border {
                        width: 2
                        color: "gray"
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Logout"
                        font.pixelSize: 16
                        font.bold: true
                    }
                    //onClicked: _ROOT.appState.login = false;
                    onClicked: {
                        pstn.pstnStop();
                    }
                }
            }
        }
        LabelCommon {
            id: copyright
            anchors {
                left: parent.left
                right: parent.right
                top: loginForm.bottom
                margins: 10
                topMargin: 20
            }
            font.italic: true
            font.pixelSize: 12
            align: Text.AlignHCenter
            text: "Copyright © 2015–2020 Dicom Technology Co., Ltd.\nAll rights reserved."
            textColor: "darkgray"
            textAbove: false
        }
    }
    StateGroup {
        states: [
            State {
                name: "login"
                when: !_ROOT.appState.login
                PropertyChanges { target: homeForm; visible: false }
                PropertyChanges { target: loginForm; visible: true }
                PropertyChanges { target: copyright; anchors.top: loginForm.bottom }
                PropertyChanges { target: root; height: loginForm.height + copyright.height + 100; captionText: "Login"}
            },
            State {
                name: "logout"
                when: _ROOT.appState.login
                PropertyChanges { target: homeForm; visible: true }
                PropertyChanges { target: loginForm; visible: false }
                PropertyChanges { target: copyright; anchors.top: homeForm.bottom }
                PropertyChanges { target: root; height: homeForm.height + copyright.height + 100; captionText: "About"}
            }
        ]
    }
}
