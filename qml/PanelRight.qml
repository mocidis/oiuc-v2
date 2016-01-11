@QtQuick
PanelCommon {
	id: root
	color: "lightgrey"
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
            //color: (index % 2 == 0) ? "white":"#F0F0F0"
			color: "transparent"
			Text {
                anchors {
                    left: parent.left
                    leftMargin: 5
                    verticalCenter: parent.verticalCenter
                }
				width: root.width
				text: log
				elide: Text.ElideRight
				font.family: appFont.name
				font.pixelSize: 16
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

