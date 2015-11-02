import QtQuick 1.0

PanelCommon {
    width: 660
    clip: true
    Flickable {
        id: flickable
        anchors { fill: parent }
        Flow {
            anchors { 
                fill: parent
                margins: 20
            }
            spacing: 10
            Repeater {
                id: repeater
                model: _ROOT.radios
                delegate: RadioView {
                    btnSize: 80
                    oModelItem: _ROOT.radios.get(index)
                }
            }
        }
        contentHeight: 160 * (repeater.count + 1) / 2
    }
    ScrollBar {
        scrollArea: flickable
		anchors { 
            right: flickable.right
            bottom: flickable.bottom
            top: flickable.top
        }
    }
}
