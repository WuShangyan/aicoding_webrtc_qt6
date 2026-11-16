import QtQuick
import QtQuick.Controls

Button {
    id: control
    required property string iconName
    property bool primary: false

    implicitWidth: Math.max(96, implicitContentWidth + leftPadding + rightPadding + 4)
    implicitHeight: 58
    display: AbstractButton.TextUnderIcon
    spacing: 5
    font.pixelSize: 12
    palette.buttonText: primary ? "#14805d" : "#282d35"
    icon.source: "../icons/" + iconName + ".svg"
    icon.width: 22
    icon.height: 22
    icon.color: palette.buttonText
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.name: text
    ToolTip.visible: hovered
    ToolTip.delay: 450
    ToolTip.text: text + "（功能尚未接入）"

    background: Rectangle {
        radius: 7
        color: control.down ? "#dce9fb"
                            : control.hovered ? "#e8eff9"
                                              : "transparent"
        border.color: control.visualFocus ? "#256bd1" : "transparent"
        border.width: control.visualFocus ? 2 : 0
    }
}
