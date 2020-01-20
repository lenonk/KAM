qt5_add_resources(kam_SRCS resources.qrc)
add_executable(kam main.cpp radialbar.cpp ${kam_SRCS})
target_link_libraries(kam Qt5::Core Qt5::Gui Qt5::Qml Qt5::Quick Qt5::QuickControls2 Qt5::Svg KF5::I18n)
install(TARGETS kam ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
