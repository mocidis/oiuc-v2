import QtQuick 1.0
PanelCommon {
	id: root
    /*ListModel {
        id: logModel
        ListElement {
            log: "Message 1"
        }
        ListElement {
            log: "Message 2"
        }
        ListElement {
            log: "Message 3"
        }
    }*/
	ListView {
		id: listview
		anchors {
			top: parent.top
			left: parent.left
			right: parent.right
			bottom: parent.bottom
		}
		model: logModel
		delegate: Rectangle {
            width: parent.width
            height: 30
            color: (index % 2 == 0) ? "white":"#F0F0F0"
			Text {
                anchors {
                    left: parent.left
                    leftMargin: 5
                    verticalCenter: parent.verticalCenter
                }
				width: root.width
				text: log
				elide: Text.ElideRight
			}
		}
		clip: true
	}
	ScrollBar {
		scrollArea: listview
		anchors { 
            right: listview.right
            bottom: listview.bottom
            top: listview.top
        }
	}
}

