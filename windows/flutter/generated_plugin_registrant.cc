//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <flutter_status_bar/flutter_status_bar_plugin.h>
#include <url_launcher_windows/url_launcher_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterStatusBarPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterStatusBarPlugin"));
  UrlLauncherPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherPlugin"));
}
