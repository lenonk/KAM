import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

Rectangle {
    id: storRect
    
    implicitWidth: (parent.width * 0.33) - netRect.anchors.rightMargin / 2
    height: 150
    color: Kirigami.Theme.backgroundColor
    border.color: Kirigami.Theme.alternateBackgroundColor
    border.width: 1
    radius: 3
    antialiasing: true
    clip: true
    
    Text {
        id: storTxt
        font.bold: true
        font.pointSize: 14
        color: Kirigami.Theme.textColor
        anchors {
            top: parent.top;
            left: parent.left;
            topMargin: 10
            leftMargin: 10
        }
        text: qsTr("Storage")
    }
    
    Component {
        id: storDelegate
        KAMDriveBar {
            driveName: name
            driveCapacity: capacity
            driveUsed: used
        }
    }
    
    ListView {
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 35
            leftMargin: 10
        }
        width: parent.width
        height: parent.height
        clip: true
        
        model: StorageModel {
        }

        delegate: storDelegate
    }
}
