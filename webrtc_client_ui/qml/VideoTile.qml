import QtQuick
import QtQuick.Controls

Rectangle {
    id: tile
    required property int channelNumber
    required property bool alternate
    objectName: "videoTile" + channelNumber
    color: alternate ? "#626e7d" : "#7b8593"
    clip: true

    Rectangle {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: Math.max(94, channel.implicitWidth + 24)
        height: 27
        color: "#15191f"

        Label {
            id: channel
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: tile.channelNumber === 1 ? "摄像头" : "远程视频"
            color: "#ffffff"
            font.pixelSize: 13
        }
    }
}
