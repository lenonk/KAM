import CustomControls 1.0
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

RadialBar {
    id: control

    width: parent.width / 2.5
    height: width
    penStyle: Qt.FlatCap
    progressColor: Kirigami.Theme.highlightColor
    foregroundColor: Kirigami.Theme.disabledTextColor
    dialWidth: 8
    minValue: 0
    maxValue: 100
    value: 16
    suffixText: "%"
    startAngle: 350
    textFont {
        family: "MrEavesXLModOT-Book"
        pointSize: 30
    }
    textColor: progressColor
}
