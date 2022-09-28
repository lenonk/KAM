import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import Qt.labs.platform 1.1 as Labs

import "controls"
import org.kde.plasma.core 2.0 as PlasmaCore

Window {
    id: mainWindow
    width: 850
    height: 600
    visible: true
    minimumWidth: 850
    minimumHeight: 600
    color: "#00000000"

    flags: Qt.Window | Qt.FramelessWindowHint

    property int windowStatus: 0
    property int windowMargin: 10
    property int isMinimized: 3

    QtObject {
        id: internal

        function resetResizeBorders(value) {
            resizeLeft.visible = value
            resizeRight.visible = value
            resizeBottom.visible = value
            resizeWindow.visible = value
        }

        function resetNormalWindow() {
            windowStatus = 0
            windowMargin = 10
            resetResizeBorders(true)
            btnMaximizeRestore.btnIconSource = "images/svg_icons/maximize_icon.svg"
        }

        function maximizeRestore() {
            if (windowStatus == 0) {
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                resetResizeBorders(false)
                btnMaximizeRestore.btnIconSource = "images/svg_icons/restore_icon.svg"
            }
            else {
                mainWindow.showNormal()
                resetNormalWindow()
            }
        }

        function ifMaximizedWindowRestore() {
            if (windowStatus == 1) {
                mainWindow.showNormal()
                resetNormalWindow()
            }
        }

        function showApp() {
            mainWindow.show()
            mainWindow.raise()
            mainWindow.requestActivate()
        }
    }

    Rectangle {
        id: rectAppContainer
        color: PlasmaCore.Theme.headerBackgroundColor
        anchors.fill: parent
        anchors.rightMargin: windowMargin
        anchors.leftMargin: windowMargin
        anchors.bottomMargin: windowMargin
        anchors.topMargin: windowMargin
        //border.width: 1
        //border.color: PlasmaCore.Theme.highlightColor

        Rectangle {
            id: rectTitleBar
            height: 35
            color: "#00040000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.topMargin: 1
            anchors.bottomMargin: 1

            DragHandler {
                onActiveChanged: if (active) {
                                     mainWindow.startSystemMove()
                                     internal.ifMaximizedWindowRestore()
                                 }
            }

            ToggleButton {
                id: btnMenu
                width: 40
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                btnIconSource: "images/svg_icons/menu_icon.svg"
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                btnColorDefault: PlasmaCore.Theme.headerBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor

                onClicked: animationMenu.running = true
            }

            Label {
                id: lblKDE
                text: qsTr("KDE")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: btnMenu.right
                font.bold: true
                font.pointSize: 20
                anchors.leftMargin: 0
                font.family: PlasmaCore.Theme.defaultFont
                color: PlasmaCore.Theme.headerTextColor
            }

            Label {
                id: lblKam
                text: qsTr("kam")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: lblKDE.right
                font.bold: false
                font.family: PlasmaCore.Theme.defaultFont
                anchors.leftMargin: 0
                font.pointSize: 18
                color: PlasmaCore.Theme.headerTextColor
            }

            TopBarButton {
                id: btnClose
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                btnColorDefault: PlasmaCore.Theme.headerBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: "#ff007f"
                btnIconSource: "images/svg_icons/close_icon.svg"
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                anchors.rightMargin: 0

                onClicked: function() { mainWindow.close() }
            }

            TopBarButton {
                id: btnMaximizeRestore
                anchors.right: btnClose.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                btnIconSource: "images/svg_icons/maximize_icon.svg"
                anchors.bottomMargin: 0
                btnColorDefault: PlasmaCore.Theme.headerBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                anchors.topMargin: 0
                anchors.rightMargin: 0

                onClicked: internal.maximizeRestore()
            }

            TopBarButton {
                id: btnMinimize
                anchors.right: btnMaximizeRestore.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                btnIconSource: "images/svg_icons/minimize_icon.svg"
                anchors.bottomMargin: 0
                btnColorDefault: PlasmaCore.Theme.headerBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                anchors.topMargin: 0
                anchors.rightMargin: 0

                onClicked: {
                    //if (SystemTrayIsEnabled) mainWindow.hide()
                    //else {
                    mainWindow.showMinimized()
                    internal.resetNormalWindow()
                    //}
                }
            }

        }

        Rectangle {
            id: rectMenu
            width: 70
            anchors.left: parent.left
            anchors.top: rectTitleBar.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 0
            color: PlasmaCore.Theme.viewBackgroundColor

            PropertyAnimation {
                id: animationMenu
                target: rectMenu
                property: "width"
                to: if (rectMenu.width == 70) return 175G; else return 70
                duration: 500
                easing.type: Easing.InOutCirc
            }

            /*Rectangle {
                id: rectRightBorder
                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }

                color: PlasmaCore.Theme.highlightColor
                width: 1
            }*/

            /*Rectangle {
                id: rectTopBorder
                anchors {
                    top: parent.top
                    right: parent.right
                    left: parent.left
                }

                color: PlasmaCore.Theme.highlightColor
                height: 1
            }*/

            LeftMenuButton {
                id: btnHome
                width: parent.width
                height: 60
                text: qsTr("Home")
                anchors.left: parent.left
                anchors.top: parent.top
                isActiveMenu: true
                btnIconSource: "images/svg_icons/home_icon.svg"
                btnColorDefault: PlasmaCore.Theme.viewBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Home")

                onClicked: {
                    btnHome.isActiveMenu = true
                    btnSettings.isActiveMenu = false
                    stackView.push(Qt.resolvedUrl("pages/homePage.qml"))
                }
            }

            LeftMenuButton {
                id: btnSysInfo
                width: parent.width
                height: 60
                text: qsTr("System Info")
                anchors.left: parent.left
                anchors.top: btnHome.bottom
                isActiveMenu: false
                btnIconSource: "images/svg_icons/sysinfo_icon.svg"
                btnColorDefault: PlasmaCore.Theme.viewBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("System Info")
            }

            LeftMenuButton {
                id: btnLighting
                width: parent.width
                height: 60
                text: qsTr("Lighting")
                anchors.left: parent.left
                anchors.top: btnSysInfo.bottom
                isActiveMenu: false
                btnIconSource: "images/svg_icons/lighting_icon.svg"
                btnColorDefault: PlasmaCore.Theme.viewBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Lighting")
            }

            LeftMenuButton {
                id: btnCooling
                width: parent.width
                height: 60
                text: qsTr("Cooling")
                anchors.left: parent.left
                anchors.top: btnLighting.bottom
                isActiveMenu: false
                btnIconSource: "images/svg_icons/cooling_icon.svg"
                btnColorDefault: PlasmaCore.Theme.viewBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Cooling")
            }

            LeftMenuButton {
                id: btnSettings
                width: parent.width
                height: 60
                text: qsTr("Settings")
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                isActiveMenu: false
                btnIconSource: "images/svg_icons/settings_icon.svg"
                btnColorDefault: PlasmaCore.Theme.viewBackgroundColor
                btnColorMouseOver: PlasmaCore.Theme.buttonHoverColor
                btnColorClicked: PlasmaCore.Theme.buttonFocusColor
                activeMenuColor: PlasmaCore.Theme.highlightColor
                clip: true

                hoverEnabled: true
                ToolTip.delay:500
                ToolTip.timeout: 5000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Settings")

                onClicked: {
                    btnSettings.isActiveMenu = true
                    btnHome.isActiveMenu = false
                    stackView.push(Qt.resolvedUrl("pages/settingsPage.qml"))
                }
            }
        }

        Rectangle {
            id: rectAppContent
            color: PlasmaCore.Theme.backgroundColor
            anchors.left: rectMenu.right
            anchors.right: parent.right
            anchors.top: rectTitleBar.bottom
            anchors.bottom: rectStatusBar.top
            anchors.rightMargin: 10
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            radius: 5
            //border.width: 1
            //border.color: PlasmaCore.Theme.highlightColor

            StackView {
                id: stackView
                anchors.fill: parent
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                anchors.topMargin: 2
                anchors.bottomMargin: 2
                clip: true
                initialItem: Qt.resolvedUrl("pages/homePage.qml")
                visible:true
            }
        }

        /*MouseArea {
            id: resizeLeft
            width:10
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.bottomMargin: 10
            anchors.topMargin: 10
            cursorShape: Qt.SizeHorCursor

            DragHandler {
                target: null
                onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.LeftEdge) }
            }
        }

        MouseArea {
            id: resizeRight
            width:10
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.bottomMargin: 10
            anchors.topMargin: 10
            cursorShape: Qt.SizeHorCursor

            DragHandler {
                target: null
                onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.RightEdge) }
            }
        }

        MouseArea {
            id: resizeBottom
            width:10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 0
            cursorShape: Qt.SizeVerCursor

            DragHandler {
                target: null
                onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.BottomEdge) }
            }
        }*/

        /*Rectangle {
            id: rectStatusBar
            height: 25
            anchors.left: rectMenu.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            color: PlasmaCore.Theme.headerBackgroundColor

            Image {
                id: imgResize
                opacity: 0.5
                width: 25
                height: 25
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 5
                anchors.topMargin: 5
                source: "images/svg_icons/resize_icon.svg"
                sourceSize.height: 16
                sourceSize.width: 16
                fillMode: Image.PreserveAspectFit
                antialiasing: false
            }

            MouseArea {
                id: resizeWindow
                width: 25
                height:25
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                cursorShape: Qt.SizeFDiagCursor

                DragHandler {
                    target: null
                    onActiveChanged: if (active) { mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge) }
                }
            }
        }*/
    }

    DropShadow {
        anchors.fill: rectAppContainer
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 16
        color: "#60000000"
        source:rectAppContainer
        z: -1
    }

    /*Labs.SystemTrayIcon {
        id: sysTrayIcon
        icon.source: "images/png_icons/kam.png"
        visible: true
        onActivated: {
            if (reason === Labs.SystemTrayIcon.Trigger) {
                if (mainWindow.visible === false) {
                    internal.showApp();
                }
                else {
                    mainWindow.hide()
                }
            }
            else if (reason === Labs.SystemTrayIcon.MiddleClick) {
                //showMessage("Message title", "Middle button was clicked.")
            }
        }

        menu: Labs.Menu {
            id: trayMenu
            Labs.MenuItem {
                id: showItem
                text: qsTr("Show")
                onTriggered: internal.showApp()
            }
            Labs.MenuItem {
                id: hideItem
                text: qsTr("Hide")
                onTriggered: mainWindow.hide()
            }
            Labs.MenuSeparator {}
            Labs.MenuItem {
                id: quitItem
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
    }*/
}

/*##^##
Designer {
    D{i:0;height:600;width:850}
}
##^##*/
