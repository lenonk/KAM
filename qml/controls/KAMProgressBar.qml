import QtQuick 2.13
import QtQuick.Templates 2.12 as T

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as KDE

T.ProgressBar {
    id: control
    property string leftText: ""
    property string rightText: ""

    height: 10

    KDE.ProgressBar {
        id: pgBar
        value: parent.value
        width: parent.width
        height: parent.height

        Text {
            anchors.top: parent.bottom
            anchors.left: parent.left
            color: PlasmaCore.Theme.textColor
            text: qsTr(leftText)
        }

        Text {
            anchors.top: parent.bottom
            anchors.right: parent.right
            color: PlasmaCore.Theme.textColor
            text: qsTr(rightText)
        }
    }
}
