import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.core 2.0 as PlasmaCore
import CustomControls 1.0
import QtGraphicalEffects 1.0

import "../../../controls"

Rectangle {
    id: rectBackground
    anchors.fill: parent
    color: PlasmaCore.Theme.headerBackgroundColor

    GpuTopbar {
        id: rectTopbar

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        color: PlasmaCore.Theme.headerBackgroundColor
        height: 40
    }

    Rectangle {
        id: rectSeperator

        anchors {
            top: rectTopbar.bottom
            left: rectTopbar.left
            right: rectTopbar.right
            leftMargin: 10
        }

        height: 1
        color: PlasmaCore.Theme.highlightColor
    }

    GpuInfoPanel {
        id: rectTop

        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
            top: rectSeperator.bottom
            topMargin: 10
        }

        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        color: PlasmaCore.Theme.headerBackgroundColor
        height: 70
        radius: 5
    }

    GpuLoadPanel {
        id: rectLoad

        anchors {
            top: rectTop.bottom
            left: rectTop.left
            topMargin: 10
        }

        width: rectTop.width / 2 - 5 // Minus 5 for margins
        height: (rectBackground.height - rectTopbar.height - rectTop.height - 30) / 2 // -30 for margins

        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        color: PlasmaCore.Theme.headerBackgroundColor
        radius: 5
    }

    GpuTempPanel {
        id: rectTemp

        anchors {
            top: rectTop.bottom
            left: rectLoad.right
            right: rectTop.right
            topMargin: 10
            leftMargin: 10
        }

        height: (rectBackground.height - rectTopbar.height - rectTop.height - 30) / 2 // -30 for margins

        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        color: PlasmaCore.Theme.headerBackgroundColor
        radius: 5
    }

    GpuClockSpeedPanel {
        id: rectClockSpeed

        anchors {
            top: rectLoad.bottom
            bottom: rectBackground.bottom
            left: rectTop.left
            topMargin: 10
        }

        width: rectTop.width / 2 - 5

        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        color: PlasmaCore.Theme.headerBackgroundColor
        radius: 5
    }

    GpuFanSpeedPanel {
        id: rectFanSpeed

        anchors {
            top: rectTemp.bottom
            bottom: rectBackground.bottom
            left: rectClockSpeed.right
            right: rectTop.right
            topMargin: 10
            leftMargin: 10
        }

        border.color: PlasmaCore.Theme.highlightColor
        border.width: 1
        color: PlasmaCore.Theme.headerBackgroundColor
        radius: 5
    }
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:580;width:830}
}
##^##*/
