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
    title: unifiedTitleBar ? "" : "webrtc_client"
    flags: unifiedTitleBar ? Qt.Window | Qt.ExpandedClientAreaHint | Qt.NoTitleBarBackgroundHint
                           : Qt.Window
    color: "#ffffff"
    font.family: Qt.platform.os === "osx" ? "PingFang SC" : "sans-serif"
    font.pixelSize: 13

    readonly property bool unifiedTitleBar: (Qt.platform.os === "osx" || Qt.platform.os === "windows")
                                            && typeof Qt.NoTitleBarBackgroundHint !== "undefined"

    Component.onCompleted: {
        if (unifiedTitleBar) {
            // Place the application bar beside the native window controls.
            window.topPadding = 0
        }
    }

    property url settingsLocation

    readonly property var layoutSizes: [2, 4, 9, 16]

    function notify(action) {
        notice.text = action + "尚未接入，当前仅展示 UI"
        toast.open()
        toastTimer.restart()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: header
            objectName: "roomHeader"
            Layout.fillWidth: true
            implicitHeight: 56
            color: "#ffffff"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: window.unifiedTitleBar && Qt.platform.os === "osx" ? 90 : 18
                anchors.rightMargin: window.unifiedTitleBar && Qt.platform.os === "windows" ? 164 : 16
                spacing: 10

                Rectangle {
                    implicitWidth: 34
                    implicitHeight: 34
                    radius: 8
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#2499df" }
                        GradientStop { position: 1; color: "#139d9a" }
                    }

                    Image {
                        anchors.centerIn: parent
                        width: 22
                        height: 22
                        source: "../icons/video.svg"
                    }
                }

                Label {
                    text: "AICoding-WebRTC 推拉流"
                    color: "#343b46"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }

                Item {
                    objectName: "titleDragArea"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    DragHandler {
                        enabled: window.unifiedTitleBar
                        target: null
                        onActiveChanged: {
                            if (active)
                                window.startSystemMove()
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: window.unifiedTitleBar
                        onDoubleClicked: {
                            if (window.visibility === Window.Maximized)
                                window.showNormal()
                            else
                                window.showMaximized()
                        }
                    }
                }

                ComboBox {
                    id: layoutPicker
                    objectName: "layoutPicker"
                    Layout.preferredWidth: 114
                    Layout.preferredHeight: 36
                    model: window.layoutSizes.map(size => size + "宫格")
                    currentIndex: 2
                    font.pixelSize: 13
                    Accessible.name: "视频布局：" + currentText
                    background: Rectangle {
                        radius: 6
                        color: layoutPicker.down || layoutPicker.hovered ? "#edf1f5" : "#f6f7f9"
                        border.color: layoutPicker.visualFocus ? "#256bd1" : "transparent"
                    }
                }

                ActionButton {
                    objectName: "speakerButton"
                    text: "开启扬声器"
                    iconName: "speaker"
                    display: AbstractButton.IconOnly
                    implicitWidth: 38
                    implicitHeight: 36
                    icon.width: 18
                    icon.height: 18
                    onClicked: window.notify(text)
                }

                ActionButton {
                    objectName: "settingsButton"
                    text: "设置"
                    iconName: "settings"
                    display: AbstractButton.TextBesideIcon
                    implicitWidth: 74
                    implicitHeight: 36
                    icon.width: 18
                    icon.height: 18
                    ToolTip.text: "打开设置"
                    onClicked: settingsDialog.open()
                }
            }
        }

        VideoGrid {
            objectName: "videoStage"
            Layout.fillWidth: true
            Layout.fillHeight: true
            tileCount: window.layoutSizes[layoutPicker.currentIndex]
        }

        ControlBar {
            id: controlBar
            Layout.fillWidth: true
            onActionRequested: function(action) { window.notify(action) }
        }
    }

    SettingsDialog {
        id: settingsDialog
        settingsLocation: window.settingsLocation
    }

    Popup {
        id: toast
        objectName: "placeholderToast"
        parent: Overlay.overlay
        x: Math.round((window.width - width) / 2)
        y: controlBar.y - height - 12
        padding: 14
        closePolicy: Popup.NoAutoClose
        background: Rectangle {
            color: "#30343c"
            radius: 8
            border.color: "#525863"
        }
        contentItem: Label {
            id: notice
            color: "#ffffff"
            font.pixelSize: 13
        }
    }

    Timer {
        id: toastTimer
        interval: 2600
        onTriggered: toast.close()
    }
}
