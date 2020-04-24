# 
# toplot2.df = vascr_prep_graphdata(growth.df, unit = "Rb")
# 
# toplot2.df = vascr_summarise(toplot2.df, level = "summary")
# 
# plot = ggplot2::ggplot(data = toplot2.df, ggplot2::aes(x = Time, y = Value, colour = Sample, ymin = Value - sd/sqrt(n), ymax = Value + sd/sqrt(n), fill = Sample)) + ggplot2::geom_line()
# 
# plot = plot + geom_ribbon(alpha = 0.1)
# 
# plot = plot + geom_errorbar()
# 
# 
# install.packages("CodeDepends")
# install.packages("Rgraphviz")
# library(graph)
# library(CodeDepends)
# 
# 
# 
# gg = makeCallGraph("package:vascr")
# if(require(Rgraphviz)) {
#   gg = layoutGraph(gg, layoutType = "circo")
#   graph.par(list(nodes = list(fontsize=55)))
#   renderGraph(gg) ## could also call plot directly
# } 
# 
# 
# devtools::install_github("datastorm-open/DependenciesGraphs")
# 
# 
# library("DependenciesGraphs")
# library(vascr) # A package I'm developing
# 
# dep <- envirDependencies("package:vascr")
# plot(dep)
# launch.app()
# 
# deps <- funDependencies("package:vascr", "vascr_plot")
# plot(deps)
# 
# 
# 
# 
# 
# 
