import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    Rectangle {
        id: coolingPage
        color: PlasmaCore.Theme.headerBackgroundColor
        anchors.fill: parent

        Label {
            text: qsTr("Cooling Page")
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
        }
    }
}
