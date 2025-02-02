
/obj/machinery/computer/station_alert
	name = "station alert console"
	desc = "Used to access the station's automated alert system."

	icon_screen = "alert:0"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/stationalert
	var/datum/nano_module/alarm_monitor/alarm_monitor
	var/monitor_type = /datum/nano_module/alarm_monitor

/obj/machinery/computer/station_alert/engineering
	monitor_type = /datum/nano_module/alarm_monitor/engineering

/obj/machinery/computer/station_alert/security
	monitor_type = /datum/nano_module/alarm_monitor/security

/obj/machinery/computer/station_alert/all
	monitor_type = /datum/nano_module/alarm_monitor/all

/obj/machinery/computer/station_alert/Initialize()
	. = ..()
	if(monitor_type)
		register_monitor(new monitor_type(src))
		alarm_monitor.register_alarm(src, /atom/.proc/update_icon)

/obj/machinery/computer/station_alert/Destroy()
	. = ..()
	unregister_monitor()

/obj/machinery/computer/station_alert/proc/register_monitor(var/datum/nano_module/alarm_monitor/monitor)
	if(monitor.host != src)
		return

	alarm_monitor = monitor


/obj/machinery/computer/station_alert/proc/unregister_monitor()
	if(alarm_monitor)
		alarm_monitor.unregister_alarm(src)
		qdel(alarm_monitor)
		alarm_monitor = null

/obj/machinery/computer/station_alert/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/computer/station_alert/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/station_alert/ui_interact(mob/user)
	if(alarm_monitor)
		alarm_monitor.ui_interact(user)

/obj/machinery/computer/station_alert/nano_container()
	return alarm_monitor

/obj/machinery/computer/station_alert/update_icon()
	icon_screen = initial(icon_screen)
	if(!(stat & (BROKEN|NOPOWER)))
		if(alarm_monitor)
			var/list/alarms = alarm_monitor.major_alarms()
			if(alarms.len)
				icon_screen = "alert:2"
	. = ..()
