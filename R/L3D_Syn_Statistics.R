# Script to perform statistical analysis for L3D synaptic plasma study
# Date created: 14/1/2024 
# Author: Steffi De Meyer

rm(list=ls())

# LOAD PACKAGES
library(xlsx)
library(moments)
library(ggplot2)
library(ggthemes)
library(cowplot)
library(EnvStats)
library(tiff)
library(psych)
library(tibble)
library(dplyr)
library(corrplot)
library(lavaan)
library(readxl)
library(semPlot)
library(mediation)
library(performance)
library(see)
library(RVAideMemoire)
library(dplyr)
library(rempsyc)

# LOAD DATA
# All L3D subjects with UCBJ data
data_L3D_UCBJ <- read.xlsx("C:/Users/u0115549/Documents/01_Projects/05_L3D/02_Analysis/CompleteDataset_N61/R_CompleteDataset_L3D.xlsx", 1)
data_L3D_UCBJ_healthy = subset(data_L3D_UCBJ, Group == "Healthy")
data_L3D_UCBJ_LLD = subset(data_L3D_UCBJ, Group == "LLD")
data_L3D_UCBJ_Aneg = subset(data_L3D_UCBJ, A_Status == 0)
data_L3D_UCBJ_Apos = subset(data_L3D_UCBJ, A_Status == 1)
data_L3D_UCBJ_ANA = subset(data_L3D_UCBJ, A_Status == "NA")

################################################################################
# A. Test normality & descriptive statistics of all variables
################################################################################
# Check normality
agostino.test(data_L3D_UCBJ$MMSE)
agostino.test(data_L3D_UCBJ_Aneg$MMSE)
agostino.test(data_L3D_UCBJ_healthy$MMSE)

agostino.test(data_L3D_UCBJ$Age) 
agostino.test(data_L3D_UCBJ_Aneg$Age)
agostino.test(data_L3D_UCBJ_healthy$Age)
agostino.test(data_L3D_UCBJ_LLD$Age) 

agostino.test(data_L3D_UCBJ$MK_SUVR) 
agostino.test(data_L3D_UCBJ_Aneg$MK_SUVR)
agostino.test(data_L3D_UCBJ_healthy$MK_SUVR)
agostino.test(data_L3D_UCBJ_LLD$MK_SUVR)

agostino.test(data_L3D_UCBJ$A_SUVR) 
agostino.test(data_L3D_UCBJ_Aneg$A_SUVR)
agostino.test(data_L3D_UCBJ_healthy$A_SUVR)
agostino.test(data_L3D_UCBJ_LLD$A_SUVR)

agostino.test(data_L3D_UCBJ$Abratio) 
agostino.test(data_L3D_UCBJ_Aneg$Abratio)
agostino.test(data_L3D_UCBJ_healthy$Abratio)
agostino.test(data_L3D_UCBJ_LLD$Abratio)

agostino.test(data_L3D_UCBJ$pT181) 
agostino.test(data_L3D_UCBJ_Aneg$pT181) 
agostino.test(data_L3D_UCBJ_healthy$pT181)
agostino.test(log(data_L3D_UCBJ_healthy$pT181))
agostino.test(data_L3D_UCBJ_LLD$pT181)
agostino.test(log(data_L3D_UCBJ_LLD$pT181))

agostino.test(data_L3D_UCBJ$NfL) 
agostino.test(data_L3D_UCBJ_Aneg$NfL)
agostino.test(data_L3D_UCBJ_healthy$NfL)
agostino.test(log(data_L3D_UCBJ_healthy$NfL))
agostino.test(data_L3D_UCBJ_LLD$NfL)
agostino.test(log(data_L3D_UCBJ_LLD$NfL))

agostino.test(data_L3D_UCBJ$GFAP) 
agostino.test(data_L3D_UCBJ_Aneg$GFAP)
agostino.test(data_L3D_UCBJ_healthy$GFAP) 
agostino.test(data_L3D_UCBJ_LLD$GFAP) 

agostino.test(data_L3D_UCBJ$VAMP2) 
agostino.test(data_L3D_UCBJ_Aneg$VAMP2)
agostino.test(data_L3D_UCBJ_healthy$VAMP2)
agostino.test(log(data_L3D_UCBJ_healthy$VAMP2)) 
agostino.test(data_L3D_UCBJ_LLD$VAMP2) 
agostino.test(log(data_L3D_UCBJ_LLD$VAMP2))

agostino.test(data_L3D_UCBJ$SNAP25) 
agostino.test(data_L3D_UCBJ_Aneg$SNAP25)
agostino.test(data_L3D_UCBJ_healthy$SNAP25)
agostino.test(data_L3D_UCBJ_LLD$SNAP25)

agostino.test(data_L3D_UCBJ$GFAP_UCBJ_adjustedVOI)
agostino.test(data_L3D_UCBJ_Aneg$GFAP_UCBJ_adjustedVOI) 
agostino.test(data_L3D_UCBJ_healthy$GFAP_UCBJ_adjustedVOI) 
agostino.test(data_L3D_UCBJ_LLD$GFAP_UCBJ_adjustedVOI) 
agostino.test(data_L3D_UCBJ$VAMP2_UCBJ_adjustedVOI)
agostino.test(data_L3D_UCBJ_Aneg$VAMP2_UCBJ_adjustedVOI)
agostino.test(data_L3D_UCBJ_healthy$VAMP2_UCBJ_adjustedVOI)
agostino.test(data_L3D_UCBJ_LLD$VAMP2_UCBJ_adjustedVOI) 

#descriptive statistics ################
# MMSE
median(data_L3D_UCBJ$MMSE) 
IQR(data_L3D_UCBJ$MMSE)
median(data_L3D_UCBJ_Aneg$MMSE) 
IQR(data_L3D_UCBJ_Aneg$MMSE)
median(data_L3D_UCBJ_Apos$MMSE)
IQR(data_L3D_UCBJ_Apos$MMSE)
median(data_L3D_UCBJ_ANA$MMSE) 
IQR(data_L3D_UCBJ_ANA$MMSE)
median(data_L3D_UCBJ_healthy$MMSE) 
IQR(data_L3D_UCBJ_healthy$MMSE)
median(data_L3D_UCBJ_LLD$MMSE) 
IQR(data_L3D_UCBJ_LLD$MMSE)
wilcox.test(data_L3D_UCBJ$MMSE ~ data_L3D_UCBJ$Group) 

