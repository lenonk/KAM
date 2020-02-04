import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

Item {
    id: control
    property string driveName
    property int driveCapacity
    property int driveUsed
    
    height: 50
    width: parent.width
    Text {
        font.weight: Font.Light
        font.pointSize: 16
        color: Kirigami.Theme.textColor
        
        text: driveName
        width: parent.width
        Rectangle {
            anchors {
                left: parent.left
                top: parent.bottom
                rightMargin: 10
            }
            
            height: 20
            width: parent.width - anchors.rightMargin * 2
            color: Kirigami.Theme.alternateBackgroundColor
            
            Rectangle {
                anchors {
                    left: parent.left
                    top: parent.top
                }
                
                height: parent.height
                width: parent.width * driveUsed / driveCapacity
                color: Kirigami.Theme.highlightColor
                
            }
            Text {
                font.bold: true
                font.pointSize: 11
                color: Kirigami.Theme.textColor
                anchors.centerIn: parent
                text: getStorageString(control.driveUsed, control.driveCapacity)
            }
        }
    }
    
    function getStorageString(used, capacity) {
        if (capacity > 1000) {
            return (used / 1000) + " / " + (capacity / 1000) + "TB";
        }
        else {
            return used + " / " + capacity + "GB";
        }
        
        return "";
    }
}
