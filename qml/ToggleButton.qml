import QtQuick 1.0

Rectangle {
    signal clicked(variant mouse)
    signal longClicked()
    signal selected()
    signal deselected()
    property color onColor: "lightgray"
    property bool value: false
    property alias clickable: mouseArea.enabled
    id: root
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            parent.value = !parent.value;
            parent.clicked(mouse);
            if(parent.value) parent.selected();
            else parent.deselected();
        }
        onPressAndHold: {
            parent.longClicked();
        }
    }
    StateGroup {
        state: "OFF"

        states: [
            State {
                name: "OFF"
                when: value == false
            },
            State {
                name: "ON"
                when: value == true
                PropertyChanges {target: root; color: onColor}
            }
        ]
/*
        transitions: [
            Transition {
                from: "ON"
                to: "OFF"
                ColorAnimation {duration: 200}
            },
            Transition {
                from: "OFF"
                to: "ON"
                ColorAnimation {duration: 200}
            }
        ]
*/
    }
}
