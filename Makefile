    SHELL=/bin/bash
    JELLYBEAN_VERSION = tg_endeavoru-ota-33
     
    clean-zip:
	rm $(PACKAGE_NAME)*.zip
     
    zip:
	zip -r $(PACKAGE_NAME).zip * -x Makefile
     
    sign:
	java -jar /home/dejan/onex/SignApk/signapk.jar /home/dejan/onex/SignApk/testkey.x509.pem /home/dejan/onex/SignApk/testkey.pk8 $(PACKAGE_NAME).zip $(PACKAGE_NAME)_signed.zip
     
    package: zip sign
     
    get-miui:
	wget -O resources/roms/miuiandroid_maguro_jb-$(MIUI_VERSION).zip http://files.miuiandroid.com/$(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION).zip
     
    prepare-jb:
	mkdir $(MIUI_VERSION)
	ln -s ../resources/roms/$(JELLYBEAN_VERSION).zip $(MIUI_VERSION)/
	ln -s ../resources/roms/miuiandroid_maguro_jb-$(MIUI_VERSION).zip $(MIUI_VERSION)/
	mkdir $(MIUI_VERSION)/$(JELLYBEAN_VERSION)
	mkdir $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)
	mkdir $(MIUI_VERSION)/{jellybean_framework_jar,miui_framework_jar,jellybean_services_jar,miui_services_jar,miui_framework-res_apk}
	cd $(MIUI_VERSION); unzip $(JELLYBEAN_VERSION).zip -d $(JELLYBEAN_VERSION); unzip miuiandroid_maguro_jb-$(MIUI_VERSION).zip -d miuiandroid_maguro_jb-$(MIUI_VERSION)
           
	cp -rvp $(MIUI_VERSION)/$(JELLYBEAN_VERSION) $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)
           
	sed s/{{MIUI_VERSION}}/$(MIUI_VERSION)/ resources/Makefile.tpl > $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/Makefile
           

	baksmali -o $(MIUI_VERSION)/jellybean_framework_jar/ $(MIUI_VERSION)/$(JELLYBEAN_VERSION)/system/framework/framework.jar
	baksmali -o $(MIUI_VERSION)/jellybean_services_jar/ $(MIUI_VERSION)/$(JELLYBEAN_VERSION)/system/framework/services.jar
	baksmali -o $(MIUI_VERSION)/miui_framework_jar/ $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/framework/framework.jar
	baksmali -o $(MIUI_VERSION)/miui_services_jar/ $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/framework/services.jar
	baksmali -o $(MIUI_VERSION)/miui_android_policy_jar/ $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/framework/android.policy.jar

	apktool if $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/framework/framework-res.apk
	apktool if $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/framework/framework-miui-res.apk
	apktool d -f $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/framework/framework-res.apk $(MIUI_VERSION)/miui_framework-res_apk/
	apktool d -f $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/app/MiuiHome.apk $(MIUI_VERSION)/miui_MiuiHome_apk/
	apktool d -f $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/app/Settings.apk $(MIUI_VERSION)/miui_Settings_apk/
     
	rm $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/app/*
	cp -v $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/app/* $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/app/
	rm $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/app/{Nfc,LegacyCamera,BugReport,MIUIStats,Updater}.apk
	cp -v $(MIUI_VERSION)/$(JELLYBEAN_VERSION)/system/app/{Gallery2,Polly,Nfc}.apk $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/app/
	cp -v $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/framework/* $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework
           
	cp -v $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/lib/{content-types.properties,libffmpeg_xm.so,libffplayer_jni.so,liblbesec.so,liblocSDK_2.5OEM.so,libjni_resource_drm.so,libphotocli.so,libshell.so,libshell_jni.so,libshellservice.so} $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/lib/
           
	cp -v $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/etc/{yellowpage.db,telocation.idf,weather_city.db,unicode_py_index.td,permission_config.json} $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/etc/
           
	cp -v $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/etc/permissions/miui-framework.xml $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/etc/permissions/
           
	cp -rv $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/media/* $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/media/
           
	cp -v $(MIUI_VERSION)/miuiandroid_maguro_jb-$(MIUI_VERSION)/system/xbin/{invoke-as,su,shelld} $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/xbin/
            
	cp -v $(MIUI_VERSION)/jellybean_framework_jar/android/hardware/Camera* $(MIUI_VERSION)/miui_framework_jar/android/hardware/
	cp -v $(MIUI_VERSION)/jellybean_framework_jar/android/view/Hardware* $(MIUI_VERSION)/miui_framework_jar/android/view/
	cp -v $(MIUI_VERSION)/jellybean_framework_jar/android/view/GLES20* $(MIUI_VERSION)/miui_framework_jar/android/view/
	cp -v $(MIUI_VERSION)/jellybean_framework_jar/android/webkit/WebViewCore.smali $(MIUI_VERSION)/miui_framework_jar/android/webkit/
	cp -v $(MIUI_VERSION)/jellybean_framework_jar/android/webkit/WebViewCore\$$EventHub.smali $(MIUI_VERSION)/miui_framework_jar/android/webkit/
	cp -v $(MIUI_VERSION)/jellybean_framework_jar/android/webkit/WebViewCore\$$EventHub\$$1.smali $(MIUI_VERSION)/miui_framework_jar/android/webkit/
	cp -v $(MIUI_VERSION)/jellybean_framework_jar/com/android/internal/telephony/QualcommSharedRIL* $(MIUI_VERSION)/miui_framework_jar/com/android/internal/telephony/
	cp -v $(MIUI_VERSION)/jellybean_framework_jar/com/android/internal/telephony/RIL*.smali $(MIUI_VERSION)/miui_framework_jar/com/android/internal/telephony/
	cp -v resources/4wayreboot/ShutdownThread*.smali $(MIUI_VERSION)/miui_framework_jar/com/android/internal/app/
	cp -v $(MIUI_VERSION)/jellybean_services_jar/com/android/server/WiredAccessoryObserver* $(MIUI_VERSION)/miui_services_jar/com/android/server/        
	cp -v resources/media/bootanimation.zip $(MIUI_VERSION)/ONEX_MIUI_JB_$(MIUI_VERSION)/system/media/

     
	cp -v resources/framework_res/res/values/bools.xml $(MIUI_VERSION)/miui_framework-res_apk/res/values/
	cp -v resources/framework_res/res/xml/storage_list.xml $(MIUI_VERSION)/miui_framework-res_apk/res/xml/
	cp -v resources/home/arrays.xml $(MIUI_VERSION)/miui_MiuiHome_apk/res/values/

	cd $(MIUI_VERSION)/miui_android_policy_jar/com/android/internal/policy/impl/; patch -p0 < reboot/
	
	
	cd $(MIUI_VERSION)/miui_framework_jar; smali -o ../classes.dex ./
	mkdir $(MIUI_VERSION)/framework_jar_temp
	cd $(MIUI_VERSION)/framework_jar_temp; unzip ../[ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework/framework.jar; mv ../classes.dex ./; zip -r ../ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework/framework.jar *

	cd $(MIUI_VERSION)/miui_services_jar; smali -o ../classes.dex ./
	mkdir $(MIUI_VERSION)/services_jar_temp
	cd $(MIUI_VERSION)/services_jar_temp; unzip ../[ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework/services.jar; mv ../classes.dex ./; zip -r ../ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework/services.jar *

	cd $(MIUI_VERSION)/miui_android_policy_jar; smali -o ../classes.dex ./
	mkdir $(MIUI_VERSION)/policy_jar_temp
	cd $(MIUI_VERSION)/policy_jar_temp; unzip ../[ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework/android.policy.jar; mv ../classes.dex ./; zip -r ../ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework/android.policy.jar *


	apktool b $(MIUI_VERSION)/miui_MiuiHome_apk
	mkdir $(MIUI_VERSION)/miui_MiuiHome_apk/dist/temp
	cd $(MIUI_VERSION)/miui_MiuiHome_apk/dist; unzip MiuiHome.apk; cd temp; 	unzip ../../../ONEX_MIUI_JB_$(MIUI_VERSION)/system/app/MiuiHome.apk; cp ../resources.arsc ./; zip -r ../../../ONEX_MIUI_JB_$(MIUI_VERSION)/system/app/MiuiHome.apk *


	apktool b $(MIUI_VERSION)/miui_framework-res_apk
	mkdir $(MIUI_VERSION)/miui_framework-res_apk/dist/temp
	cd $(MIUI_VERSION)/miui_framework-res_apk/dist; unzip framework-res.apk; cd temp; 	unzip ../../../ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework/framework-res.apk; cp ../{resources.arsc,res} ./; zip -r ../../../ONEX_MIUI_JB_$(MIUI_VERSION)/system/framework/framework-res.apk *
	
	
	
     
           
     
	echo "Preparing completed!"
	

