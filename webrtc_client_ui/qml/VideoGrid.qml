import QtQuick
import QtQuick.Layouts

GridLayout {
    objectName: "videoGrid"
    columns: 3
    rows: 3
    rowSpacing: 12
    columnSpacing: 12
    Repeater {
        model: 9
        VideoTile {
            required property int index
            channelNumber: index + 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 320
            Layout.preferredHeight: 180
            Layout.minimumWidth: 0
            Layout.minimumHeight: 0
        }
    }
}
