#Goal is to write a program to test every combination of regressor to chose the highest adjusted R-sqaured value
#BEST ADJUSTED R SQUARED value for a fixed outcome and regressor

memdex <- null
fitmem <- null
bars <- function(outcome,regressors) {
       #Removing mpg and am from regressor list since they are necessary for our purposes
       regressors <- names(mtcars)[c(2:8,10:11)]
       
       #Generating a binary matrix for using each regressor or not in a grid matrix
       usematrix <- expand.grid(c(TRUE,FALSE), c(TRUE,FALSE),
                             c(TRUE,FALSE), c(TRUE,FALSE),c(TRUE,FALSE), c(TRUE,FALSE),
                             c(TRUE,FALSE), c(TRUE,FALSE)) 
       
       Models <- apply(usematrix, 1, function(x) as.formula(paste(c("mpg ~ am", regressors[x]), collapse=" + ")))
       
       df <- lapply(Models,lm,data =mtcars)
       
       for (i in 1:256){
              if (summary(df[[i]])$adj.r.squared > fitmem) {
                     fitmem <- summary(df[[i]])$adj.r.squared
                     memdex <- i
              } 
              fitmem
              memdex
       }
}

summary(fit)$adj.r.squared