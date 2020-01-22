import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

Rectangle {
    id: gpuRect
    anchors {
    }
    
    height: 200
    implicitWidth: (parent.width / 2) - anchors.leftMargin
    color: Kirigami.Theme.backgroundColor
    border.color: Kirigami.Theme.alternateBackgroundColor
    border.width: 1
    radius: 3
    antialiasing: true
    Text {
        id: gpuText
        text: qsTr("GPU")
        font.bold: true
        font.pointSize: 14
        color: Kirigami.Theme.textColor
        anchors { top: parent.top; left: parent.left; margins: 10 }
    }
    KAMRadialBar {
        id: gpuRadialBar
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            margins: 10
        }

        value: 2
    }
    Text {
        id: loadText
        text: qsTr("obs64")
        color: Kirigami.Theme.textColor
        anchors { bottom: parent.bottom; left: parent.left; margins: 10 }
    }
    KAMProgressBar {
        id: gpuTempProgress
        value: 0.2
        anchors {
            top: parent.top
            left: gpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: (parent.height * 0.33) - height
        }
        
        leftText: qsTr("Temperature")
        rightText: qsTr("45C")
    }
    KAMProgressBar {
        id: gpuClockProgress
        value: 0.9
        anchors {
            top: gpuTempProgress.bottom
            left: gpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: 30
        }
        
        leftText: qsTr("Clock")
        rightText: qsTr("2100 MHz")
    }
    KAMProgressBar {
        id: gpuFanProgress
        value: 0.6
        anchors {
            top: gpuClockProgress.bottom
            left: gpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: 30
        }
        
        leftText: qsTr("Fan")
        rightText: qsTr("1458 RPM")
    }
}
