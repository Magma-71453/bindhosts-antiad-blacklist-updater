SKIPMOUNT=false
LATESTARTSERVICE=true
POSTFSDATA=false
PROPFILE=false
on_install() {
 unzip -o "$ZIPFILE" 'action.sh' -d $MODPATH >&2
 unzip -o "$ZIPFILE" 'curl-arm64' -d $MODPATH >&2
# unzip -o "$ZIPFILE" 'rename' -d $MODPATH >&2
 unzip -o "$ZIPFILE" 'service.sh' -d $MODPATH >&2
}
set_permissions() {
 set_perm_recursive $MODPATH 0 0 0755 0755
#设置权限，基本不要去动
}
