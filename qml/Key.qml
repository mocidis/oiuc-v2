import QtQuick 1.0
PushButton {
    property alias text: label.text
    property alias textColor: label.color
    property string value: ""
//    property alias textSize: label.font.pixelSize
    property bool isCap: false
    height: width
    id: root
    Text {
        id: label
        anchors.centerIn: parent
        color: "gray"
        font {
            pixelSize: 20
        }
    }
    border {
        width: 2
        color: "lightgray"
    }
    StateGroup {
        states: [
            State {
                name: "lowerCase"
                when: !root.isCap
                PropertyChanges { target: label; text: value.toLowerCase() }
            },
            State {
                name: "upperCase"
                when: root.isCap
                PropertyChanges { target: label; text: value.toUpperCase() }
            }
        ]
    }
}