# Age
mean(data_L3D_UCBJ$Age) 
sd(data_L3D_UCBJ$Age)
mean(data_L3D_UCBJ_Aneg$Age)
sd(data_L3D_UCBJ_Aneg$Age)
median(data_L3D_UCBJ_Apos$Age) 
IQR(data_L3D_UCBJ_Apos$Age)
median(data_L3D_UCBJ_ANA$Age) 
IQR(data_L3D_UCBJ_ANA$Age)
mean(data_L3D_UCBJ_healthy$Age) 
sd(data_L3D_UCBJ_healthy$Age)
mean(data_L3D_UCBJ_LLD$Age)
sd(data_L3D_UCBJ_LLD$Age)
t.test(data_L3D_UCBJ$Age ~ data_L3D_UCBJ$Group)

#APOE
sum(data_L3D_UCBJ$APOE_binary) 
sum(data_L3D_UCBJ_Aneg$APOE_binary) 
sum(data_L3D_UCBJ_Apos$APOE_binary) 
sum(data_L3D_UCBJ_ANA$APOE_binary) 
sum(data_L3D_UCBJ_healthy$APOE_binary) 
sum(data_L3D_UCBJ_LLD$APOE_binary) 
chisq.test(data_L3D_UCBJ$APOE_binary, data_L3D_UCBJ$Group)

#Sex
sum(data_L3D_UCBJ$Sex_F)
sum(data_L3D_UCBJ_Aneg$Sex_F)
sum(data_L3D_UCBJ_Apos$Sex_F)
sum(data_L3D_UCBJ_ANA$Sex_F) 
sum(data_L3D_UCBJ_healthy$Sex_F) 
sum(data_L3D_UCBJ_LLD$Sex_F) 
chisq.test(data_L3D_UCBJ$Sex_F, data_L3D_UCBJ$Group)

#Education
sum(data_L3D_UCBJ$Education == "primary school") 
sum(data_L3D_UCBJ$Education == "high school") 
sum(data_L3D_UCBJ$Education == "college") 
sum(data_L3D_UCBJ$Education == "university") 
sum(data_L3D_UCBJ_Aneg$Education == "primary school") 
sum(data_L3D_UCBJ_Aneg$Education == "high school") 
sum(data_L3D_UCBJ_Aneg$Education == "college") 
sum(data_L3D_UCBJ_Aneg$Education == "university") 
sum(data_L3D_UCBJ_Apos$Education == "primary school") 
sum(data_L3D_UCBJ_Apos$Education == "high school") 
sum(data_L3D_UCBJ_Apos$Education == "college") 
sum(data_L3D_UCBJ_Apos$Education == "university")
sum(data_L3D_UCBJ_ANA$Education == "primary school") 
sum(data_L3D_UCBJ_ANA$Education == "high school") 
sum(data_L3D_UCBJ_ANA$Education == "college") 
sum(data_L3D_UCBJ_ANA$Education == "university") 
sum(data_L3D_UCBJ_healthy$Education == "primary school") 
sum(data_L3D_UCBJ_healthy$Education == "high school") 
sum(data_L3D_UCBJ_healthy$Education == "college")
sum(data_L3D_UCBJ_healthy$Education == "university") 
sum(data_L3D_UCBJ_LLD$Education == "primary school") 
sum(data_L3D_UCBJ_LLD$Education == "high school") 
sum(data_L3D_UCBJ_LLD$Education == "college") 
sum(data_L3D_UCBJ_LLD$Education == "university") 
chisq.test(data_L3D_UCBJ$Education, data_L3D_UCBJ$Group) 

# Depression
sum(data_L3D_UCBJ$Group == "LLD")
sum(data_L3D_UCBJ_Aneg$Group == "LLD")
sum(data_L3D_UCBJ_Apos$Group == "LLD") 
sum(data_L3D_UCBJ_ANA$Group == "LLD") 

# A status
sum(data_L3D_UCBJ$A_Status == 1) 
sum(data_L3D_UCBJ_healthy$A_Status == 1) 
sum(data_L3D_UCBJ_LLD$A_Status == 1) 

# Tau PET in early metaVOI
mean(data_L3D_UCBJ$MK_SUVR, na.rm =T)
sd(data_L3D_UCBJ$MK_SUVR, na.rm =T)
mean(data_L3D_UCBJ_Aneg$MK_SUVR, na.rm =T)
sd(data_L3D_UCBJ_Aneg$MK_SUVR, na.rm =T)
median(data_L3D_UCBJ_Apos$MK_SUVR, na.rm =T) 
IQR(data_L3D_UCBJ_Apos$MK_SUVR, na.rm =T) 
median(data_L3D_UCBJ_ANA$MK_SUVR, na.rm =T) 
IQR(data_L3D_UCBJ_Aneg$MK_SUVR, na.rm =T) 
mean(data_L3D_UCBJ_healthy$MK_SUVR, na.rm =T) 
sd(data_L3D_UCBJ_healthy$MK_SUVR, na.rm =T) 
mean(data_L3D_UCBJ_ANA$MK_SUVR, na.rm =T) 
sd(data_L3D_UCBJ_Aneg$MK_SUVR, na.rm =T) 
t.test(data_L3D_UCBJ$MK_SUVR ~ data_L3D_UCBJ$Group)

# Amyloid PET in composite cortical VOI
median(data_L3D_UCBJ$A_SUVR, na.rm =T) 
IQR(data_L3D_UCBJ$A_SUVR, na.rm =T)
median(data_L3D_UCBJ_Aneg$A_SUVR, na.rm =T) 
IQR(data_L3D_UCBJ_Aneg$A_SUVR, na.rm =T) 
median(data_L3D_UCBJ_Apos$A_SUVR, na.rm =T) 
IQR(data_L3D_UCBJ_Apos$A_SUVR, na.rm =T)
median(data_L3D_UCBJ_healthy$A_SUVR, na.rm =T) 
IQR(data_L3D_UCBJ_healthy$A_SUVR, na.rm =T)
median(data_L3D_UCBJ_LLD$A_SUVR, na.rm =T) 
IQR(data_L3D_UCBJ_healthy$A_SUVR, na.rm =T) 
data_L3D_UCBJ$Group = as.factor(data_L3D_UCBJ$Group)
wilcox.test(data_L3D_UCBJ$A_SUVR ~ data_L3D_UCBJ$Group)

