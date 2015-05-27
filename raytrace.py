import util

cmd.hide()
cmd.show("cartoon")
cmd.set("cartoon_fancy_helices",1)
cmd.set("cartoon_side_chain_helper",1)
cmd.set("cartoon_highlight_color","grey50")
cmd.set("antialias", 2 )
cmd.set("ray_shadow", 0 )
cmd.set("ray_trace_mode",1)
cmd.set("fog",0)
cmd.set("ambient",0.15)
cmd.bg_color("white")

#cmd.select( "main", "name C+H+N+O" )
#cmd.select( "side", "!main" )
#cmd.show("stick", "side")
#cmd.hide("stick", "hydrogen")
#cmd.select( "side2", "!(name C+CA+N+O+H)" )

#cmd.extend("raytrace",raytrace)
