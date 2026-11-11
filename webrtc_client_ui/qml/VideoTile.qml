import QtQuick
import QtQuick.Controls

Rectangle {
    id: tile
    required property int channelNumber
    objectName: "videoTile" + channelNumber
    color: "#1a2029"
    radius: 10
    border.color: "#2b3543"
    clip: true

    Item {
        anchors.fill: parent
        anchors.margins: 10
        Rectangle {
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height * 16 / 9)
            height: width * 9 / 16
            color: "#141a22"
            radius: 5
            Column {
                anchors.centerIn: parent
                spacing: 8
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "../icons/video.svg"
                    width: 30; height: 30
                    opacity: 0.38
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "暂无视频"
                    color: "#728198"
                    font.pixelSize: 12
                }
            }
        }
    }
    Label {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 14
        text: "视频通道 " + String(tile.channelNumber).padStart(2, "0")
        color: "#bac6d6"
        font.pixelSize: 12
    }
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 13
        spacing: 6
        Rectangle { width: 5; height: 5; radius: 3; color: "#667386"; anchors.verticalCenter: parent.verticalCenter }
        Label { text: "未连接"; color: "#7d8a9d"; font.pixelSize: 10 }
    }
}
