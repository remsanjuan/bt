import QtQuick 2.0

Item {
    id: id_root
    property int value: 0
    property int granularity: 300

    Rectangle {
        width: 3
        height: id_root.height * 0.4
        color: "red"
        anchors {
            horizontalCenter: id_root.horizontalCenter
            bottom: id_root.verticalCenter
        }
        antialiasing: true
    }

    rotation: (360/granularity * (value % granularity)) + 180
    antialiasing: true
}

