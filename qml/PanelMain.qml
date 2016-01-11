@QtQuick
@QtWindow

PanelCommon {
    width: Screen.width
    clip: true
    Flickable {
        id: flickable
        anchors { fill: parent }
        Flow {
            anchors { 
                fill: parent
                margins: 20
            }
            spacing: 30
            Repeater {
                id: repeater
                model: _ROOT.radios
                delegate: RadioView {
                    btnSize: 80
                    oModelItem: _ROOT.radios.get(index)
                }
            }
            Repeater {
                id: repeater_oiu
                model: _ROOT.oius
                delegate: OIUView {
                    btnSize: 80
                    oModelItem: _ROOT.oius.get(index)
                }
            }
        }
        contentHeight: 160 * (repeater.count + repeater_oiu.count + 1) / 2
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
