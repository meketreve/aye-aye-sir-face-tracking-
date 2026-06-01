#include <obs-module.h>

#include "mask-filter.hpp"

OBS_DECLARE_MODULE()
OBS_MODULE_USE_DEFAULT_LOCALE("aye-aye-mask", "en-US")

MODULE_EXPORT const char *obs_module_description(void)
{
	return "Eye-tracking mask filter: tracks the face and projects an "
	       "image/video mask in 3D over the eyes.";
}

MODULE_EXPORT const char *obs_module_name(void)
{
	return "Eye Mask Tracker";
}

bool obs_module_load(void)
{
	obs_register_source(&mask_filter_info);
	blog(LOG_INFO, "[aye-aye-mask] loaded (v%s)", PLUGIN_VERSION);
	return true;
}

void obs_module_unload(void)
{
	blog(LOG_INFO, "[aye-aye-mask] unloaded");
}
