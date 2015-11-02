import QtQuick 1.0
ToggleButton {
    property variant oItem: null
    property string sourcePrefix: "../static/Speaker"
    property alias iconOpacity: icon.opacity
    id: root
    onColor: "navy"
    color: "transparent"
    Image {
        id: icon
        anchors { centerIn: parent }
        smooth: true
        width: 20
        height: 20
        fillMode: Image.PreserveAspectFit
        source: parent.sourcePrefix + ((parent.oItem.volume > 0)?"-fill":"-mute-fill") + (parent.value?"-white-small.svg":"-black-small.svg")
    }
}