# amyloid ratio
mean(data_L3D_UCBJ$Abratio, na.rm =T) 
sd(data_L3D_UCBJ$Abratio, na.rm =T) 
mean(data_L3D_UCBJ_Aneg$Abratio, na.rm =T) 
sd(data_L3D_UCBJ_Aneg$Abratio, na.rm =T)
median(data_L3D_UCBJ_Apos$Abratio, na.rm =T) 
IQR(data_L3D_UCBJ_Aneg$Abratio, na.rm =T)
median(data_L3D_UCBJ_ANA$Abratio, na.rm =T) 
IQR(data_L3D_UCBJ_ANA$Abratio, na.rm =T)
mean(data_L3D_UCBJ_healthy$Abratio, na.rm =T)
sd(data_L3D_UCBJ_healthy$Abratio, na.rm =T)
mean(data_L3D_UCBJ_LLD$Abratio, na.rm =T) 
sd(data_L3D_UCBJ_LLD$Abratio, na.rm =T)
t.test(data_L3D_UCBJ$Abratio ~ data_L3D_UCBJ$Group)

#Plasma pTau
median(data_L3D_UCBJ$pT181, na.rm =T) 
IQR(data_L3D_UCBJ$pT181, na.rm =T) 
median(data_L3D_UCBJ_Apos$pT181, na.rm =T)
IQR(data_L3D_UCBJ_Apos$pT181, na.rm =T)
median(data_L3D_UCBJ_ANA$pT181, na.rm =T) 
IQR(data_L3D_UCBJ_ANA$pT181, na.rm =T)
median(data_L3D_UCBJ_healthy$pT181, na.rm =T) 
IQR(data_L3D_UCBJ_healthy$pT181, na.rm =T)
median(data_L3D_UCBJ_LLD$pT181, na.rm =T) 
IQR(data_L3D_UCBJ_LLD$pT181, na.rm =T)
t.test(log(data_L3D_UCBJ$pT181) ~ data_L3D_UCBJ$Group) 

#Plasma GFAP
mean(data_L3D_UCBJ$GFAP, na.rm =T)
sd(data_L3D_UCBJ$GFAP, na.rm =T) 
median(data_L3D_UCBJ_Aneg$GFAP, na.rm =T) 
IQR(data_L3D_UCBJ_Aneg$GFAP, na.rm =T)
median(data_L3D_UCBJ_Apos$GFAP, na.rm =T) 
IQR(data_L3D_UCBJ_Apos$GFAP, na.rm =T) 
median(data_L3D_UCBJ_ANA$GFAP, na.rm =T)
IQR(data_L3D_UCBJ_ANA$GFAP, na.rm =T)
mean(data_L3D_UCBJ_healthy$GFAP, na.rm =T) 
sd(data_L3D_UCBJ_healthy$GFAP, na.rm =T)
mean(data_L3D_UCBJ_LLD$GFAP, na.rm =T) 
sd(data_L3D_UCBJ_LLD$GFAP, na.rm =T)
t.test(data_L3D_UCBJ$GFAP ~ data_L3D_UCBJ$Group) 

#Plasma NfL
median(data_L3D_UCBJ$NfL, na.rm =T) 
IQR(data_L3D_UCBJ$NfL, na.rm =T) 
median(data_L3D_UCBJ_Aneg$NfL, na.rm =T) 
IQR(data_L3D_UCBJ_Aneg$NfL, na.rm =T) 
median(data_L3D_UCBJ_Apos$NfL, na.rm =T) 
IQR(data_L3D_UCBJ_Apos$NfL, na.rm =T)
median(data_L3D_UCBJ_ANA$NfL, na.rm =T) 
IQR(data_L3D_UCBJ_ANA$NfL, na.rm =T)
median(data_L3D_UCBJ_healthy$NfL) 
IQR(data_L3D_UCBJ_healthy$NfL) 
median(data_L3D_UCBJ_LLD$NfL) 
IQR(data_L3D_UCBJ_LLD$NfL)
t.test(log(data_L3D_UCBJ$NfL) ~ data_L3D_UCBJ$Group)

#Plasma VAMP2
median(data_L3D_UCBJ$VAMP2) 
IQR(data_L3D_UCBJ$VAMP2, na.rm =T)
median(data_L3D_UCBJ_Aneg$VAMP2) 
IQR(data_L3D_UCBJ_Aneg$VAMP2, na.rm =T)
median(data_L3D_UCBJ_Apos$VAMP2) #67.44117
IQR(data_L3D_UCBJ_Apos$VAMP2, na.rm =T) 
median(data_L3D_UCBJ_ANA$VAMP2)
IQR(data_L3D_UCBJ_ANA$VAMP2, na.rm =T) 
median(data_L3D_UCBJ_healthy$VAMP2) 
IQR(data_L3D_UCBJ_healthy$VAMP2, na.rm =T)
median(data_L3D_UCBJ_LLD$VAMP2)
IQR(data_L3D_UCBJ_LLD$VAMP2, na.rm =T) 
wilcox.test(data_L3D_UCBJ$VAMP2 ~ data_L3D_UCBJ$Group)

#Plasma SNAP25
median(data_L3D_UCBJ$SNAP25, na.rm =T) 
IQR(data_L3D_UCBJ$SNAP25, na.rm =T) 
median(data_L3D_UCBJ_Apos$SNAP25) 
IQR(data_L3D_UCBJ_Apos$SNAP25, na.rm =T) 
median(data_L3D_UCBJ_ANA$SNAP25) 
IQR(data_L3D_UCBJ_ANA$SNAP25, na.rm =T)
mean(data_L3D_UCBJ_healthy$SNAP25) 
sd(data_L3D_UCBJ_healthy$SNAP25)
mean(data_L3D_UCBJ_LLD$SNAP25) 
sd(data_L3D_UCBJ_LLD$SNAP25) 
t.test(data_L3D_UCBJ$SNAP25 ~ data_L3D_UCBJ$Group)

#GFAP UCBJ
mean(data_L3D_UCBJ$GFAP_UCBJ_adjustedVOI) #5.3196
sd(data_L3D_UCBJ$GFAP_UCBJ_adjustedVOI) #0.7622824
mean(data_L3D_UCBJ_Aneg$GFAP_UCBJ_adjustedVOI) #5.317195
sd(data_L3D_UCBJ_Aneg$GFAP_UCBJ_adjustedVOI) #0.747935
median(data_L3D_UCBJ_Apos$GFAP_UCBJ_adjustedVOI) 
IQR(data_L3D_UCBJ_Apos$GFAP_UCBJ_adjustedVOI) 
median(data_L3D_UCBJ_ANA$GFAP_UCBJ_adjustedVOI)
IQR(data_L3D_UCBJ_ANA$GFAP_UCBJ_adjustedVOI)
mean(data_L3D_UCBJ_healthy$GFAP_UCBJ_adjustedVOI) 
sd(data_L3D_UCBJ_healthy$GFAP_UCBJ_adjustedVOI) 
mean(data_L3D_UCBJ_LLD$GFAP_UCBJ_adjustedVOI) 
sd(data_L3D_UCBJ_LLD$GFAP_UCBJ_adjustedVOI)
t.test(data_L3D_UCBJ$GFAP_UCBJ_adjustedVOI ~ data_L3D_UCBJ$Group) 

