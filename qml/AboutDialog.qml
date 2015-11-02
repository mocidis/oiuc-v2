import QtQuick 1.0

DialogCommon {
    id: root
    height: homeForm.height + copyright.height + 100
    captionText: "About"
    Item {
        anchors {
            fill: parent
            topMargin: 30
        }
        Flow {
            id: homeForm
            flow: Flow.TopToBottom
            anchors {
                top:parent.top
                left:parent.left
                right:parent.right
                margins: 10
            }
            spacing: 10
            Text {
                font.pixelSize: 30
                font.bold: true
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "Welcome to iCS-M"
            }
            LabelCommon {
                font.italic: true
                align: Text.AlignHCenter
                text: "Intergrated Communication System"
            }
            Item {
                width: parent.width
                height: childrenRect.height
                Image {
                    id: logo
                    source: "../static/iCS-M-medium.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    anchors {
                        top: logo.bottom
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 10
                    }
                    font {
                        pixelSize: 12
                        italic: true
                    }
                    color: "navy"
                    text: "version 1.0"
                }
            }
        }
        LabelCommon {
            id: copyright
            anchors {
                left: parent.left
                right: parent.right
                top: homeForm.bottom
                margins: 10
                topMargin: 20
            }
            font.italic: true
            font.pixelSize: 12
            align: Text.AlignHCenter
            text: "Copyright © 2015–2020 Dicom Technology Co., Ltd.\nAll rights reserved."
            textColor: "darkgray"
            textAbove: false
        }
    }
}
