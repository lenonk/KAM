add_library(ksysguard_plugin_gpu MODULE gpu.cpp)
target_link_libraries(ksysguard_plugin_gpu Qt::Core KSysGuard::ProcessCore KF5::I18n KF5::CoreAddons)
install(TARGETS ksysguard_plugin_gpu DESTINATION ${KDE_INSTALL_PLUGINDIR}/ksysguard/process)