#VAMP2 UCBJ
mean(data_L3D_UCBJ$VAMP2_UCBJ_adjustedVOI) 
sd(data_L3D_UCBJ$VAMP2_UCBJ_adjustedVOI)
mean(data_L3D_UCBJ_Aneg$VAMP2_UCBJ_adjustedVOI) 
sd(data_L3D_UCBJ_Aneg$VAMP2_UCBJ_adjustedVOI) 
median(data_L3D_UCBJ_Apos$VAMP2_UCBJ_adjustedVOI) 
IQR(data_L3D_UCBJ_Apos$VAMP2_UCBJ_adjustedVOI) 
median(data_L3D_UCBJ_ANA$VAMP2_UCBJ_adjustedVOI)
IQR(data_L3D_UCBJ_ANA$VAMP2_UCBJ_adjustedVOI)
mean(data_L3D_UCBJ_healthy$VAMP2_UCBJ_adjustedVOI)
sd(data_L3D_UCBJ_healthy$VAMP2_UCBJ_adjustedVOI) 
mean(data_L3D_UCBJ_LLD$VAMP2_UCBJ_adjustedVOI)
sd(data_L3D_UCBJ_LLD$VAMP2_UCBJ_adjustedVOI) 
t.test(data_L3D_UCBJ$VAMP2_UCBJ_adjustedVOI ~ data_L3D_UCBJ$Group)

#NfL UCB-J
agostino.test(data_L3D_UCBJ$NfL_UCBJ_adjustedVOI) 
mean(data_L3D_UCBJ$NfL_UCBJ_adjustedVOI) 
sd(data_L3D_UCBJ$NfL_UCBJ_adjustedVOI) 

################################################################################
# B. Correlations between plasma biomarkers
################################################################################
set.seed(123)

spearman.ci(data_L3D_UCBJ$pT181, data_L3D_UCBJ$GFAP, nrep = 1000, conf.level = 0.95)
cor.test(data_L3D_UCBJ$pT181, data_L3D_UCBJ$GFAP, method = "spearman") 
spearman.ci(data_L3D_UCBJ$NfL, data_L3D_UCBJ$GFAP, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$NfL, data_L3D_UCBJ$GFAP, method = "spearman") 
spearman.ci(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$GFAP, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$GFAP, method = "spearman")
spearman.ci(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$GFAP, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$GFAP, method = "spearman") 
spearman.ci(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$GFAP, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$GFAP, method = "spearman") 

spearman.ci(data_L3D_UCBJ$NfL, data_L3D_UCBJ$pT181, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$NfL, data_L3D_UCBJ$pT181, method = "spearman")
spearman.ci(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$pT181, nrep = 1000, conf.level = 0.95)
cor.test(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$pT181, method = "spearman") 
spearman.ci(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$pT181, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$pT181, method = "spearman") 
spearman.ci(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$pT181, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$pT181, method = "spearman")

spearman.ci(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$NfL, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$NfL, method = "spearman")
spearman.ci(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$NfL, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$NfL, method = "spearman")
spearman.ci(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$NfL, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$NfL, method = "spearman")

spearman.ci(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$Abratio, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$Abratio, method = "spearman") 

spearman.ci(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$Abratio, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$Abratio, method = "spearman") 
spearman.ci(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$SNAP25, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$SNAP25, method = "spearman") 

