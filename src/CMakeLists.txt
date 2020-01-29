set (kam_SRCS
    main.cpp
    radialbar.cpp
    backend.cpp
)

set (moc_SRCS
    ../include/radialbar.h
    ../include/backend.h
)

qt5_add_resources(kam_RSRCS 
    resources.qrc
)

add_executable(kam ${kam_SRCS} ${moc_SRCS} ${kam_RSRCS})

target_link_libraries(kam 
    Qt5::Core 
    Qt5::Gui 
    Qt5::Qml 
    Qt5::Quick 
    Qt5::QuickControls2 
    Qt5::Svg 
    KF5::I18n
    ${Boost_LIBRARIES}
    pthread
    sensors
)

install(TARGETS kam ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
