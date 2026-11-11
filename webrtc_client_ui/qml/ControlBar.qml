import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: bar
    signal actionRequested(string action)
    implicitHeight: 108
    color: "#181e27"
    Rectangle { width: parent.width; height: 1; color: "#2b3543" }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 12
        ColumnLayout {
            spacing: 8
            Label { text: "音视频设备"; color: "#8492a6"; font.pixelSize: 10 }
            RowLayout {
                spacing: 8
                ActionButton { objectName: "devicesButton"; text: "启动音视频设备"; iconName: "devices"; onClicked: bar.actionRequested(text) }
                ActionButton { objectName: "speakerButton"; text: "开启扬声器"; iconName: "speaker"; onClicked: bar.actionRequested(text) }
            }
        }
        Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 42; color: "#303b4b" }
        ColumnLayout {
            spacing: 8
            Label { text: "本地预览"; color: "#8492a6"; font.pixelSize: 10 }
            ActionButton { objectName: "previewButton"; text: "预览摄像头"; iconName: "preview"; onClicked: bar.actionRequested(text) }
        }
        Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 42; color: "#303b4b" }
        ColumnLayout {
            spacing: 8
            Label { text: "流控制"; color: "#8492a6"; font.pixelSize: 10 }
            RowLayout {
                spacing: 8
                ActionButton { objectName: "publishButton"; text: "开始推流"; iconName: "upload"; primary: true; onClicked: bar.actionRequested(text) }
                ActionButton { objectName: "subscribeButton"; text: "开始拉流"; iconName: "download"; onClicked: bar.actionRequested(text) }
            }
        }
        Item { Layout.fillWidth: true }
        ColumnLayout {
            spacing: 8
            Label { text: "配置"; color: "#8492a6"; font.pixelSize: 10 }
            ActionButton { objectName: "settingsButton"; text: "设置"; iconName: "settings"; onClicked: bar.actionRequested(text) }
        }
    }
}