# Graph of synaptic biomarker correlations
VAMP2_SNAP25 <- ggplot(data = data_L3D_UCBJ, aes(x = VAMP2, y = SNAP25)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", colour = "black")+ 
  theme_few() + 
  theme(legend.position = "none") +
  xlab("Plasma VAMP2, pg/mL") + 
  ylab("Plasma SNAP25, pg/mL")
VAMP2_SNAP25

# Construct correlation matrix
"Plasma pTau181" = data_L3D_UCBJ$pT181
"Plasma GFAP" = data_L3D_UCBJ$GFAP
"Plasma NfL" = data_L3D_UCBJ$NfL
"Plasma Aβ1-42/Aβ1-40" = data_L3D_UCBJ$Abratio
"Plasma SNAP25" = data_L3D_UCBJ$SNAP25
"Plasma VAMP2" = data_L3D_UCBJ$VAMP2

data_L3D_UCBJ <- as_tibble(data_L3D_UCBJ)
Correlationdata_L3D <- data_L3D_UCBJ[, c(3,2,7,8,6,9)]
#Correlationdata_L3D <- data_L3D_UCBJ %>% select(5, 6, 9, 10, 11, 12)
Correlationdata_L3D <-as.matrix(Correlationdata_L3D) #the function "corrplot()" requires data matrix, not a tibble.
Correlationdata_L3D
# Source of corr.test: https://benwhalley.github.io/just-enough-r/correlations.html
# Note that p-values are Holm corrected by default: https://www.rdocumentation.org/packages/psych/versions/2.0.7/topics/corr.test
# What adjustment for multiple tests should be used? ("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"). See p.adjust for details about why to use "holm" rather than "bonferroni").
# Issue with NA: use = "complete.obs", then you lose information as it only takes the values of n=158: http://www.sthda.com/english/wiki/correlation-matrix-a-quick-start-guide-to-analyze-format-and-visualize-a-correlation-matrix-using-r-software
# Better use = "pairwise": This ensures that you can calculate the correlation for every pair of variables without losing information because of missing values in the other variables. Source: https://www.dummies.com/programming/r/how-to-deal-with-missing-data-values-in-r/

mycorrelations_L3D <- psych::corr.test(Correlationdata_L3D, method = "spearman", adjust= "none",  use = "pairwise.complete.obs", ci=TRUE) #na.action = "na.exclude",
mycorrelations_L3D

# COEFFICIENTS
# Add all p-values in black and color is coefficient strength GOOD resolution
setwd ("C:/Users/u0115549/Documents/01_Projects/05_L3D/02_Analysis/")
tiff(height=13.6, width=17, unit = "cm", pointsize=12, file="CorrelationMatrix_L3D_R1.tiff", res=400) # when res=800 added, then dimension need to be increased but in condenses the plot
mycorrelations_L3D
corrplot(mycorrelations_L3D$r,insig = "n", p.mat = mycorrelations_L3D$p, sig.level = -1, number.digits = 2, method = "color", addCoef.col="black", type = "upper", tl.col = "black", tl.srt = 45)


################################################################################
# C. Association with demographics
################################################################################

# C1.Age ###########################################################################
set.seed(123)
spearman.ci(data_L3D_UCBJ$GFAP, data_L3D_UCBJ$Age, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$GFAP, data_L3D_UCBJ$Age, method = "spearman") 
spearman.ci(data_L3D_UCBJ$NfL, data_L3D_UCBJ$Age, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$NfL, data_L3D_UCBJ$Age, method = "spearman")
spearman.ci(data_L3D_UCBJ$pT181, data_L3D_UCBJ$Age, nrep = 1000, conf.level = 0.95)
cor.test(data_L3D_UCBJ$pT181, data_L3D_UCBJ$Age, method = "spearman") 
spearman.ci(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$Age, nrep = 1000, conf.level = 0.95)
cor.test(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$Age, method = "spearman") 
spearman.ci(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$Age, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$Age, method = "spearman") 
spearman.ci(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$Age, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$Age, method = "spearman") 

# C2. Sex
wilcox.test(data = data_L3D_UCBJ, GFAP ~ Sex_F) 
wilcox.test(data = data_L3D_UCBJ, NfL ~ Sex_F) 
wilcox.test(data = data_L3D_UCBJ, pT181 ~ Sex_F) 
wilcox.test(data = data_L3D_UCBJ, Abratio ~ Sex_F) 
wilcox.test(data = data_L3D_UCBJ, SNAP25 ~ Sex_F)
wilcox.test(data = data_L3D_UCBJ, VAMP2 ~ Sex_F) 


# C3. APOE
wilcox.test(data = data_L3D_UCBJ, GFAP ~ APOE_binary) 
wilcox.test(data = data_L3D_UCBJ, NfL ~ APOE_binary) 
wilcox.test(data = data_L3D_UCBJ, pT181 ~ APOE_binary) 
wilcox.test(data = data_L3D_UCBJ, Abratio ~ APOE_binary) 
wilcox.test(data = data_L3D_UCBJ, SNAP25 ~ APOE_binary) 
wilcox.test(data = data_L3D_UCBJ, VAMP2 ~ APOE_binary)

# C4. Education
data_L3D_UCBJ$Education = as.factor(data_L3D_UCBJ$Education)
kruskal.test(data_L3D_UCBJ$VAMP2, data_L3D_UCBJ$Education) 
kruskal.test(data_L3D_UCBJ$SNAP25, data_L3D_UCBJ$Education) 
kruskal.test(data_L3D_UCBJ$GFAP, data_L3D_UCBJ$Education) 
kruskal.test(data_L3D_UCBJ$NfL, data_L3D_UCBJ$Education) 
kruskal.test(data_L3D_UCBJ$Abratio, data_L3D_UCBJ$Education) 
kruskal.test(data_L3D_UCBJ$pT181, data_L3D_UCBJ$Education) 

################################################################################
# D. Correlations of plasma biomarkers with AD pathology
################################################################################
# D1. AMYLOID PATHOLOGY #########################################################
## Distribution of amyloid pathology
h_amy <- hist(x = data_L3D_UCBJ$A_SUVR, prob = F, breaks = 20, main = NA, xlab = "Amyloid PET load, SUVR", col = "lightblue") 
abline(v = 1.38, col = "red")

#Correlations
set.seed(123)
spearman.ci(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$GFAP, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$GFAP, method = "spearman") 
spearman.ci(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$VAMP2, nrep = 1000, conf.level = 0.95)  
cor.test(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$VAMP2, method = "spearman")
spearman.ci(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$SNAP25, nrep = 1000, conf.level = 0.95)
cor.test(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$SNAP25, method = "spearman") 
spearman.ci(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$Abratio, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$Abratio, method = "spearman") 
spearman.ci(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$pT181, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$pT181, method = "spearman") 
spearman.ci(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$NfL, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$A_SUVR, data_L3D_UCBJ$NfL, method = "spearman") 


# D2. TAU PATHOLOGY #########################################################
h_tau <- hist(x = data_L3D_UCBJ$MK_SUVR, prob = F, breaks = 20, main = NA, xlab = "Tau PET load, SUVR", col = "lightgreen")

#Correlations
set.seed(123)
spearman.ci(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$GFAP, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$GFAP, method = "spearman")
spearman.ci(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$pT181, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$pT181, method = "spearman") 
spearman.ci(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$NfL, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$NfL, method = "spearman")
spearman.ci(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$Abratio, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$Abratio, method = "spearman")
spearman.ci(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$SNAP25, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$SNAP25, method = "spearman")
spearman.ci(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$VAMP2, nrep = 1000, conf.level = 0.95) 
cor.test(data_L3D_UCBJ$MK_SUVR, data_L3D_UCBJ$VAMP2, method = "spearman")

################################################################################
# E. Associations between plasma biomarkers vs synaptic density
################################################################################

#E1. Entire study population ###################################################
# Linear regression models - adjusted for age 
lm_VAMP2_UCBJ_all <- lm(data = data_L3D_UCBJ, VAMP2_UCBJ_adjustedVOI ~ VAMP2_z)
summary(lm_VAMP2_UCBJ_all) 
confint(lm_VAMP2_UCBJ_all) 
lm_GFAP_UCBJ_all <- lm(data = data_L3D_UCBJ, GFAP_UCBJ_adjustedVOI ~ GFAP_z)
summary(lm_GFAP_UCBJ_all) 
confint(lm_GFAP_UCBJ_all) 

lm_NfL_UCBJ_all <- lm(data = data_L3D_UCBJ, NfL_UCBJ_adjustedVOI ~ NfL_z)
summary(lm_NfL_UCBJ_all) 
confint(lm_NfL_UCBJ_all) 

# Linear regression models - unadjusted for age 
lm_VAMP2_UCBJ_all_unadj <- lm(data = data_L3D_UCBJ, VAMP2_UCBJ_unadjustedVOI ~ VAMP2_z)
summary(lm_VAMP2_UCBJ_all_unadj) 
confint(lm_VAMP2_UCBJ_all_unadj) 

lm_GFAP_UCBJ_all_unadj <- lm(data = data_L3D_UCBJ, GFAP_UCBJ_unadjustedVOI ~ GFAP_z)
summary(lm_GFAP_UCBJ_all_unadj) 
confint(lm_GFAP_UCBJ_all_unadj)

# Plots 
VAMP_UCBJ <- ggplot(data = data_L3D_UCBJ, aes(x = VAMP2, y = VAMP2_UCBJ_adjustedVOI)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", colour = "black")+ 
  theme_few() + 
  theme(legend.position = "none") +
  xlab("Plasma VAMP2, pg/mL") + 
  ylab("SV2A density, SUVR") + 
  xlim(0,200)
VAMP_UCBJ

GFAP_UCBJ <- ggplot(data = data_L3D_UCBJ, aes(x = GFAP, y = GFAP_UCBJ_adjustedVOI)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", colour = "black")+ 
  theme_few() + 
  theme(legend.position = "none") +
  xlab("Plasma GFAP, pg/mL") + 
  ylab("SV2A density, SUVR") +
  xlim(0,220)
GFAP_UCBJ

NfL_UCBJ <- ggplot(data = data_L3D_UCBJ, aes(x = NfL, y = NfL_UCBJ_adjustedVOI)) +
  geom_point(color = "black") +
  geom_smooth(method = "lm", colour = "black")+ 
  theme_few() + 
  theme(legend.position = "none") +
  xlab("Plasma NfL, pg/mL") + 
  ylab("SV2A density, SUVR")
NfL_UCBJ

# E2. Non-depressed older adults (CU) ############################################
# Linear regression models 
lm_VAMP2_UCBJ_healthy <- lm(data = data_L3D_UCBJ_healthy, VAMP2_UCBJ_adjustedVOI  ~  VAMP2_z)
summary(lm_VAMP2_UCBJ_healthy) 
confint(lm_VAMP2_UCBJ_healthy) 

lm_GFAP_UCBJ_healthy <- lm(data = data_L3D_UCBJ_healthy, GFAP_UCBJ_adjustedVOI  ~  GFAP_z)
summary(lm_GFAP_UCBJ_healthy) 
confint(lm_GFAP_UCBJ_healthy) 

# E3. Amyloid-negative older adults ##############################################
# Linear regression models 
lm_VAMP2_UCBJ_Aneg <- lm(data = data_L3D_UCBJ_Aneg, VAMP2_UCBJ_adjustedVOI  ~  VAMP2_z)
summary(lm_VAMP2_UCBJ_Aneg)
confint(lm_VAMP2_UCBJ_Aneg)

lm_GFAP_UCBJ_Aneg <- lm(data = data_L3D_UCBJ_Aneg, GFAP_UCBJ_adjustedVOI  ~  GFAP_z)
summary(lm_GFAP_UCBJ_Aneg) 
confint(lm_GFAP_UCBJ_Aneg)

################################################################################
# F. Predictive value of GM volume for plasma biomarker levels
################################################################################
# F1. Entire study population ####################################################
# Multiple linear regression model 
lm_GM_VAMP2_all <- lm(data = data_L3D_UCBJ, lnVAMP2_z ~ VAMP2_GM_adjustedVOI_norm+ Age + Sex_F)
summary(lm_GM_VAMP2_all) 
confint(lm_GM_VAMP2_all) 

lm_GM_GFAP_all <- lm(data = data_L3D_UCBJ, GFAP_z ~ GFAP_GM_adjustedVOI_norm+ Age + Sex_F)
summary(lm_GM_GFAP_all) 
confint(lm_GM_GFAP_all) 


# F2. Non-depressed subset ####################################################

lm_GM_VAMP2_healthy <- lm(data = data_L3D_UCBJ_healthy, lnVAMP2_z  ~  VAMP2_GM_adjustedVOI_norm+ Age + Sex_F)
summary(lm_GM_VAMP2_healthy) 
confint(lm_GM_VAMP2_healthy) 

lm_GM_GFAP_healthy <- lm(data = data_L3D_UCBJ_healthy, GFAP_z ~ GFAP_GM_adjustedVOI_norm+ Age + Sex_F)
summary(lm_GM_GFAP_healthy) 
confint(lm_GM_GFAP_healthy) 

# F3. Amyloid-negative subset ####################################################
lm_GM_VAMP2_Aneg <- lm(data = data_L3D_UCBJ_Aneg, lnVAMP2_z  ~  VAMP2_GM_adjustedVOI_norm+ Age + Sex_F)
agostino.test(resid(lm_GM_VAMP2_all))
summary(lm_GM_VAMP2_Aneg) 
confint(lm_GM_VAMP2_Aneg)

lm_GM_GFAP_Aneg <- lm(data = data_L3D_UCBJ_Aneg, GFAP_z ~ GFAP_GM_adjustedVOI_norm+ Age + Sex_F)
summary(lm_GM_GFAP_Aneg) 
confint(lm_GM_GFAP_Aneg) 

################################################################################
# G. MEDIATION ANALYSIS
################################################################################
#DOES GM MEDIATE THE RELATIONSHIP OF GFAP WITH SYNAPTIC DENSITY?

# G1. In entire study population ##############################################
set.seed(123)
mediation_model_GFAP_reverse <- '
#Direct effect
GFAP_GM_adjustedVOI_norm ~ a*GFAP_UCBJ_adjustedVOI + Age + Sex_F
GFAP_z ~ c*GFAP_UCBJ_adjustedVOI + b*GFAP_GM_adjustedVOI_norm

#Indirect effect
indirect := a*b

#Total effect (c+indirect)
total := c + indirect
'
set.seed(123)
mediation_results_reverse <- sem(mediation_model_GFAP_reverse, data = data_L3D_UCBJ, se = "bootstrap", bootstrap = 1000)
summary(mediation_results_reverse, standardized = TRUE, fit.measures = TRUE, ci = TRUE)

formatted_results <- parameterEstimates(mediation_results_reverse)
formatted_results[] <- lapply(formatted_results, function(x) if (is.numeric(x)) sprintf("%.6f", x) else x)
print(formatted_results)

# G2. In nondepressed subset ##############################################
set.seed(123)
mediation_model_GFAP_reverse_healthy <- '
#Direct effect
GFAP_GM_adjustedVOI_norm ~ a*GFAP_UCBJ_adjustedVOI + Age + Sex_F
GFAP_z ~ c*GFAP_UCBJ_adjustedVOI + b*GFAP_GM_adjustedVOI_norm

#Indirect effect
indirect := a*b

#Total effect (c+indirect)
total := c + indirect
'
mediation_results_reverse_healthy <- sem(mediation_model_GFAP_reverse_healthy, data = data_L3D_UCBJ_healthy, se = "bootstrap", bootstrap = 1000)
summary(mediation_results_reverse_healthy, standardized = TRUE, fit.measures = TRUE, ci = TRUE)
formatted_results_healthy <- parameterEstimates(mediation_results_reverse_healthy)
formatted_results_healthy[] <- lapply(formatted_results_healthy, function(x) if (is.numeric(x)) sprintf("%.6f", x) else x)
print(formatted_results_healthy)

#G3. In amyloid negative subset ########################################
set.seed(123)
mediation_model_GFAP_reverse_Aneg <- '
#Direct effect
GFAP_GM_adjustedVOI_norm ~ a*GFAP_UCBJ_adjustedVOI + Age + Sex_F
GFAP_z ~ c*GFAP_UCBJ_adjustedVOI + b*GFAP_GM_adjustedVOI_norm

#Indirect effect
indirect := a*b

#Total effect (c+indirect)
total := c + indirect
'
mediation_results_reverse_Aneg <- sem(mediation_model_GFAP_reverse_Aneg, data = data_L3D_UCBJ_Aneg, se = "bootstrap", bootstrap = 1000)
summary(mediation_results_reverse_Aneg, standardized = TRUE, fit.measures = TRUE, ci = TRUE)

formatted_results_Aneg <- parameterEstimates(mediation_results_reverse_Aneg)
formatted_results_Aneg[] <- lapply(formatted_results_Aneg, function(x) if (is.numeric(x)) sprintf("%.6f", x) else x)
print(formatted_results_Aneg)

##################################################################################
# H. Check all model assumptions
#################################################################################
check_model(lm_VAMP2_UCBJ_all)
check_model(lm_GFAP_UCBJ_all)
check_model(lm_NfL_UCBJ_all)
check_model(lm_VAMP2_UCBJ_all_unadj)
check_model(lm_GFAP_UCBJ_all_unadj)
check_model(lm_VAMP2_UCBJ_healthy)
check_model(lm_GFAP_UCBJ_healthy)
check_model(lm_VAMP2_UCBJ_Aneg)
check_model(lm_GFAP_UCBJ_Aneg)
check_model(lm_GM_VAMP2_all)
check_model(lm_GM_GFAP_all)
check_model(lm_GM_VAMP2_healthy)
check_model(lm_GM_GFAP_healthy)
check_model(lm_GM_VAMP2_Aneg)
check_model(lm_GM_GFAP_Aneg)

# Run nice_assumptions() for each model
assumptions_UCBJ_vamp2_all <- nice_assumptions(lm_VAMP2_UCBJ_all)
assumptions_UCBJ_gfap_all <- nice_assumptions(lm_GFAP_UCBJ_all)
assumptions_UCBJ_NfL_all <- nice_assumptions(lm_NfL_UCBJ_all)
assumptions_UCBJ_vamp2_healthy <- nice_assumptions(lm_VAMP2_UCBJ_healthy)
assumptions_UCBJ_gfap_healthy <- nice_assumptions(lm_GFAP_UCBJ_healthy)
assumptions_UCBJ_vamp2_Aneg <- nice_assumptions(lm_VAMP2_UCBJ_Aneg)
assumptions_UCBJ_gfap_Aneg  <- nice_assumptions(lm_GFAP_UCBJ_Aneg)

assumptions_GM_vamp2_all <- nice_assumptions(lm_GM_VAMP2_all)
assumptions_GM_gfap_all <- nice_assumptions(lm_GM_GFAP_all)
assumptions_GM_vamp2_healthy <- nice_assumptions(lm_GM_VAMP2_healthy)
assumptions_GM_gfap_healthy <- nice_assumptions(lm_GM_GFAP_healthy)
assumptions_GM_vamp2_Aneg <- nice_assumptions(lm_GM_VAMP2_Aneg)
assumptions_GM_gfap_Aneg  <- nice_assumptions(lm_GM_GFAP_Aneg)

# Add model names as identifiers
assumptions_UCBJ_vamp2_all <- assumptions_UCBJ_vamp2_all %>% mutate(Cohort = "All")
assumptions_UCBJ_gfap_all <- assumptions_UCBJ_gfap_all %>% mutate(Cohort = "All")
assumptions_UCBJ_NfL_all <- assumptions_UCBJ_NfL_all %>% mutate(Cohort = "All")
assumptions_UCBJ_vamp2_healthy <- assumptions_UCBJ_vamp2_healthy %>% mutate(Cohort = "Healthy")
assumptions_UCBJ_gfap_healthy <- assumptions_UCBJ_gfap_healthy %>% mutate(Cohort = "Healthy")
assumptions_UCBJ_vamp2_Aneg <- assumptions_UCBJ_vamp2_Aneg %>% mutate(Cohort = "Aβ-negative")
assumptions_UCBJ_gfap_Aneg <- assumptions_UCBJ_gfap_Aneg %>% mutate(Cohort = "Aβ-negative")

assumptions_GM_vamp2_all <- assumptions_GM_vamp2_all %>% mutate(Cohort = "All")
assumptions_GM_gfap_all <- assumptions_GM_gfap_all %>% mutate(Cohort = "All")
assumptions_GM_vamp2_healthy <- assumptions_GM_vamp2_healthy %>% mutate(Cohort = "Healthy")
assumptions_GM_gfap_healthy <- assumptions_GM_gfap_healthy %>% mutate(Cohort = "Healthy")
assumptions_GM_vamp2_Aneg <- assumptions_GM_vamp2_Aneg %>% mutate(Cohort = "Aβ-negative")
assumptions_GM_gfap_Aneg <- assumptions_GM_gfap_Aneg %>% mutate(Cohort = "Aβ-negative")

# Combine all tables into one
assumptions_combined <- bind_rows(
  assumptions_UCBJ_vamp2_all,
  assumptions_UCBJ_gfap_all,
  assumptions_UCBJ_NfL_all,
  assumptions_UCBJ_vamp2_healthy,
  assumptions_UCBJ_gfap_healthy,
  assumptions_UCBJ_vamp2_Aneg,
  assumptions_UCBJ_gfap_Aneg,
  assumptions_GM_vamp2_all,
  assumptions_GM_gfap_all,
  assumptions_GM_vamp2_healthy,
  assumptions_GM_gfap_healthy,
  assumptions_GM_vamp2_Aneg,
  assumptions_GM_gfap_Aneg
)

# View the combined table
View(assumptions_combined)

##################################################################################
# I. Influence of medication
#################################################################################
data_L3D_UCBJ_LLD = subset(data_L3D_UCBJ, Group == "LLD")

data_L3D_UCBJ_LLD$anticholinergics = as.factor(data_L3D_UCBJ_LLD$anticholinergics)
data_L3D_UCBJ_LLD$antipsychotics = as.factor(data_L3D_UCBJ_LLD$antipsychotics)
data_L3D_UCBJ_LLD$antidepressants = as.factor(data_L3D_UCBJ_LLD$antidepressants)
data_L3D_UCBJ_LLD$benzodiazepin = as.factor(data_L3D_UCBJ_LLD$benzodiazepin)
data_L3D_UCBJ_LLD$opiates = as.factor(data_L3D_UCBJ_LLD$opiates)

wilcox.test(data_L3D_UCBJ_LLD$GFAP ~ data_L3D_UCBJ_LLD$anticholinergics) 
wilcox.test(data_L3D_UCBJ_LLD$VAMP2 ~ data_L3D_UCBJ_LLD$anticholinergics) 
wilcox.test(data_L3D_UCBJ_LLD$SNAP25 ~ data_L3D_UCBJ_LLD$anticholinergics)
wilcox.test(data_L3D_UCBJ_LLD$NfL ~ data_L3D_UCBJ_LLD$anticholinergics) 
wilcox.test(data_L3D_UCBJ_LLD$Abratio ~ data_L3D_UCBJ_LLD$anticholinergics) 
wilcox.test(data_L3D_UCBJ_LLD$pT181 ~ data_L3D_UCBJ_LLD$anticholinergics) 

wilcox.test(data_L3D_UCBJ_LLD$GFAP ~ data_L3D_UCBJ_LLD$antipsychotics) 
wilcox.test(data_L3D_UCBJ_LLD$VAMP2 ~ data_L3D_UCBJ_LLD$antipsychotics) 
wilcox.test(data_L3D_UCBJ_LLD$SNAP25 ~ data_L3D_UCBJ_LLD$antipsychotics)
wilcox.test(data_L3D_UCBJ_LLD$NfL ~ data_L3D_UCBJ_LLD$antipsychotics) 
wilcox.test(data_L3D_UCBJ_LLD$Abratio ~ data_L3D_UCBJ_LLD$antipsychotics)
wilcox.test(data_L3D_UCBJ_LLD$pT181 ~ data_L3D_UCBJ_LLD$antipsychotics)

wilcox.test(data_L3D_UCBJ_LLD$GFAP ~ data_L3D_UCBJ_LLD$antidepressants) 
wilcox.test(data_L3D_UCBJ_LLD$VAMP2 ~ data_L3D_UCBJ_LLD$antidepressants) 
wilcox.test(data_L3D_UCBJ_LLD$SNAP25 ~ data_L3D_UCBJ_LLD$antidepressants) 
wilcox.test(data_L3D_UCBJ_LLD$NfL ~ data_L3D_UCBJ_LLD$antidepressants) 
wilcox.test(data_L3D_UCBJ_LLD$Abratio ~ data_L3D_UCBJ_LLD$antidepressants) 
wilcox.test(data_L3D_UCBJ_LLD$pT181 ~ data_L3D_UCBJ_LLD$antidepressants)

wilcox.test(data_L3D_UCBJ_LLD$GFAP ~ data_L3D_UCBJ_LLD$benzodiazepin) 
wilcox.test(data_L3D_UCBJ_LLD$VAMP2 ~ data_L3D_UCBJ_LLD$benzodiazepin) 
wilcox.test(data_L3D_UCBJ_LLD$SNAP25 ~ data_L3D_UCBJ_LLD$benzodiazepin) 
wilcox.test(data_L3D_UCBJ_LLD$NfL ~ data_L3D_UCBJ_LLD$benzodiazepin) 
wilcox.test(data_L3D_UCBJ_LLD$Abratio ~ data_L3D_UCBJ_LLD$benzodiazepin) 
wilcox.test(data_L3D_UCBJ_LLD$pT181 ~ data_L3D_UCBJ_LLD$benzodiazepin)

wilcox.test(data_L3D_UCBJ_LLD$GFAP ~ data_L3D_UCBJ_LLD$opiates) 
wilcox.test(data_L3D_UCBJ_LLD$VAMP2 ~ data_L3D_UCBJ_LLD$opiates) 
wilcox.test(data_L3D_UCBJ_LLD$SNAP25 ~ data_L3D_UCBJ_LLD$opiates) 
wilcox.test(data_L3D_UCBJ_LLD$NfL ~ data_L3D_UCBJ_LLD$opiates) 
wilcox.test(data_L3D_UCBJ_LLD$Abratio ~ data_L3D_UCBJ_LLD$opiates) 
wilcox.test(data_L3D_UCBJ_LLD$pT181 ~ data_L3D_UCBJ_LLD$opiates)

median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$anticholinergics == 0]) 
median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$anticholinergics == 1]) 
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$anticholinergics == 0])
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$anticholinergics == 1]) 
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$anticholinergics == 0])
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$anticholinergics == 1]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$anticholinergics == 0]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$anticholinergics == 1]) 
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$anticholinergics == 0])
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$anticholinergics == 1]) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$anticholinergics == 0], na.rm = T) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$anticholinergics == 1], na.rm = T) 

