##############################################
##############################################
##### Mathematical model of LD dacay run #####
##### for a variety of parameters.       #####
##############################################
##############################################


##############################################
##### Function that takes points in a    #####
##### sine wave defined by it's maximum  #####
##### point, it's period, and its phase  #####
##### shift.                             #####
##############################################

s.coef2 <- function(time, s.max=0.1, period = sqrt(2), phase.shift = 0)
{
  # calculate the minimum s value such that it corresponds with fitness inverse of max.s
  s.min=1-(1/(1-s.max))
  # calculate amplitude based on s.max and s.min
  amplitude=(s.max-s.min)/2
  # calculate how much the wave needs to be shifted up or down such that it hits s.min and s.max
  vertical.shift=s.max-amplitude
  #calculate the value of the sine wave at the times indicated in the input
  s.t <- amplitude * sin(2*pi*period * (time + phase.shift)) + vertical.shift
  df <- data.frame(time, s.t)
  return(df)
}

##############################################
##### The Dsim function takes two        #####
##### vectors of equal length (s1 and    #####
##### s2) that contain selection         #####
##### coefficients for a number of       #####
##### generations equal to their length. #####
##############################################

Dsim<-function(s1, s2, r = 1e-8){
  p_A = 0.5
  p_B = 0.5
  p_AB = 0.5
  p_Ab = 0
  p_aB = 0
  p_ab = 1 - (p_AB + p_aB + p_Ab)
  D = (p_AB - (p_A * p_B)) / min(c(p_A * (1 - p_B), (1 - p_A) * p_B))
  pA=p_A
  pB=p_B
  pAB=p_AB
  pAb=p_Ab
  paB=p_aB
  pab=p_ab
  for(i in 1:length(s1)){
    s_A = s1[i]
    s_B = s2[i]
    w_A = 1 - s_A
    w_B = 1 - s_B
    w_AB = 1 - (p_AB * (s_A + s_B - s_A * s_B) + p_Ab * s_A + p_aB * s_B)
    p1_AB = (p_AB * w_A * w_B) / (w_AB)
    p1_Ab = (p_Ab * w_A) / (w_AB)
    p1_aB = (p_aB * w_B) / (w_AB)
    p1_ab = 1 - (p_AB + p_Ab + p_aB)
    p_AB = p1_AB - p1_AB * p1_ab * r + p1_Ab * p1_aB * r
    p_Ab = p1_Ab - p1_Ab * p1_aB * r + p1_AB * p1_ab * r
    p_aB = p1_aB - p1_aB * p1_Ab * r + p1_AB * p1_ab * r
    p_ab = 1 - (p_AB + p_Ab + p_aB)
    p_A = p_Ab + p_AB
    p_B = p_aB + p_AB
    D1 = (p_AB - (p_A * p_B)) / min(c(p_A * (1 - p_B), (1 - p_A) * p_B))
    D = c(D, D1)
    pA = c(pA, p_A)
    pB = c(pB, p_B)
    pAB=c(pAB, p_AB)
    pAb=c(pAb, p_Ab)
    paB=c(paB, p_aB)
    pab=c(pab, p_ab)
    if(D1<0.0001){
      break
    }
  }
  y = data.frame(pAB=pAB, pAb=pAb, paB=paB, pab=pab, pA=pA, pB=pB, D=D)
  return(y)
}

##############################################
##### The LDmodelrun function takes      #####
##### vectors of parameters and runs the #####
##### s.coef2 and Dsim functions on them #####
##### to obtain values of allele and     #####
##### haplotype frequencies and values   #####
##### LD over generational time.         #####
##############################################



LDmodelrun<-function(time, s.max1, s.max2, period1, period2, phase.shift1, phase.shift2, r, random=FALSE){
  s1<-s.coef2(time=time, s.max=s.max1, period = period1, phase.shift = phase.shift1)
  s2<-s.coef2(time=time, s.max=s.max2, period = period2, phase.shift = phase.shift2)
  if(random==TRUE){
    s1$s.t=sample(x=s1$s.t, size = length(s1$s.t), replace = FALSE)
    s2$s.t=sample(x=s2$s.t, size = length(s2$s.t), replace = FALSE)
  }
  D1<-Dsim(s1=s1$s.t, s2=s2$s.t, r = r)
  return(D1)
}

##############################################
##### We define the parameter space for  #####
##### the model runs. Every combination  #####
##### of parameters is taken by          #####
##### repeating the values of certain    #####
##### parameters.                        #####
##############################################

time=1:100000
s.max1_vector<-c(rep(0,134400/5), rep(0.1, 134400/5), rep(0.01, 134400/5), rep(0.05, 134400/5), rep(0.001, 134400/5))
s.max2_vector<-rep(c(rep(0,134400/25), rep(0.1, 134400/25), rep(0.01, 134400/25), rep(0.05, 134400/25), rep(0.001, 134400/25)), 5)
period1_vector<-rep(c(rep(1, 134400/200), rep(2, 134400/200), rep(4, 134400/200), rep(8, 134400/200), rep(16, 134400/200), rep(sqrt(2), 134400/200), rep(sqrt(13), 134400/200), rep(sqrt(53), 134400/200)), 25)
period2_vector<-rep(c(rep(1, 134400/1600), rep(2, 134400/1600), rep(4, 134400/1600), rep(8, 134400/1600), rep(16, 134400/1600), rep(sqrt(2), 134400/1600), rep(sqrt(13), 134400/1600), rep(sqrt(53), 134400/1600)), 200)
phase.shift2_vector<-rep(c(rep(0, 134400/11200), rep(pi*(1/4), 134400/11200), rep(pi*(1/2), 134400/11200), rep(pi*(3/4), 134400/11200), rep(pi, 134400/11200), rep(pi*(1/3), 134400/11200), rep(pi*(2/3), 134400/11200)), 1600)
r_vector<-rep(c(rep(0,134400/67200), rep(1e-01, 134400/67200), rep(1e-02, 134400/67200), rep(1e-03, 134400/67200), rep(1e-04, 134400/67200), rep(1e-05, 134400/67200)), 11200)
random_vector<-rep(c(TRUE, FALSE), 67200)

##############################################
##### We use a mapply to run the model   #####
##### over all the vectors of parameters #####
##### at the same time.                  #####
##############################################

runs_output<-mapply(FUN = LDmodelrun, s.max1=s.max1_vector, s.max2=s.max2_vector, period1=period1_vector, period2=period2_vector, phase.shift1=rep(0, length(phase.shift2_vector)), phase.shift2=phase.shift2_vector, r=r_vector, random=random_vector)


