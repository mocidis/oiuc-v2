import QtQuick 2.3
ToggleButton {
    property alias text: label.text
//    property alias textSize: label.font.pixelSize
    height: width
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
}