median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$antipsychotics == 0]) 
median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$antipsychotics == 1]) 
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$antipsychotics == 0]) 
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$antipsychotics == 1]) 
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$antipsychotics == 0]) 
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$antipsychotics == 1]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$antipsychotics == 0]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$antipsychotics == 1]) 
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$antipsychotics == 0]) 
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$antipsychotics == 1]) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$antipsychotics == 0], na.rm = T) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$antipsychotics == 1], na.rm = T)

median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$antidepressants == 0]) 
median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$antidepressants == 1])
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$antidepressants == 0]) 
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$antidepressants == 1]) 
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$antidepressants == 0]) 
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$antidepressants == 1])
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$antidepressants == 0]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$antidepressants == 1])
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$antidepressants == 0])
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$antidepressants == 1]) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$antidepressants == 0], na.rm = T) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$antidepressants == 1], na.rm = T) 

median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$benzodiazepin == 0]) 
median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$benzodiazepin == 1]) 
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$benzodiazepin == 0])
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$benzodiazepin == 1]) 
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$benzodiazepin == 0]) 
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$benzodiazepin == 1]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$benzodiazepin == 0]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$benzodiazepin == 1]) 
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$benzodiazepin == 0])
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$benzodiazepin == 1])
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$benzodiazepin == 0], na.rm = T) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$benzodiazepin == 1], na.rm = T) 

median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$opiates == 0])
median(data_L3D_UCBJ_LLD$GFAP[data_L3D_UCBJ_LLD$opiates == 1]) 
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$opiates == 0])
median(data_L3D_UCBJ_LLD$VAMP2[data_L3D_UCBJ_LLD$opiates == 1]) 
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$opiates == 0])
median(data_L3D_UCBJ_LLD$SNAP25[data_L3D_UCBJ_LLD$opiates == 1]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$opiates == 0]) 
median(data_L3D_UCBJ_LLD$NfL[data_L3D_UCBJ_LLD$opiates == 1])
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$opiates == 0]) 
median(data_L3D_UCBJ_LLD$Abratio[data_L3D_UCBJ_LLD$opiates == 1]) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$opiates == 0], na.rm = T) 
median(data_L3D_UCBJ_LLD$pT181[data_L3D_UCBJ_LLD$opiates == 1], na.rm = T) 


