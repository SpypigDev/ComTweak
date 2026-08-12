GLOBAL_LIST_EMPTY(cellauto_cells)

SUBSYSTEM_DEF(cellauto)
	name = "Cellular Automata"
	wait = 1
	priority = SS_PRIORITY_CELLAUTO
	flags = SS_NO_INIT|SS_TICKER|SS_POST_FIRE_TIMING

	var/list/currentrun = list()

/datum/controller/subsystem/cellauto/stat_entry(msg)
	msg = "C: [length(GLOB.cellauto_cells)]"
	return ..()

/datum/controller/subsystem/cellauto/fire(resumed = FALSE)
	if(!resumed)
		currentrun = GLOB.cellauto_cells.Copy()
	while(length(currentrun))
		var/datum/automata_cell/cell = currentrun[length(currentrun)]
		currentrun.len--

		if(cell.gc_destroyed || QDELETED(cell))
			GLOB.cellauto_cells -= cell
			continue

		cell.update_state()

		if(MC_TICK_CHECK)
			return
