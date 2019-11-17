# xcell_import = function(file)
# {
# data = readLines(file)
# 
# data.df = as.data.frame(data)
# 
# layouttitle = which(data.df$data == "Layout")+1
# minlayout = which(data.df$data == "Layout")+2
# maxlayout = which(data.df$data == "Schedule")-2
# 
# layout = as.data.frame(data.df[minlayout:maxlayout,1])
# layouttitle = data.df[layouttitle, 1]
# layouttitle = as.character(layouttitle)
# 
# layouttitles = strsplit(layouttitle, "\t")
# layouttitles = layouttitles[[1]]
# 
# colnames(layout)[1] = "data"
# lookups = separate(layout, "data", layouttitles, sep = "\t")
# 
# lookups$`Cell-Number` = as.numeric(lookups$`Cell-Number`)
# lookups$Concentration = as.numeric(lookups$Concentration)
# 
# 
# lookups$treatment = paste(lookups$Concentration,"_", lookups$Unit, " ", lookups$`Compound Name` , sep = "")
# lookups$cells = paste(lookups$`Cell-Number`,"_", lookups$`Cell-Type`, sep = "")
# 
# lookups$Sample = paste(lookups$treatment, lookups$cells, sep = "+")
# 
# lookups = select(lookups, Sample, `Well ID`)
# 
# mindata = which(data.df$data == "Cell Index")+1
# maxdata = which(data.df$data == "Message")-2
# 
# rawdata = as.data.frame(data.df[mindata:maxdata,1])
# colnames(rawdata)[1] = "data"
# rawdata = rawdata$data
# 
# alltimes = c()
# junk = c()
# 
# for(line in rawdata)
# {
#   if(str_detect(line,"Cell Index at: "))
#   {
#     time = str_remove(line, "Cell Index at: ")
#   }
#   
#   alltimes = c(alltimes, time)
# }
# 
# timeddata = data.frame(alltimes, rawdata)
# 
# splitdata = separate(timeddata, rawdata, into = as.character(c("row", 1:12)), sep = "\t", fill = "right")
# splitdata = na.omit(splitdata)
# splitdata = subset(splitdata, `12` != "12")
# 
# longdata = pivot_longer(splitdata, as.character(c(1:12)), names_to = "col")
# 
# longdata$well = paste(longdata$row, longdata$col, sep = "")
# longdata$row = NULL
# longdata$col = NULL
# 
# longdata = separate(longdata, alltimes, c("h", "m", "s"))
# longdata$time = as.numeric(longdata$h) + as.numeric(longdata$m)/60 + as.numeric(longdata$s)/60/60
# 
# longdata$h = NULL
# longdata$m = NULL
# longdata$s = NULL
# 
# longdata$Unit = "CI"
# 
# names(longdata)[names(longdata) == "value"] <- "Value"
# names(longdata)[names(longdata) == "well"] <- "Well"
# names(longdata)[names(longdata) == "time"] <- "Time"
# 
# 
# fulldata = left_join(longdata, lookups, by = c(Well = "Well ID"))
# 
# fulldata$Sample = str_replace(fulldata$Sample, "_mM", "000_nM")
# fulldata$Sample = str_replace(fulldata$Sample, "_ +", "")
# fulldata$Frequency = 0
# fulldata$Experiment =  file
# 
# fulldata$Value = as.numeric(fulldata$Value)
# 
# return(fulldata)
# 
# }
# 
# fulldata2 = xcell_import("excluded/xcell.txt")
# 
# exploded = ecis_explode(fulldata2)
# imploded = ecis_implode(exploded)
# 
# 
# ecis_plot(fulldata2, unit = "CI", frequency = 0 , replication = "experiments", time = c(170,220) , samplecontains = "Nerifollin")
# 
# 
# 
# 
