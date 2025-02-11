install.packages("dtw")


## A noisy sine wave as query
idx<-seq(0,6.28,len=100);
query<-sin(idx)+runif(100)/10;

## A cosine is for template; sin and cos are offset by 25 samples
template<-cos(idx)

## Find the best match with the canonical recursion formula
library(dtw);
alignment<-dtw(query,template,keep=TRUE);

## Display the warping curve, i.e. the alignment curve
plot(alignment,type="threeway")

## Align and plot with the Rabiner-Juang type VI-c unsmoothed recursion
plot(
  dtw(t1$Value,t2$Value,keep=TRUE,
      step=mvmStepPattern(20)),
  type="twoway",offset=-2);

## See the recursion relation, as formula and diagram
rabinerJuangStepPattern(6,"c")
plot(rabinerJuangStepPattern(6,"c"))

dtw =   dtw(t1$Value,t2$Value,keep=TRUE, step = asymmetric , open.begin = TRUE, open.end = TRUE)

dtw =   dtw(t1$Value,t2$Value,keep=TRUE,
            step=rabinerJuangStepPattern(6,"c"), open.begin = TRUE, open.end = TRUE)

plot(dtw, type="twoway",offset=-2)


summary(dtw)
dtw["normalizedDistance"]
dtw["index1"]


dtw["index1s"]

seqA <- t1$Value
seqB <- t2$Value
  
## Find the best match with dynamic time warping
alignment<-dtw(seqA,seqB,keep=TRUE, step = asymmetric , open.begin = TRUE, open.end = TRUE);
plot(alignment, type = "twoway")

##Extract just the warped version of seqA from the alignment
seqAindex<-dput(as.double(alignment$index1s));
stretchedseqA<-(seqA[c(seqAindex)]);

##Extract just the warped version of seqB from the alignment
seqBindex<-dput(as.double(alignment$index2s));
stretchedseqB<-(seqB[c(seqBindex)]);

ggplot() +
  geom_line(aes(x = c(1:length(stretchedseqB)), y = stretchedseqB))

##Plot the vectors after warping
plot(stretchedseqA, type="l", col="red",xlab="Position", ylab="Peak Height", main="Warped Vectors-The Alignment")
lines(stretchedseqB, type="l", col="blue")
legend(1, 95, legend=c("SeqA", "SeqB"),col=c("red", "blue"), lty=1:1, cex=0.8)

tic()
ncc = NCCc(t1$Value, t2$Value)
toc()
tic()
cc= ccf(t1$Value, t2$Value)
toc()


ggplot () +
  geom_point(aes(x = c(1:length(ncc))/length(ncc), y = ncc)) +
  geom_point(aes(x = c(1:length(cc$acf)/length(cc$acf)), y = cc$acf))

plot(ncc)
plot(cc$acf)

length(ncc)
length(cc$acf)

sb = sbd(t1$Value, t2$Value)[["yshift"]] 

sbdd = sbd(t1$Value, t2$Value)[["dist"]] 

mean(dtw$index2s-dtw$index1s)

dx = data.frame(v1 = dtw$index1s, v2 = dtw$index2s) %>%
  filter(v2>1)

dx$v1 - dx$v2

mean(warp(dtw)-c(1:length(warp(dtw))))

unique(dtw$index2s) %>% length()

dtw$index2s

ggplot() +
  geom_point(aes(y = scale(sb), x = c(1:length(sb)), color = "sb")) +
  geom_point(aes(y = scale(t1$Value), x = c(1:length(sb)), color = "t1")) +
  geom_point(aes(y = scale(t2$Value), x = c(1:length(sb)), color = "t2")) +
  geom_point(aes(y = scale(t2$Value), x = c(1:length(sb)*(1.9)), color = "t2 adj"))

stretch_cc(t1, t2)

normdtw = function(a,b){
  # a = (a-min(a))/(max(a)-min(a))
  # b = (b-min(b))/(max(b)-min(b))
  
  a = scale(a)[,1]
  b = scale(b)[,1]
  
  dtw(a,b)
}

wd = growth.df %>% vascr_subset(unit = "R", frequency = 4000) 
to_export = wd %>% vascr_summarise(level = "experiments") %>% vascr_cc(reference = "0_cells + HCMEC D3_line")

to_export$cc = to_export$ndtw
to_export
vascr_summarise_cc(to_export) %>% vascr_plot_cc_stats()


vascr_plot_cc_stats(to_export, points = TRUE)
vascr_plot_cc_stretch_shift_stats(wd)
