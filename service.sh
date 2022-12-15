#!/system/bin/sh

# Increase system's smoothness and launcher's smoothness by increasing priority of some specified processes
for pid in $(pidof -s surfaceflinger) $(pidof -s system_server) $(pgrep -f com.android.systemui) $(pgrep -f com.sec.android.app.launcher); do
  echo "-17" > "/proc/${pid}/oom_adj"
  renice -n "-18" -p "$pid"
done


# Delaying for let the system boot
sleep 15

PKG=com.sec.android.app.launcher
UID=$(pm list packages -U | grep $PKG | sed -n -e "s/package:$PKG uid://p")

pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.READ_CONTACTS
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
pm grant $PKG android.permission.CALL_PHONE
pm grant $PKG android.permission.READ_MEDIA_IMAGES

appops set --uid $UID LEGACY_STORAGE allow
appops set $PKG READ_CONTACTS allow
appops set $PKG POST_NOTIFICATION allow
appops set $PKG CALL_PHONE allow
appops set $PKG READ_PHONE_STATE allow
appops set $PKG READ_EXTERNAL_STORAGE allow
appops set $PKG WRITE_EXTERNAL_STORAGE allow
appops set $PKG READ_MEDIA_IMAGES allow
appops set $PKG VIBRATE allow
appops set $PKG GET_USAGE_STATS allow
appops set $PKG REQUEST_DELETE_PACKAGES allow
appops set $PKG ACCESS_RESTRICTED_SETTINGS allow

# Notification access fix
cmd notification allow_listener com.sec.android.app.launcher/com.android.launcher3.notification.NotificationListener
