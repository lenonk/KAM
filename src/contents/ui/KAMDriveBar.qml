import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Layouts 1.4
import org.kde.kirigami 2.4 as Kirigami
import QtQuick.Controls 2.13 as Controls
import QtQuick.Controls 1.4

Text {
    id: control
    property string driveName: "/"
    property int capacity: 500
    property int used: 250
    
    font.weight: Font.Light
    font.pointSize: 18
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
            width: parent.width * used / capacity
            color: Kirigami.Theme.highlightColor
            
        }
        Text {
            font.bold: true
            font.pointSize: 11
            color: Kirigami.Theme.textColor
            anchors.centerIn: parent
            text: control.used + " / " + control.capacity + "GB"
        }
    }
}
