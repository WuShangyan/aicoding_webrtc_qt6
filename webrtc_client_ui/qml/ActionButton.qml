import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: control
    required property string iconName
    property bool primary: false
    implicitHeight: 42
    implicitWidth: contentItem.implicitWidth + 24
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.name: text
    ToolTip.visible: hovered
    ToolTip.delay: 450
    ToolTip.text: text + "（功能尚未接入）"
    background: Rectangle {
        radius: 7
        color: control.down ? "#344d70" : control.hovered ? "#2b3b51" : control.primary ? "#274572" : "#222d3c"
        border.color: control.visualFocus ? "#91bcff" : control.primary ? "#4b7aba" : "#354356"
        border.width: control.visualFocus ? 2 : 1
    }
    contentItem: RowLayout {
        spacing: 7
        Image {
            source: "../icons/" + control.iconName + ".svg"
            sourceSize.width: 18
            sourceSize.height: 18
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18
        }
        Label { text: control.text; color: "#e3ecf9"; font.pixelSize: 12 }
    }
}
