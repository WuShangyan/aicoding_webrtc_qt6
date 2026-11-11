import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    objectName: "mainWindow"
    width: 1440
    height: 900
    minimumWidth: 960
    minimumHeight: 640
    visible: true
    title: "webrtc_client"
    color: "#101318"
    font.family: Qt.platform.os === "osx" ? "PingFang SC" : "sans-serif"
    font.pixelSize: 13

    function notify(action) {
        notice.text = action + "尚未接入，当前仅展示 UI"
        toast.open()
        toastTimer.restart()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 24
            Layout.rightMargin: 24
            Layout.preferredHeight: 62
            spacing: 12
            Rectangle {
                width: 4; height: 22; radius: 2; color: "#609bff"
            }
            Label {
                text: "webrtc_client"
                color: "#edf2fa"
                font.pixelSize: 19
                font.weight: Font.DemiBold
            }
            Label { text: "实时音视频工作台"; color: "#8492a6" }
            Item { Layout.fillWidth: true }
            Rectangle {
                implicitWidth: modeLabel.implicitWidth + 22
                implicitHeight: 26
                radius: 13
                color: "#202a38"
                Label {
                    id: modeLabel
                    anchors.centerIn: parent
                    text: "UI 预览版"
                    color: "#a7c8ff"
                    font.pixelSize: 11
                }
            }
        }
        VideoGrid {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.bottomMargin: 20
        }
        ControlBar {
            Layout.fillWidth: true
            onActionRequested: function(action) { window.notify(action) }
        }
    }

    Popup {
        id: toast
        objectName: "placeholderToast"
        parent: Overlay.overlay
        x: Math.round((window.width - width) / 2)
        y: window.height - 166
        padding: 16
        closePolicy: Popup.NoAutoClose
        background: Rectangle {
            color: "#26364a"
            radius: 9
            border.color: "#4b6b94"
        }
        contentItem: Label { id: notice; color: "#eef5ff"; font.pixelSize: 13 }
    }
    Timer { id: toastTimer; interval: 2600; onTriggered: toast.close() }
}
