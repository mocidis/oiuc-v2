import QtQuick 1.0

Rectangle {
    property int keySize: 50
    property int outerMargin: 10
    property TextInput textInput: null

    signal clicked(string key);
    function doClick(key) {
        if (key == "DEL") {
            textInput.text = textInput.text.substring(0, textInput.text.length - 1);
        }
        else if (key == "SPACE") {
            textInput.text += " ";
        }
        else {
            textInput.text += key;
        }
    }

    id: root

    width: childrenRect.width + 2 * outerMargin
    height: childrenRect.height + 2 * outerMargin
    radius: 3
    border {
        width: 2
        color: "gray"
    }
    Flow {
        flow: Flow.TopToBottom
        spacing: 5
        anchors {
            top: parent.top
            left: parent.left
            topMargin: outerMargin
            leftMargin: outerMargin
        }
        Flow {
            spacing: 5
            width: (keySize + 5) * row1Repeater.model.count
            height: keySize
            Repeater {
                id: row1Repeater
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "_"]
                delegate: Key {
                    width: keySize
                    value: modelData
                    onClicked: textInput.text += text;
                }
            }
            Key {
                width: keySize
                value: "DEL"
                isCap: true
                onClicked: textInput.text = textInput.text.substring(0, textInput.text.length - 1);
            }

        }
        Flow {
            spacing: 5
            width: (keySize + 5) * row1Repeater.model.count
            height: keySize
            Rectangle {
                width: keySize/2 - 2
                height: keySize
                border {
                    width: 1
                    color: "lightgray"
                }
            }
            Repeater {
                id: row2Repeater
                model: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "!", "&", ]
                delegate: Key {
                    width: keySize
                    value: modelData
                    isCap: shiftKey.value
                    onClicked: textInput.text += text
                }
            }
            Rectangle {
                width: keySize/2 - 2
                height: keySize
                border {
                    width: 1
                    color: "lightgray"
                }
            }
        }
        Flow {
            spacing: 5
            width: (keySize + 5) * row1Repeater.model.count
            height: keySize
            Rectangle {
                width: keySize
                height: keySize
                border {
                    width: 1
                    color: "lightgray"
                }
            }
            Repeater {
                id: row3Repeater
                model: ["a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "$", "%"]
                delegate: Key {
                    width: keySize
                    value: modelData
                    isCap: shiftKey.value
                    onClicked: textInput.text += text;
                }
            }
        }
        Flow {
            spacing: 5
            width: (keySize + 5) * row1Repeater.model.count
            height: keySize
            ToggleKey {
                id: shiftKey
                width: keySize * 1.5 + 2
                height: keySize
                text: "SHIFT"
            }
            Repeater {
                id: row4Repeater
                model: ["z", "x", "c", "v", "b", "n", "m", ",", ".", "/"]
                delegate: Key {
                    width: keySize
                    value: modelData
                    isCap: shiftKey.value
                    onClicked: textInput.text += text;

                }
            }
            Key {
                width: keySize * 1.5 + 2
                height: keySize
                isCap: true
                value: "DONE"
                onClicked: {
                    textInput.cursorVisible = false;
                    textInput = null;
                }
                textColor: "white"
                color: "gray"
            }
        }
        Flow {
            spacing: 5
            width: (keySize + 5) * row1Repeater.model.count
            height: keySize
            Repeater {
                model: ["@", "^"]
                delegate: Key {
                    width: keySize
                    value: modelData
                    onClicked: textInput.text += text;
                }
            }
            Key {
                width: (keySize + 5) * 9 - 5
                height: keySize
                isCap: true
                value: "SPACE"
                onClicked: textInput.text += " ";
            }
            Repeater {
                model: ["*", "?"]
                delegate: Key {
                    width: keySize
                    value: modelData
                    onClicked: textInput.text += text;
                }
            }
        }
    }
    StateGroup {
        states: [
            State {
                name: "inactive"
                when: textInput == null
                PropertyChanges { target: root; visible: false }
            },
            State {
                name: "active"
                when: textInput != null
                PropertyChanges { target: root; visible: true }
            }
        ]
    }
}
