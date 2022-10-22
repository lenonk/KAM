import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import org.kde.plasma.core 2.0 as PlasmaCore

Button {
    id: btnLeftMenu
    text: qsTr("Left Menu Text")
    icon.color: "#ffffff"

    property url btnIconSource: "../images/svg_images/home_icon.svg"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272e"
    property color btnColorClicked: "#00a1f1"
    property int iconWidth: 18
    property int iconHeight: 18
    property color activeMenuColor: "#55aaff"
    property bool isActiveMenu: false

    QtObject {
       id: internal

       property var dynamicColor: if (btnLeftMenu.down) {
                                      btnLeftMenu.down ? btnColorClicked : btnColorDefault
                                  }
                                  else {
                                      btnLeftMenu.hovered ? btnColorMouseOver : btnColorDefault
                                  }
    }

    implicitWidth: 250
    implicitHeight: 40

    background: Rectangle {
        id: bgBtn
        color: internal.dynamicColor
        radius: 5

        Rectangle {
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            color: activeMenuColor
            width: 3
            visible: isActiveMenu
        }
    }

    contentItem: Item {
        anchors.fill: parent
    }

    Image {
        id: iconBtn
        source: btnIconSource
        anchors.leftMargin: 26
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        sourceSize.height: iconHeight
        sourceSize.width: iconWidth
        height: iconHeight
        width: iconWidth
        fillMode: Image.PreserveAspectFit
        visible: false
        antialiasing: true
    }

    ColorOverlay {
        source: iconBtn
        anchors.fill: iconBtn
        color: PlasmaCore.Theme.buttonTextColor
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: false
        width: iconWidth
        height: iconHeight
    }

    Text {
        color: PlasmaCore.Theme.buttonTextColor
        text: btnLeftMenu.text
        font: btnLeftMenu.font
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 75
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:60;width:250}
}
##^##*/
