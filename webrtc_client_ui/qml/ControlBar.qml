import QtQuick
import QtQuick.Layouts

Rectangle {
    id: bar
    objectName: "controlBar"
    signal actionRequested(string action)
    implicitHeight: 88
    color: "#ffffff"

    Rectangle {
        width: parent.width
        height: 1
        color: "#e1e4e9"
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 14

        ActionButton {
            objectName: "devicesButton"
            text: "启动设备"
            iconName: "devices"
            onClicked: bar.actionRequested(text)
        }
        ActionButton {
            objectName: "previewButton"
            text: "本地预览"
            iconName: "preview"
            onClicked: bar.actionRequested(text)
        }
        ActionButton {
            objectName: "publishButton"
            text: "开始推流"
            iconName: "upload"
            primary: true
            onClicked: bar.actionRequested(text)
        }
        ActionButton {
            objectName: "subscribeButton"
            text: "开始拉流"
            iconName: "download"
            onClicked: bar.actionRequested(text)
        }
    }
}
