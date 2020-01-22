import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

Rectangle {
    id: cpuRect
    anchors {
    }
    
    height: 200
    implicitWidth: (parent.width / 2) - anchors.rightMargin
    color: Kirigami.Theme.backgroundColor
    border.color: Kirigami.Theme.alternateBackgroundColor
    border.width: 1
    radius: 3
    antialiasing: true
    Text {
        id: cpuText
        text: qsTr("CPU")
        font.bold: true
        font.pointSize: 14
        color: Kirigami.Theme.textColor
        anchors { top: parent.top; left: parent.left; margins: 10 }
    }
    KAMRadialBar {
        id: cpuRadialBar
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            margins: 10
        }
    }
    Text {
        id: loadText
        text: qsTr("Minimal Load")
        color: Kirigami.Theme.textColor
        anchors { bottom: parent.bottom; left: parent.left; margins: 10 }
    }
    KAMProgressBar {
        id: cpuTempProgress
        value: 0.2
        anchors {
            top: parent.top
            left: cpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: (parent.height * 0.33) - height
        }
        
        leftText: qsTr("Temperature")
        rightText: qsTr("38C")
    }
    KAMProgressBar {
        id: cpuClockProgress
        value: 0.9
        anchors {
            top: cpuTempProgress.bottom
            left: cpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: 30
        }
        
        leftText: qsTr("Clock")
        rightText: qsTr("4250 MHz")
    }
    KAMProgressBar {
        id: cpuFanProgress
        value: 0.6
        anchors {
            top: cpuClockProgress.bottom
            left: cpuRadialBar.right
            right: parent.right
            leftMargin: 15
            rightMargin: 10
            topMargin: 30
        }
        
        leftText: qsTr("Fan")
        rightText: qsTr("2051 RPM")
    }
}
