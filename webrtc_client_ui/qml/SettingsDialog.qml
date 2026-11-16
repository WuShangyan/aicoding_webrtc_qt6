pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
    id: dialog
    objectName: "settingsDialog"
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: Math.min(580, parent.width - 40)
    height: Math.min(604, parent.height - 32)
    title: "设置"
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape
    padding: 0

    property url settingsLocation

    Settings {
        id: store
        category: "ConnectionSettings"
        location: dialog.settingsLocation
    }

    onAboutToShow: {
        serverAddress.text = store.value("serverAddress", "xrtc://www.str2num.com:9081")
        camera.currentIndex = Math.max(0, camera.find(store.value("camera", "无")))
        microphone.currentIndex = Math.max(0, microphone.find(store.value("microphone", "无")))
        uid.text = store.value("uid", "8888")
        publishName.text = store.value("publishName", "ai100")
        subscribeName.text = store.value("subscribeName", "ai100")
        form.contentY = 0
    }

    onAccepted: {
        store.setValue("serverAddress", serverAddress.text)
        store.setValue("camera", camera.currentText)
        store.setValue("microphone", microphone.currentText)
        store.setValue("uid", uid.text)
        store.setValue("publishName", publishName.text)
        store.setValue("subscribeName", subscribeName.text)
        store.sync()
    }

    function reveal(field) {
        const top = field.mapToItem(form.contentItem, 0, 0).y
        if (top - 24 < form.contentY)
            form.contentY = Math.max(0, top - 24)
        else if (top + field.height + 12 > form.contentY + form.height)
            form.contentY = Math.min(Math.max(0, form.contentHeight - form.height),
                                     top + field.height + 12 - form.height)
    }

    component FieldBorder: Rectangle {
        required property bool highlighted
        radius: 6
        color: "#ffffff"
        border.color: highlighted ? "#2377de" : "#d5d9df"
    }

    component FieldLabel: Label {
        color: "#303641"
        font.pixelSize: 14
    }

    component SettingText: TextField {
        id: field
        Layout.fillWidth: true
        implicitHeight: 40
        font.pixelSize: 15
        color: "#232932"
        selectByMouse: true
        background: FieldBorder { highlighted: field.activeFocus }
        onActiveFocusChanged: {
            if (activeFocus && dialog.opened)
                dialog.reveal(field)
        }
    }

    component DevicePicker: ComboBox {
        id: picker
        Layout.fillWidth: true
        implicitHeight: 40
        model: ["无"]
        font.pixelSize: 15
        background: FieldBorder { highlighted: picker.activeFocus || picker.down }
        onActiveFocusChanged: {
            if (activeFocus && dialog.opened)
                dialog.reveal(picker)
        }
    }

    component FooterButton: Button {
        id: button
        property bool primary: false
        implicitWidth: 102
        implicitHeight: 40
        font.pixelSize: 14
        palette.buttonText: primary ? "#ffffff" : "#303641"
        background: Rectangle {
            radius: 6
            color: button.primary ? (button.down ? "#0657bf" : button.hovered ? "#0965dc" : "#0872ed")
                                  : (button.down || button.hovered ? "#f2f5f9" : "#ffffff")
            border.color: button.visualFocus ? "#174d97" : button.primary ? "transparent" : "#d5d9df"
            border.width: button.visualFocus ? 2 : 1
        }
    }

    background: Rectangle {
        color: "#ffffff"
        radius: 10
    }

    Overlay.modal: Rectangle { color: "#660c1626" }

    header: Item {
        implicitHeight: 56

        Label {
            anchors.centerIn: parent
            text: dialog.title
            color: "#232932"
            font.pixelSize: 18
            font.weight: Font.DemiBold
        }

        Button {
            id: closeButton
            objectName: "settingsClose"
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            width: 36
            height: 36
            text: "×"
            font.pixelSize: 21
            Accessible.name: "关闭设置"
            onClicked: dialog.reject()
            background: Rectangle {
                radius: 6
                color: closeButton.hovered ? "#f2f5f9" : "transparent"
                border.color: closeButton.visualFocus ? "#2377de" : "transparent"
            }
        }
    }

    contentItem: Flickable {
        id: form
        objectName: "settingsForm"
        clip: true
        contentWidth: width
        contentHeight: fields.implicitHeight + 24
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar { }

        ColumnLayout {
            id: fields
            x: 32
            y: 8
            width: form.width - 64
            spacing: 14

            ColumnLayout {
                spacing: 6
                FieldLabel { text: "XRTC 服务地址" }
                SettingText {
                    id: serverAddress
                    objectName: "settingsServerAddress"
                    Accessible.name: "XRTC 服务地址"
                    inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase
                }
            }

            ColumnLayout {
                spacing: 6
                FieldLabel { text: "摄像头" }
                DevicePicker {
                    id: camera
                    objectName: "settingsCamera"
                    Accessible.name: "摄像头"
                }
            }

            ColumnLayout {
                spacing: 6
                FieldLabel { text: "麦克风" }
                DevicePicker {
                    id: microphone
                    objectName: "settingsMicrophone"
                    Accessible.name: "麦克风"
                }
            }

            ColumnLayout {
                spacing: 6
                FieldLabel { text: "用户 UID" }
                SettingText {
                    id: uid
                    objectName: "settingsUid"
                    Accessible.name: "用户 UID"
                }
            }

            ColumnLayout {
                spacing: 6
                FieldLabel { text: "推流名称" }
                SettingText {
                    id: publishName
                    objectName: "settingsPublishName"
                    Accessible.name: "推流名称"
                }
            }

            ColumnLayout {
                spacing: 6
                FieldLabel { text: "拉流名称" }
                SettingText {
                    id: subscribeName
                    objectName: "settingsSubscribeName"
                    Accessible.name: "拉流名称"
                }
            }
        }
    }

    footer: Item {
        implicitHeight: 68

        Rectangle {
            width: parent.width
            height: 1
            color: "#edf0f3"
        }

        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            FooterButton {
                objectName: "settingsCancel"
                text: "取消"
                onClicked: dialog.reject()
            }

            FooterButton {
                objectName: "settingsSave"
                text: "保存"
                primary: true
                onClicked: dialog.accept()
            }
        }
    }
}
