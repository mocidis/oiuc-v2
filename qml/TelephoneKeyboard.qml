import QtQuick 1.0

DialogCommon {
    id: root
    property int keySize: 100
    property int itemSpacing: 10
    width: content.width
    height: content.height + 30
    captionText: "Telephone"
    onClose: visible = false
    Item {
        id: content
        width: childrenRect.width + 20
        height: childrenRect.height + 20
        anchors {top: parent.top; topMargin: 30}
        Flow {
            flow: Flow.TopToBottom
            spacing: itemSpacing
            width: 3 * keySize + 2*itemSpacing
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 10
                leftMargin: 10
            }
            NumberLCD {
                width: parent.width
                height: keySize * 0.6
                id: numberLCD
            }
            Flow {
                id: flow
                width: parent.width
                spacing: itemSpacing
                PushButton {
                    width: keySize
                    height: keySize * 0.6
                    border {
                        width: 2
                        color: "lightgray"
                    }
                    Image {
                        source: "../static/call-fill-black-small.svg"
                        anchors { centerIn: parent }
                    }
                    onClicked: pstn.pstnCall(numberLCD.text)
                }
                ToggleButton {
                    id:kbkey
                    width: keySize
                    height: keySize * 0.6
                    onColor: "black"
                    border {
                        width: 2
                        color: "lightgray"
                    }
                    Image {
                        id: kbimage
                        source: "../static/keyboard-black.svg"
                        anchors {
                            centerIn: parent
                        }
                    }
                    onClicked:  _KEYBOARD.textInput = value?numberLCD.textInput:null
                }
                Key {
                    width: keySize
                    height: keySize * 0.6
                    isCap: true
                    value: "DONE"
                    color: "black"
                    textColor: "white"
                    onClicked: root.visible = false
                }
                Repeater {
                    model: ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
                    delegate: Key {
                        width: keySize
                        height: keySize * 0.6
                        value: modelData
                        onClicked: numberLCD.text += modelData
                    }
                }
                Key {
                    width: keySize
                    height: keySize * 0.6
                    isCap: true
                    textColor: "black"
                    value: "CLR"
                    onClicked: numberLCD.text = ""
                }
                Key {
                    width: keySize
                    height: keySize * 0.6
                    value: "0"
                    onClicked: numberLCD.text += "0"
                }
                Key {
                    width: keySize
                    height: keySize * 0.6
                    isCap: true
                    textColor: "black"
                    value: "RDL"
                    onClicked: numberLCD.text = pstn.getLastDialNumber();
                }
            }
        }
        StateGroup {
            states: [
                State {
                    name: "keyboardVisible"
                    when: _KEYBOARD.visible
                    PropertyChanges { target: kbkey; value: true  }
                    PropertyChanges { target: kbimage; source: "../static/keyboard-white.svg"  }
                },
                State {
                    name: "keyboardInvisible"
                    when: !_KEYBOARD.visible
                    PropertyChanges { target: kbkey; value: false }
                    PropertyChanges { target: kbimage; source: "../static/keyboard-black.svg"  }
                }
            ]
        }
    }
}
